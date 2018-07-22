package experiments.atl2010

import experiments.utils.FullBenchmarkRunner
import m2m.batch.cps2dep.atl2010.files.Cps2Dep_atl
import org.eclipse.core.runtime.NullProgressMonitor

class Cps2DepRunner_Atl2010_full_publishSubscribe extends FullBenchmarkRunner {
	var Cps2Dep_atl runner
	var String fileNameSuffix
		
	override getIdentifier() {
		"cps2dep_publishSubscribe_atl2010"
	}
	
	override getIterations() {
//		#[1, 1, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384]
		#[1, 1, 8, 16, 32, 64, 128, 256, 512]
//		#[1]
	}

	def static void main(String[] args) {
		val runner = new Cps2DepRunner_Atl2010_full_publishSubscribe
		runner.runBenchmark(10)
	} 
    
	override doInitialization() {
		
	}
	
	override doLoad(String fileNameSuffix) {
		this.fileNameSuffix = fileNameSuffix
		var String inputModelPath = '''../m2m.batch.data/cps2dep/publishSubscribe/cps/publishSubscribe_«fileNameSuffix».cyberphysicalsystem.xmi'''   
		runner = new Cps2Dep_atl() 
		runner.loadModels(inputModelPath)  
	}
	
	override doTransformation() {
		runner.doCps2Dep_atl(new NullProgressMonitor())
	}
	
	override doSave(String iter) {
//		val outputModelPath = '''../m2m.batch.data/cps2dep/publishSubscribe/deployment/atl2010/publishSubscribe_«fileNameSuffix».deployment.xmi'''
//		runner.saveModels(outputModelPath)
	}
	
	override doDispose() {
		runner = null
	}
	
	
}