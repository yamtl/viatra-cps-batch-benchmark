package experiments.xtend

import experiments.utils.BenchmarkRunner
import java.io.File
import java.io.IOException
import java.util.Collections
import java.util.HashMap
import java.util.Map
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceImpl
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.XMLResource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.emf.ecore.xmi.impl.XMLParserPoolImpl
import org.eclipse.emf.ecore.xmi.impl.XMLResourceImpl
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage
import org.eclipse.viatra.examples.cps.deployment.DeploymentFactory
import org.eclipse.viatra.examples.cps.deployment.DeploymentPackage
import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment
import org.eclipse.viatra.examples.cps.traceability.TraceabilityFactory
import org.eclipse.viatra.examples.cps.traceability.TraceabilityPackage
import org.eclipse.viatra.examples.cps.xform.m2m.batch.simple.CPS2DeploymentBatchTransformationSimple

class Cps2Dep_XtendBatchRunner extends BenchmarkRunner {

	var CPS2DeploymentBatchTransformationSimple xform 
    var CPSToDeployment cps2dep
    
	override getIdentifier() {
		"cps2dep_clientServer_xtend_simple"
	}
	
	override getIterations() {
		#[1, 1, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384]
	}
    
	def static void main(String[] args) {
		
		val runner = new Cps2Dep_XtendBatchRunner
		runner.runBenchmark
	
	} 
		
	override doLoad(String iteration) {
		doStandaloneEMFSetup()
		
		var String inputModelPath = '''../m2m.batch.data/cps2dep/clientServer/cps'''
		var String outputModelPath = '''../m2m.batch.data/cps2dep/clientServer/deployment/xtendSimple'''

		cps2dep = preparePersistedCPSModel(
			URI.createFileURI(new File(inputModelPath).absolutePath),
			'''clientServer_«iteration»''',
			URI.createFileURI(new File(outputModelPath).absolutePath)
		)
	}
	
	override doInitialization() {
		// nothing to do
		xform = new CPS2DeploymentBatchTransformationSimple(cps2dep)
		
	}
	
	override doTransformation() {
		xform.execute
	}
	
	override doSave(String iter) {
		try {
	      cps2dep.deployment.eResource.save(Collections.EMPTY_MAP);
	    } catch (IOException e) {
	      e.printStackTrace();
	    }
		try {
	      cps2dep.eResource.save(Collections.EMPTY_MAP);
	    } catch (IOException e) {
	      e.printStackTrace();
	    }
	}
	
	override doDispose() {
		xform = null
		cps2dep = null
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////
	// SOLUTION SPECIFIC
	///////////////////////////////////////////////////////////////////////////////////////////
	def doStandaloneEMFSetup() {
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("*", new XMIResourceFactoryImpl());
		
		CyberPhysicalSystemPackage.eINSTANCE.eClass()
		DeploymentPackage.eINSTANCE.eClass()
		TraceabilityPackage.eINSTANCE.eClass()
	}
	
	def preparePersistedCPSModel(URI sourceUri, String modelName, URI targetUri) {
		val rs = new ResourceSetImpl()
		
		// register default factory - needed for standalone mode
		rs.getResourceFactoryRegistry().getExtensionToFactoryMap().
		put(
				Resource.Factory.Registry.DEFAULT_EXTENSION, 
				new XMIResourceFactoryImpl()
		);
		
		val modelNameURI = sourceUri.appendSegment(modelName)
		// Artur: use getResource instead of createResource for cps model
		val cpsRes = rs.createResource(modelNameURI.appendFileExtension("cyberphysicalsystem.xmi"))
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

		val targetModelNameURI = targetUri.appendSegment(modelName)
		val depRes = rs.createResource(targetModelNameURI.appendFileExtension("deployment.xmi"))
		val trcRes = rs.createResource(targetModelNameURI.appendFileExtension("traceability.xmi"))
		
		// Artur: to load the model
//		val cps = createCyberPhysicalSystem => [
//			identifier = modelName
//		]
//		cpsRes.contents += cps
		val cps = cpsRes.contents.head as CyberPhysicalSystem
		
		val dep = DeploymentFactory.eINSTANCE.createDeployment
		depRes.contents += dep
		 
		val cps2dep = TraceabilityFactory.eINSTANCE.createCPSToDeployment => [
			it.cps = cps
			it.deployment = dep
		]
		trcRes.contents += cps2dep
		cps2dep
	}

	
	
	
}