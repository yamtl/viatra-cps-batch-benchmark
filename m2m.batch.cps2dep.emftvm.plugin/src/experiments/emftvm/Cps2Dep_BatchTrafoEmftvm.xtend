package experiments.emftvm

import experiments.utils.GroovyUtil
import java.io.File
import java.io.IOException
import java.util.Collections
import java.util.Date
import java.util.HashMap
import java.util.Map
import java.util.TimeZone
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
import org.eclipse.xtext.util.Files

class Cps2Dep_BatchTrafoEmftvm  {
	
	extension val static GroovyUtil util = new GroovyUtil() 
    
//	def static doStandaloneEMFSetup() {
//		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("*", new XMIResourceFactoryImpl());
//		
//		CyberPhysicalSystemPackage.eINSTANCE.eClass()
//		DeploymentPackage.eINSTANCE.eClass()
//		TraceabilityPackage.eINSTANCE.eClass()
//	}
	
//	def static preparePersistedCPSModel(URI dirUri, String modelName) {
//		val rs = new ResourceSetImpl()
//		
//		// register default factory - needed for standalone mode
//		rs.getResourceFactoryRegistry().getExtensionToFactoryMap().
//		put(
//				Resource.Factory.Registry.DEFAULT_EXTENSION, 
//				new XMIResourceFactoryImpl()
//		);
//		
//		
//		
//		val modelNameURI = dirUri.appendSegment(modelName)
//		// Artur: use getResource instead of createResource for cps model
//		val cpsRes = rs.createResource(modelNameURI.appendFileExtension("cyberphysicalsystem.xmi"))
//		val Map<Object,Object> loadOptions = (cpsRes as XMLResourceImpl).getDefaultLoadOptions();
//		loadOptions.put(XMLResource.OPTION_DEFER_ATTACHMENT, Boolean.TRUE);
//		loadOptions.put(XMLResource.OPTION_DEFER_IDREF_RESOLUTION, Boolean.TRUE);
//		loadOptions.put(XMLResource.OPTION_USE_DEPRECATED_METHODS, Boolean.TRUE);
//		loadOptions.put(XMLResource.OPTION_USE_PARSER_POOL, new XMLParserPoolImpl());
//		loadOptions.put(XMLResource.OPTION_USE_XML_NAME_TO_FEATURE_MAP, new HashMap());
//		
//		(cpsRes as ResourceImpl).setIntrinsicIDToEObjectMap(new HashMap());
//		try {
//			cpsRes.load(null);
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//
//		val depRes = rs.createResource(modelNameURI.appendFileExtension("deployment.xmi"))
//		val trcRes = rs.createResource(modelNameURI.appendFileExtension("traceability.xmi"))
//		
//		// Artur: to load the model
////		val cps = createCyberPhysicalSystem => [
////			identifier = modelName
////		]
////		cpsRes.contents += cps
//		val cps = cpsRes.contents.head //as CyberPhysicalSystem
//		
//		val dep = DeploymentFactory.eINSTANCE.createDeployment
//		depRes.contents += dep
//		 
//		val cps2dep = TraceabilityFactory.eINSTANCE.createCPSToDeployment => [
//			it.cps = cps
//			it.deployment = dep
//		]
//		trcRes.contents += cps2dep
//		cps2dep
//	}
	
    
	def static void main(String[] args) {
		var long start 
		var long now 
		var long loadTime 
		var long preProcessTime 
		var long trafoTime 
		var long saveTime
		
//		doStandaloneEMFSetup()
		
		val String inputMMPath = '../m2m.batch.data/cps2dep/model/model.ecore'  
		val String outputMMPath = '../m2m.batch.data/cps2dep/model/deployment.ecore'  

		var String inputModelPath   
		var String outputModelPath  

		var results = "scale,load time (ms), pre-process time (ms), trafo time (ms), save time (ms),total tool-specific time (ms)\n"

		for (i : #[1, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384]) {
			var fileNameSuffix = i.toString().padLeft(5,'0')
			inputModelPath = '''../m2m.batch.data/cps2dep/clientServer/cps/clientServer_«fileNameSuffix».cyberphysicalsystem.xmi'''
			outputModelPath = '''../m2m.batch.data/cps2dep/clientServer/deployment/emftvm/clientServer-«fileNameSuffix».deployment.xmi'''
			
			println("---------------------------------------------------------------------")
			println('''transforming «inputModelPath»''')
			
			//////////////////////////////////////////////////////////////////////////
			// INITIALIZATION
			val ResourceSet rs = new ResourceSetImpl();
			// register default factory - needed for standalone mode
			rs.getResourceFactoryRegistry().getExtensionToFactoryMap().
			put(
					Resource.Factory.Registry.DEFAULT_EXTENSION,
					new XMIResourceFactoryImpl()
			);
			rs.getResourceFactoryRegistry().getExtensionToFactoryMap().put("emftvm", new EMFTVMResourceFactoryImpl());
			
			
			//////////////////////////////////////////////////////////////////////////
			// LOADING
			start = System.currentTimeMillis();
			val ExecEnv env = EmftvmFactory.eINSTANCE.createExecEnv();
			
			// Load metamodels
			val Metamodel metaModel = EmftvmFactory.eINSTANCE.createMetamodel();
			metaModel.setResource(rs.getResource(URI.createURI("http://www.eclipse.org/m2m/atl/2011/EMFTVM"), true));
			env.registerMetaModel("METAMODEL", metaModel);	
			now = System.currentTimeMillis();
			preProcessTime = now - start;
			
			
			
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
			val Model outModel = EmftvmFactory.eINSTANCE.createModel();
			outModel.setResource(rs.createResource(URI.createFileURI(outputModelPath)));
			env.registerOutputModel("OUT", outModel);
				
			now = System.currentTimeMillis();
			loadTime = now - start;
				
			
			//////////////////////////////////////////////////////////////////////////
			// PRE-PROCESSING
			start = System.currentTimeMillis();
			val ModuleResolver mr = new DefaultModuleResolver('./src/main/resources/atlFiles/', rs);
			val TimingData td = new TimingData();
			env.loadModule(mr, "Cps2Dep");  
			td.finishLoading();
			now = System.currentTimeMillis();
			preProcessTime = now - start;
			
			//////////////////////////////////////////////////////////////////////////
			// TRANSFORMATION
			start = System.currentTimeMillis();
			env.run(td);
			td.finish();
			now = System.currentTimeMillis();
			trafoTime = now - start;
			
			//////////////////////////////////////////////////////////////////////////
			// SAVE OUTPUT
			start = System.currentTimeMillis();

			outModel.getResource().save(Collections.emptyMap());
				
			now = System.currentTimeMillis();
			saveTime = now - start;
			
			println('''«fileNameSuffix» - time taken: «preProcessTime+trafoTime» ms''')
			
			results +=	'''«i»,«loadTime»,«preProcessTime»,«trafoTime»,«saveTime»,«preProcessTime+trafoTime»
			'''
			
			val timestamp = new Date().format("yyyyMMdd-HHmm", TimeZone.getTimeZone('UTC'))
			val outputFileName = '''Emftvm_results_cps2dep_«timestamp».csv'''
			
			Files.writeStringIntoFile(
				outputFileName,
				results
			)
			
						
		}
		
	}
	
	
}