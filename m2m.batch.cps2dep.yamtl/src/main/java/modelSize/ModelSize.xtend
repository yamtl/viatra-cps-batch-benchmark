package modelSize

import experiments.utils.GroovyUtil
import java.util.Collection
import java.util.Date
import java.util.TimeZone
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage
import org.eclipse.viatra.examples.cps.deployment.DeploymentPackage
import org.eclipse.viatra.examples.cps.traceability.TraceabilityPackage
import org.eclipse.xtext.util.Files
import yamtl.registry.EmfMetamodelRegistry

class ModelSize {
	extension val static GroovyUtil util = new GroovyUtil() 
	
	var static Resource cpsRes
	var static Resource depRes
	var static Resource tracRes
	
	def static doLoad(String iteration) {
		doStandaloneEMFSetup()
		
		var String inputModelPath = '''../m2m.batch.data/cps2dep/clientServer/cps'''
		var String outputModelPath = '''../m2m.batch.data/cps2dep/clientServer/deployment/yamtl'''
//		var String inputModelPath = '''../m2m.batch.data/cps2dep/publishSubscribe/cps'''
//		var String outputModelPath = '''../m2m.batch.data/cps2dep/publishSubscribe/deployment/yamtl'''

		val EmfMetamodelRegistry registry = new EmfMetamodelRegistry
		
		val String suffix = iteration.padLeft(6,'0')
		
		cpsRes = registry.loadModelEagerly('''«inputModelPath»/clientServer_«suffix».cyberphysicalsystem.xmi''', false)
		depRes = registry.loadModelEagerly('''«outputModelPath»/clientServer-«suffix».deployment.xmi''', false)
		tracRes = registry.loadModelEagerly('''«outputModelPath»/clientServer-«suffix».traceability.xmi''', false)
//		cpsRes = registry.loadModelEagerly('''«inputModelPath»/publishSubscribe_«suffix».cyberphysicalsystem.xmi''', false)
//		depRes = registry.loadModelEagerly('''«outputModelPath»/publishSubscribe-«suffix».deployment.xmi''', false)
//		tracRes = registry.loadModelEagerly('''«outputModelPath»/publishSubscribe-«suffix».traceability.xmi''', false)
	}
	
	
	def static numberOfNodes(Resource r) {
		r.allContents.size
	}
	
	def static numberOfEdges(Resource r) {
		var noEdges = 0
		for (EObject o : r.allContents.toList) {
			for (EReference ref: o.eClass.EAllReferences) {
				if (o.eIsSet(ref)) {
					val list = o.eGet(ref)
					if (Collection.isInstance(list)) {
						noEdges += (list as Collection).size
					} else {
						noEdges ++
					}
				}
			}
		}
		noEdges
	}
	
	def static doStandaloneEMFSetup() {
		Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap().put("*", new XMIResourceFactoryImpl());
		
		CyberPhysicalSystemPackage.eINSTANCE.eClass()
		DeploymentPackage.eINSTANCE.eClass()
		TraceabilityPackage.eINSTANCE.eClass()
	}
	
	def public static main(String[] args) {
		var String model = 'clientServer'
//		var String model = 'publishSubscribe'
		var String csvOutput = '''iter, cps («model») nodes, cps («model») edges, dep («model») nodes, dep («model») edges, trac («model») nodes, trac («model») edges, «model» total nodes, «model» total edges
		'''
		for (iter : #[1, 1, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768]) {
			doLoad(String.valueOf(iter))
			
			val cpsNodes = cpsRes.numberOfNodes
			val cpsEdges = cpsRes.numberOfEdges
			val depNodes = depRes.numberOfNodes
			val depEdges = depRes.numberOfEdges
			val tracNodes = tracRes.numberOfNodes
			val tracEdges = tracRes.numberOfEdges
			val totalNodes = cpsNodes + depNodes + tracNodes
			val totalEdges = cpsEdges + depEdges + tracEdges
			
			csvOutput += '''«iter», «cpsNodes», «cpsEdges», «depNodes», «depEdges», «tracNodes», «tracEdges», «totalNodes», «totalEdges»
			'''
			println('''iter «iter»: cps size (nodes,edges)=<«cpsNodes»; «cpsEdges»>; dep nodes (nodes,edges)=<«depNodes»; «depEdges»>; trac nodes (nodes,edges)=<«tracNodes»; «tracEdges»>''')
		}
		
		val timestamp = new Date().format("yyyyMMdd-HHmm", TimeZone.getTimeZone('UTC'))
		val outputFileName = '''«model»_«timestamp».csv'''
		
		// store file during iteration to avoid waiting for large models
		Files.writeStringIntoFile(
			"size_" + outputFileName,
			csvOutput
		)
	}
}