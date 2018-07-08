package experiments.utils

import com.google.common.testing.GcFinalization
import java.io.File
import java.util.Date
import java.util.List
import java.util.TimeZone
import org.eclipse.xtext.util.Files

abstract class BenchmarkRunner  {
	
	extension val static GroovyUtil util = new GroovyUtil() 

    def abstract void doLoad(String iteration)
    def abstract void doInitialization(String iteration)
    def abstract void doTransformation(String iteration)
    def abstract void doSave(String iteration)
    def abstract void doDispose()
    
    def abstract List<Integer> getIterations() 
    def abstract String getIdentifier() 
	
	def runBenchmark() 
	{
		// bytes
		var long memoryBeforeLoadingModels
		var long memoryAfterLoadingModels
		var long memoryBeforeInitialization
		var long memoryAfterInitialization
		var long memoryBeforeTransformation
		var long memoryAfterTransformation
		
		var long start 
		var long now 
		var long loadTime 
		var long preProcessTime 
		var long trafoTime 
		var long saveTime
		var String previousFileName
		
		var results = "scale,load time (ms), pre-process time (ms), trafo time (ms), save time (ms),total tool-specific time (ms)\n"
		var resultsMemory = "scale,before loading (Mb), after loading (Mb), after initialization (Mb), after transformation (Mb), used during loading (Mb), used during initialization (Mb), used during transformation (Mb)\n"
		
		var list = getIterations

		for (i : list) {
			var fileNameSuffix = i.toString().padLeft(6,'0')

			println("------------------------------------------------------------------------")
			println('''transforming «fileNameSuffix»''')
			
			
			// MEMORY usage measurement: from https://wiki.eclipse.org/VIATRA/Query/FAQ#Best_practices
			System.gc();
			System.gc();
			System.gc();
			System.gc();
			System.gc();
			
			// https://stackoverflow.com/a/27831908
			GcFinalization.awaitFullGc();
			   
			try {
			  Thread.sleep(1000); // wait for the GC to settle
			} catch (InterruptedException e) { 
				// TODO handle exception properly 
			}

			//////////////////////////////////////////////////////////////////////////
			// LOAD
			memoryBeforeLoadingModels = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
			start = System.currentTimeMillis();
			doLoad(fileNameSuffix)
			now = System.currentTimeMillis();
			loadTime = now - start;
			memoryAfterLoadingModels = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
			
			//////////////////////////////////////////////////////////////////////////
			// PRE-PROCESSING
			memoryBeforeInitialization = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
			start = System.currentTimeMillis();
			doInitialization(fileNameSuffix)
			now = System.currentTimeMillis();
			preProcessTime = now - start;
			memoryAfterInitialization = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
			
			//////////////////////////////////////////////////////////////////////////
			// TRANSFORMATION
			memoryBeforeTransformation = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
			start = System.currentTimeMillis();
			doTransformation(fileNameSuffix)
			now = System.currentTimeMillis();
			trafoTime = now - start;
			memoryAfterTransformation = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
			
			println('''time taken: «preProcessTime+trafoTime» ms''')
			println('''memory taken: «((memoryAfterInitialization-memoryAfterInitialization)+(memoryAfterTransformation-memoryBeforeTransformation)).toMb» MB''')
			
			//////////////////////////////////////////////////////////////////////////
			// SAVE OUTPUT
			start = System.currentTimeMillis();
			doSave(fileNameSuffix)
			now = System.currentTimeMillis();
			saveTime = now - start;

			//////////////////////////////////////////////////////////////////////////
			// CLEAN MEMORY
			doDispose
			
			////////////////////////////////////////////////////////////////////////
			// BENCHMARKS RESULTS FOR THE ITERATION

			results +=	'''«i»,«loadTime»,«preProcessTime»,«trafoTime»,«saveTime»,«preProcessTime+trafoTime»
			'''
			resultsMemory += '''«i»,«memoryBeforeLoadingModels.toMb»,«memoryAfterLoadingModels.toMb»,«memoryAfterInitialization.toMb»,«memoryAfterTransformation.toMb»,«(memoryAfterLoadingModels-memoryBeforeLoadingModels).toMb»,«(memoryAfterInitialization-memoryAfterLoadingModels).toMb»,«(memoryAfterTransformation-memoryAfterInitialization).toMb»
			'''
			
			val timestamp = new Date().format("yyyyMMdd-HHmm", TimeZone.getTimeZone('UTC'))
			val outputFileName = '''«identifier»_«timestamp».csv'''
			val outputMemoryFileName = '''«identifier»_«timestamp».csv'''
			
			// store file during iteration to avoid waiting for large models
			Files.writeStringIntoFile(
				"results_" + outputFileName,
				results
			)
			Files.writeStringIntoFile(
				"resultsMemory_" + outputMemoryFileName,
				resultsMemory
			)
			
			// delete file generated for previous iteration
			if ((previousFileName !== null) && (previousFileName != outputFileName))  
			{
				new File("results_" + previousFileName).delete	
				new File("resultsMemory_" + previousFileName).delete	
			}
			previousFileName = outputFileName
			
									
		}
		
	}
	
	
	def toMb(long value) {
		value/(1024*1024) // Mbs
	}
	
}