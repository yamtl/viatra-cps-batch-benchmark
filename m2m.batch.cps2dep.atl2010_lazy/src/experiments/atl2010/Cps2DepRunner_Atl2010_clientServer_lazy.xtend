package experiments.atl2010

import experiments.utils.BenchmarkRunner
import m2m.batch.cps2dep.atl2010.files.Cps2Dep_atl
import org.eclipse.core.runtime.NullProgressMonitor

class Cps2DepRunner_Atl2010_clientServer_lazy extends BenchmarkRunner {
	var Cps2Dep_atl runner
	var String fileNameSuffix
		
	override getIdentifier() {
		"cps2dep_clientServer_atl2010_lazy"
	}
	
	override getIterations() {
		#[1, 1, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768]
//		#[1, 1, 8, 16, 32, 64, 128, 256]
//		#[1]
	}

	def static void main(String[] args) {
		val runner = new Cps2DepRunner_Atl2010_clientServer_lazy
		runner.runBenchmark
	} 
    
	override doInitialization() {
		
	}
	
	override doLoad(String fileNameSuffix) {
		this.fileNameSuffix = fileNameSuffix
		var String inputModelPath = '''../m2m.batch.data/cps2dep/clientServer/cps/clientServer_«fileNameSuffix».cyberphysicalsystem.xmi'''   
//		var String inputModelPath = '''../m2m.batch.data/cps2dep/publishSubscribe/cps/publishSubscribe_«fileNameSuffix».cyberphysicalsystem.xmi'''   
		runner = new Cps2Dep_atl() 
		runner.loadModels(inputModelPath)  
	}
	
	override doTransformation() {
		runner.doCps2Dep_atl(new NullProgressMonitor())
	}
	
	override doSave(String iter) {
//		val outputModelPath = '''../m2m.batch.data/cps2dep/clientServer/deployment/atl2010/clientServer_«fileNameSuffix».deployment.xmi'''
////		val outputModelPath = '''../m2m.batch.data/cps2dep/publishSubscribe/deployment/atl2010/publishSubscribe_«fileNameSuffix».deployment.xmi'''
//		runner.saveModels(outputModelPath)
	}
	
	override doDispose() {
		runner = null
	}
	
	
}