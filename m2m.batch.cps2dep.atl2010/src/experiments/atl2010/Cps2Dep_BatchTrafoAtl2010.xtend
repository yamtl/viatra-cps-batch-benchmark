package experiments.atl2010

import experiments.utils.GroovyUtil
import java.util.Collections
import java.util.Date
import java.util.TimeZone
import m2m.batch.cps2dep.atl2010.files.Cps2Dep_atl
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.xtext.util.Files

class Cps2Dep_BatchTrafoAtl2010  {
	
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
			outputModelPath = '''../m2m.batch.data/cps2dep/clientServer/deployment/atl2010/clientServer-«fileNameSuffix».deployment.xmi'''
			
			println("---------------------------------------------------------------------")
			println('''transforming «inputModelPath»''')
			
			//////////////////////////////////////////////////////////////////////////
			// INITIALIZATION
			
			
			//////////////////////////////////////////////////////////////////////////
			// LOADING
			start = System.currentTimeMillis();
			val Cps2Dep_atl runner = new Cps2Dep_atl() 
			runner.loadModels(inputModelPath)
			now = System.currentTimeMillis();
			loadTime = now - start;
				
			
			//////////////////////////////////////////////////////////////////////////
			// PRE-PROCESSING
			start = System.currentTimeMillis();
			
			now = System.currentTimeMillis();
			preProcessTime = now - start;
			
			//////////////////////////////////////////////////////////////////////////
			// TRANSFORMATION
			start = System.currentTimeMillis();
			runner.doCps2Dep_atl(new NullProgressMonitor())
			now = System.currentTimeMillis();
			trafoTime = now - start;
			
			//////////////////////////////////////////////////////////////////////////
			// SAVE OUTPUT
			start = System.currentTimeMillis();

			runner.saveModels(outputModelPath)
				
			now = System.currentTimeMillis();
			saveTime = now - start;
			
			println('''«fileNameSuffix» - time taken: «preProcessTime+trafoTime» ms''')
			
			results +=	'''«i»,«loadTime»,«preProcessTime»,«trafoTime»,«saveTime»,«preProcessTime+trafoTime»
			'''
			
			val timestamp = new Date().format("yyyyMMdd-HHmm", TimeZone.getTimeZone('UTC'))
			val outputFileName = '''ATL2010_results_cps2dep_«timestamp».csv'''
			
			Files.writeStringIntoFile(
				outputFileName,
				results
			)
			
						
		}
		
	}
	
	
}