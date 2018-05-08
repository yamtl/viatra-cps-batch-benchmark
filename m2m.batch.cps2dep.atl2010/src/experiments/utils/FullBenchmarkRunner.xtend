package experiments.utils

import com.google.common.testing.GcFinalization
import java.io.File
import java.util.Date
import java.util.List
import java.util.TimeZone
import org.eclipse.xtext.util.Files

abstract class FullBenchmarkRunner  {
	
	extension val static GroovyUtil util = new GroovyUtil() 

    def abstract void doLoad(String iteration)
    def abstract void doInitialization()
    def abstract void doTransformation()
    def abstract void doSave(String iteration)
    def abstract void doDispose()
    
    def abstract List<Integer> getIterations() 
    def abstract String getIdentifier() 
	
	def runBenchmark(int times) 
	{
		// bytes
		var long memoryBeforeLoadingModels
		var long memoryAfterLoadingModels
		var long memoryBeforeInitialization
		var long memoryAfterInitialization
		var long memoryBeforeTransformation
		var long memoryAfterTransformation
		var long memoryBeforeSaving
		var long memoryAfterSaving
		
		var long start 
		var long now 
		var long loadTime 
		var long preProcessTime 
		var long trafoTime 
		var long saveTime
		var String previousFileName
		
		var List<PerformanceResult> iterPerformanceResults = newArrayList
		var List<MemoryResult> iterMemoryResults = newArrayList
				
		var results = "scale"
		
		for (i: 0 ..< times+2) {
			results += ''', load «i» (ms), pre-process «i» (ms), trafo «i» (ms), save «i» (ms), total tool-specific iter«i» (ms)'''
		}
		results += ", avg of inner 10 results (ms), median of inner 10 results (ms)\n"
		
		var resultsMemory = "scale"
		for (i: 0 ..< times+2) {
			resultsMemory += ''', load «i» (MB), init «i» (MB), trafo «i» (MB), save «i» (MB), total «i» (MB)'''
		}
		resultsMemory += ", avg of inner 10 results (MB), median of inner 10 results (MB)\n"
		
		var list = getIterations

		for (i : list) {
			var fileNameSuffix = i.toString().padLeft(6,'0')

			println("------------------------------------------------------------------------")
			println('''transforming «fileNameSuffix»''')
			
			results += '''«i»'''
			resultsMemory += '''«i»'''
			
			
			iterPerformanceResults = newArrayList
			iterMemoryResults = newArrayList
			for (iter : 0 ..< times+2) { 
				
				freeGC()

				//////////////////////////////////////////////////////////////////////////
				// LOAD
				memoryBeforeLoadingModels = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
				start = System.currentTimeMillis();
				doLoad(fileNameSuffix)
				now = System.currentTimeMillis();
				loadTime = now - start;
				memoryAfterLoadingModels = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();

				freeGC()
			
				//////////////////////////////////////////////////////////////////////////
				// PRE-PROCESSING
				memoryBeforeInitialization = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
				start = System.currentTimeMillis();
				doInitialization
				now = System.currentTimeMillis();
				preProcessTime = now - start;
				memoryAfterInitialization = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();

				freeGC()
				
				//////////////////////////////////////////////////////////////////////////
				// TRANSFORMATION
				memoryBeforeTransformation = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
				start = System.currentTimeMillis();
				doTransformation
				now = System.currentTimeMillis();
				trafoTime = now - start;
				memoryAfterTransformation = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();

				freeGC()
				
				//////////////////////////////////////////////////////////////////////////
				// SAVE OUTPUT
				memoryBeforeSaving = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
				start = System.currentTimeMillis();
				doSave(fileNameSuffix)
				now = System.currentTimeMillis();
				saveTime = now - start;
				memoryAfterSaving = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();

				// SAVING ITER RESULTS
				val result = new PerformanceResult(loadTime, preProcessTime, trafoTime, saveTime)
				iterPerformanceResults.add(
					result
				)
//				results += ''', «result.loadTime», «result.initTime», «result.trafoTime», «result.saveTime», «result.totalTime»'''
				
				val memoryResult = new MemoryResult(
					memoryAfterLoadingModels-memoryBeforeLoadingModels,
					memoryAfterInitialization-memoryBeforeInitialization, 
					memoryAfterTransformation-memoryBeforeTransformation,
					memoryAfterSaving-memoryBeforeSaving
				)
				iterMemoryResults.add(
					memoryResult
				)
//				resultsMemory += ''', «memoryResult.loadMemory.toMB», «memoryResult.initMemory.toMB», «memoryResult.trafoMemory.toMB», «memoryResult.saveMemory.toMB», «memoryResult.totalMemory.toMB»'''
				
			}
		


		
			////////////////////////////////////////////////////////////////////////
			// BENCHMARKS RESULTS FOR THE ITERATION
							
			// PERFORMANCE
			iterPerformanceResults.sortInplaceBy[totalTime]
			val long median=iterPerformanceResults.subList(1,11).map[totalTime].median
			val long avg=iterPerformanceResults.subList(1,11).map[totalTime].reduce[ a, b | a + b ] / times
			
			println('''time taken: «median» ms''')
			
			results += ''
			
			// we have deleted min, max
			for (j: 0 ..< times+2) {
				val PerformanceResult result = iterPerformanceResults.get(j)
				results += ''', «result.loadTime», «result.initTime», «result.trafoTime», «result.saveTime», «result.totalTime»'''
			}
			results += ''',«avg», «median»
			'''
			
			
			// MEMORY			
			iterMemoryResults.sortInplaceBy[totalMemory]
			val long memoryMedian=iterMemoryResults.subList(1,11).map[totalMemory].median
			val long memoryAvg=iterMemoryResults.subList(1,11).map[totalMemory].reduce[ a, b | a + b ] / times
			println('''memory taken: «memoryMedian.toMB» MB''')
			
			resultsMemory += ''
			// we have deleted min, max
			for (j: 0 ..< times+2) {
				val MemoryResult result = iterMemoryResults.get(j)
				resultsMemory += ''', «result.loadMemory.toMB», «result.initMemory.toMB», «result.trafoMemory.toMB», «result.saveMemory.toMB», «result.totalMemory.toMB»'''
			}
			resultsMemory += ''',«memoryAvg.toMB», «memoryMedian.toMB»
			'''
			
			//////////////////////////////////////////////////////////////////////////
			// CLEAN MEMORY
			doDispose
			
			
			// Append loading/saving times
//			results =	'''«i»,«loadTime»,«saveTime»''' + results
//			resultsMemory = '''«i»,«(memoryAfterLoadingModels-memoryBeforeLoadingModels).toMB»,«(memoryAfterSaving-memoryAfterTransformation).toMB»''' + resultsMemory
			
			
			// FLUSH TO FILE
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
	
	def static long median(long[] m) {
		// sort list in ascending order
		m.sortInplace
		
	    val int middle = m.length/2;
	    if (m.length%2 == 1) {
	        return m.get(middle);
	    } else {
	        return (m.get(middle) + m.get(middle)) / 2;
	    }
	}
	
	def toMB(long value) {
		value/(1024*1024) // Mbs
	}
	
	def freeGC() {
		// MEMORY usage measurement: from https://wiki.eclipse.org/VIATRA/Query/FAQ#Best_practices
		System.gc();
		System.gc();
		System.gc();
		System.gc();
		System.gc();
		
		try {
		  Thread.sleep(1000); // wait for the GC to settle
		} catch (InterruptedException e) { 
			// TODO handle exception properly 
		}
		
		// https://stackoverflow.com/a/27831908
		GcFinalization.awaitFullGc();
	}
}