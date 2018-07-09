package experiments.yamtl

import cps2dep.yamtl.Cps2DepYAMTL
import experiments.utils.BenchmarkRunner
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage
import org.eclipse.viatra.examples.cps.deployment.DeploymentPackage
import org.eclipse.viatra.examples.cps.traceability.TraceabilityFactory
import org.eclipse.viatra.examples.cps.traceability.TraceabilityPackage

class Cps2DepRunner_publishSubscribe_YAMTL extends BenchmarkRunner {

	var Cps2DepYAMTL xform 
	var List<EObject> rootObjects 
    
    val ROOT_PATH = '../'
    
	override getIdentifier() {
//		"cps2dep_clientServer_yamtl"
		"cps2dep_publishSubscribe_yamtl"
	}
	
	override getIterations() {
		#[1, 1, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768]
//		#[1, 1, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384]
//		#[1, 16384]
//		#[1]
	}
    
	def static void main(String[] args) {
		
		val runner = new Cps2DepRunner_publishSubscribe_YAMTL
		runner.runBenchmark
	
	} 

	// in our case
	// TODO: initialization should be performed before loading models	
	override doLoad(String iteration) {
		doStandaloneEMFSetup()
		
		
		
//		var String inputModelPath = '''../m2m.batch.data/cps2dep/clientServer/iter2/xmi/clientServer_«iteration».cyberphysicalsystem.xmi'''
//		var String outputModelPath = '''../m2m.batch.data/cps2dep/clientServer/deployment/yamtl/clientServer-«iteration».deployment.xmi'''
		var String inputModelPath = '''«ROOT_PATH»/m2m.batch.data/cps2dep/publishSubscribe/cps/publishSubscribe_«iteration».cyberphysicalsystem.xmi'''
		
		

		xform = new Cps2DepYAMTL
		xform.fromRoots = false

		
		// prepare models
		// this will normally be outside the trafo declaration
		xform.loadInputModels(#{'cps' -> inputModelPath})
		val cpsRes = xform.getModelResource('cps')
		xform.mapping = TraceabilityFactory.eINSTANCE.createCPSToDeployment => [
			it.cps = cpsRes.contents.head as CyberPhysicalSystem
		]
		
	}
	
	override doInitialization(String iteration) {
		// nothing to do
	}
	
	override doTransformation(String iteration) {
		xform.execute()
		xform.getTraceModel()
	}
	
	override doSave(String iteration) {
//		var String outputModelPath = '''«ROOT_PATH»/m2m.batch.data/cps2dep/publishSubscribe/deployment/yamtl/publishSubscribe-«iteration».deployment.xmi'''
//		xform.saveOutputModels(#{'dep' -> outputModelPath})
//		
//		var String outputTraceModelPath = '''«ROOT_PATH»/m2m.batch.data/cps2dep/publishSubscribe/deployment/yamtl/publishSubscribe-«iteration».traceability.xmi'''
//		println("save traceability: " + outputTraceModelPath)
//		xform.saveTraceModel(outputTraceModelPath)
	}
	
	override doDispose() {
		xform = null
		rootObjects = null
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
}