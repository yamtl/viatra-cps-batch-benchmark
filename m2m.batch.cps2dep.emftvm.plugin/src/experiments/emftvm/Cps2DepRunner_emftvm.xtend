package experiments.emftvm

import experiments.utils.BenchmarkRunner
import java.io.File
import java.io.IOException
import java.util.Collections
import java.util.HashMap
import java.util.Map
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceImpl
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.XMLResource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.emf.ecore.xmi.impl.XMLParserPoolImpl
import org.eclipse.emf.ecore.xmi.impl.XMLResourceImpl
import org.eclipse.m2m.atl.emftvm.EmftvmFactory
import org.eclipse.m2m.atl.emftvm.ExecEnv
import org.eclipse.m2m.atl.emftvm.Metamodel
import org.eclipse.m2m.atl.emftvm.Model
import org.eclipse.m2m.atl.emftvm.impl.resource.EMFTVMResourceFactoryImpl
import org.eclipse.m2m.atl.emftvm.util.DefaultModuleResolver
import org.eclipse.m2m.atl.emftvm.util.ModuleResolver
import org.eclipse.m2m.atl.emftvm.util.TimingData

class Cps2DepRunner_emftvm extends BenchmarkRunner {
	var ExecEnv env
	var ResourceSet rs
	var TimingData td 
	var Model outModel 
		
	override getIdentifier() {
//		"cps2dep_clientServer_atl2010"
		"cps2dep_publishSubscribe_atl2010"
	}
	
	override getIterations() {
//		#[1, 1, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384]
//		#[1, 1, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192]
		#[1]
	}

	def static void main(String[] args) {
		
		val runner = new Cps2DepRunner_emftvm
		runner.runBenchmark
	
	} 
	
	override doLoad(String fileNameSuffix) {
				
		val String inputMMPath = '../m2m.batch.data/cps2dep/model/model.ecore'  
		val String outputMMPath = '../m2m.batch.data/cps2dep/model/deployment.ecore'  
//		val String inputModelPath = '''../m2m.batch.data/cps2dep/clientServer/cps/clientServer_«fileNameSuffix».cyberphysicalsystem.xmi'''   
//		val outputModelPath = '''../m2m.batch.data/cps2dep/clientServer/deployment/emftvm/clientServer-«fileNameSuffix».deployment.xmi'''
		val String inputModelPath = '''../m2m.batch.data/cps2dep/publishSubscribe/cps/publishSubscribe_«fileNameSuffix».cyberphysicalsystem.xmi'''   
		val outputModelPath = '''../m2m.batch.data/cps2dep/publishSubscribe/deployment/emftvm/publishSubscribe_«fileNameSuffix».deployment.xmi'''
		
		rs = new ResourceSetImpl();
		// register default factory - needed for standalone mode
		rs.getResourceFactoryRegistry().getExtensionToFactoryMap().
		put(
				Resource.Factory.Registry.DEFAULT_EXTENSION,
				new XMIResourceFactoryImpl()
		);
		rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("emftvm", new EMFTVMResourceFactoryImpl());

		env = EmftvmFactory.eINSTANCE.createExecEnv();
			
		// Load metamodels
		val Metamodel metaModel = EmftvmFactory.eINSTANCE.createMetamodel();
		metaModel.setResource(rs.getResource(URI.createURI("http://www.eclipse.org/m2m/atl/2011/EMFTVM"), true));
		env.registerMetaModel("METAMODEL", metaModel);	

		// source metamodel: load on demand
		val Resource inputMMRes = rs.getResource(URI.createFileURI(new File(inputMMPath).absolutePath), true)
		var EPackage pk = inputMMRes.contents.get(0) as EPackage
		rs.getPackageRegistry().put(
			pk.nsURI,
			pk
		);
		val Metamodel inputMetaModel = EmftvmFactory.eINSTANCE.createMetamodel();
		inputMetaModel.setResource(inputMMRes);
		env.registerMetaModel("CPS", inputMetaModel);
		
		// target metamodel: load on demand
		val Resource outputMMRes = rs.getResource(URI.createFileURI(new File(outputMMPath).absolutePath), true)
		pk = outputMMRes.contents.get(0) as EPackage
		rs.getPackageRegistry().put(
			pk.nsURI,
			pk
		);
		val Metamodel outputMetaModel = EmftvmFactory.eINSTANCE.createMetamodel();
		outputMetaModel.setResource(outputMMRes);
		env.registerMetaModel("DEP", outputMetaModel);
		
		// Load models
		val Model inModel = EmftvmFactory.eINSTANCE.createModel();
		
//			inModel.setResource(rs.getResource(URI.createFileURI(inputModelPath), true));
		
		// ARTUR
		val cpsRes = rs.createResource(URI.createFileURI(inputModelPath))
		val Map<Object,Object> loadOptions = (cpsRes as XMLResourceImpl).getDefaultLoadOptions();
		loadOptions.put(XMLResource.OPTION_DEFER_ATTACHMENT, Boolean.TRUE);
		loadOptions.put(XMLResource.OPTION_DEFER_IDREF_RESOLUTION, Boolean.TRUE);
		loadOptions.put(XMLResource.OPTION_USE_DEPRECATED_METHODS, Boolean.TRUE);
		loadOptions.put(XMLResource.OPTION_USE_PARSER_POOL, new XMLParserPoolImpl());
		loadOptions.put(XMLResource.OPTION_USE_XML_NAME_TO_FEATURE_MAP, new HashMap());
		
		(cpsRes as ResourceImpl).setIntrinsicIDToEObjectMap(new HashMap());
		try {
			cpsRes.load(null);
		} catch (IOException e) {
			e.printStackTrace();
		}
		// ARTUR

		inModel.setResource(cpsRes);
		env.registerInputModel("IN", inModel);
		outModel = EmftvmFactory.eINSTANCE.createModel();
		outModel.setResource(rs.createResource(URI.createFileURI(outputModelPath)));
		env.registerOutputModel("OUT", outModel);
	}
	
	
	override doInitialization() {
		val ModuleResolver mr = new DefaultModuleResolver('../m2m.batch.data/atlFiles/', rs);
		td = new TimingData();
		env.loadModule(mr, "Cps2Dep");  
		td.finishLoading();
	}
	
	override doTransformation() {
		env.run(td);
		td.finish();	
	}
	
	override doSave(String iter) {
		outModel.getResource().save(Collections.emptyMap());
	}
	
	override doDispose() {
		env = null
		rs = null
		td = null
		outModel = null		
	}
}