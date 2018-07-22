package experiments.utils

import com.google.common.testing.GcFinalization
import java.io.File
import java.util.Date
import java.util.List
import java.util.TimeZone
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.util.Files

abstract class FullBenchmarkRunner  {
	@Accessors 
	public boolean debug = false 
	
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
		var double loadTime 
		var double preProcessTime 
		var double trafoTime 
		var double saveTime
		var String previousFileName
		
		var List<PerformanceResult> iterPerformanceResults = newArrayList
		var List<MemoryResult> iterMemoryResults = newArrayList
				
		var results = "scale"
		
		for (i: 0 ..< times+2) {
			results += ''', load «i» (ms), pre-process «i» (ms), trafo «i» (ms), save «i» (ms), total tool-specific iter«i» (ms)'''
		}
		results += ", avg of inner 10 results (ms), median of 1st Xform, median of 2nd Xform, median of total time - 10 results (ms)\n"
		
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
				start = System.nanoTime();
				doLoad(fileNameSuffix)
				now = System.nanoTime();
				loadTime = (now - start) / 1000000 as double;
				memoryAfterLoadingModels = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();

				if (debug) println('''load time: «loadTime»''')
				freeGC()
			
				//////////////////////////////////////////////////////////////////////////
				// PRE-PROCESSING
				memoryBeforeInitialization = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
				start = System.nanoTime();
				doInitialization
				now = System.nanoTime();
				preProcessTime = (now - start) / 1000000 as double;
				memoryAfterInitialization = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();

				if (debug) println('''pre-process time: «preProcessTime»''')
				freeGC()
				
				//////////////////////////////////////////////////////////////////////////
				// TRANSFORMATION
				memoryBeforeTransformation = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
				start = System.nanoTime();
				doTransformation
				now = System.nanoTime();
				trafoTime = (now - start) / 1000000 as double;
				memoryAfterTransformation = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();

				if (debug) {
					println('''trafo time: «start»''')
					println('''trafo time: «now»''')
					println('''trafo time: «now-start»''')
					println('''trafo time: «trafoTime»''')
				}
				freeGC()
				
				//////////////////////////////////////////////////////////////////////////
				// SAVE OUTPUT
				memoryBeforeSaving = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
				start = System.nanoTime();
				doSave(fileNameSuffix)
				now = System.nanoTime();
				saveTime = (now - start) / 1000000 as double;
				memoryAfterSaving = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();

				if (debug) println('''save time: «saveTime»''')
				
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
			val double median1stXform=iterPerformanceResults.subList(1,11).map[initTime].median
			val double median2ndXform=iterPerformanceResults.subList(1,11).map[it.trafoTime].median
			val double median=iterPerformanceResults.subList(1,11).map[totalTime].median
			val double avg=iterPerformanceResults.subList(1,11).map[totalTime].reduce[ a, b | a + b ] / times
			
			println('''time taken (init/1st Xform): «median1stXform» ms''')
			println('''time taken (batch trafo/update + 2nd Xform): «median2ndXform» ms''')
			println('''time taken: «median» ms''')
			
			results += ''
			
			// we have deleted min, max
			for (j: 0 ..< times+2) {
				val PerformanceResult result = iterPerformanceResults.get(j)
				results += ''', «result.loadTime», «result.initTime», «result.trafoTime», «result.saveTime», «result.totalTime»'''
			}
			results += ''',«avg», «median1stXform», «median2ndXform», «median»
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
	def static double median(double[] m) {
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