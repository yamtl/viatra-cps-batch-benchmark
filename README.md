# Adaptation of the batch component of the VIATRA CPS benchmark

This benchmark is an adaptation of the batch component of the [VIATRA CPS benchmark](https://github.com/viatra/viatra-cps-benchmark) for analyzing the performance of the [YAMTL model transformation engine](https://yamtl.github.io).

The experiments performed with this benchmark were used to inform the conclusions of the following publication:

*Artur Boronat. Expressive and Efficient Model Transformation with an Internal DSL of Xtend. MODELS 2018.*

In the following:
* pointers to the specification of the original benchmark are given and the main differences with our variant are explained, including the methodology used;
* pointers to the solutions used in our benchmark are given, including the input models that have been used; and 
* the specific details used for each experiment and the obtained raw results are provided.

## Benchmark Specification

The specification of metamodels and transformations used in original benchmark can be found [here](https://github.com/viatra/viatra-cps-benchmark/wiki/Benchmark-specification), including the [transformation specification](https://github.com/viatra/viatra-docs/blob/master/cps/CPS-to-Deployment-Transformation.adoc).

The different solutions provided in the VIATRA CPS benchmark can be found [here](https://github.com/viatra/viatra-docs/blob/master/cps/Alternative-transformation-methods.adoc).


## Main differences with the VIATRA CPS Benchmark

* Our study has focussed on the batch component of the VIATRA CPS benchmark and incremental solutions have not been considered. Such solutions show worse performance when applied as batch transformations, hence including them would not have altered the conclusions obtained. See the transformations used in our experiments [below](#model-transformations-used-for-the-experiments).
* The official VIATRA CPS benchmark uses a [model generator](https://github.com/viatra/viatra-docs/blob/master/cps/Model-Generator.adoc) to produce models for each benchmark instance. Although this does not affect the validity of the conclusions in our study, the raw results that are obtained in the two variant of the benchmark may differ. We are working with the VIATRA team to integrate the YAMTL solution into the live benchmark so that our solution can be used in the official variant of the benchmark framework. Follow the discussion [here](https://github.com/viatra/viatra-cps-benchmark/issues/23). The models that have been used in our experiments can be found [below](#input-models-used).
* The VIATRA CPS Benchmark is quite comprehensive in nature, including a model generator, model-to-text evaluation, evaluation on a continuous integration server. We removed the parts that were not deemed to be essential for our study, simplifying the framework. This means that we had to develop a new benchmark harness, which can be found [here](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.cps2dep.yamtl/src/main/java/experiments/utils/FullBenchmarkRunner.xtend), which works as follows:
  * For each tool and scenario, the experiments are run in separate Java process. For each of the input models, we perform an initial experiment for [warming up the JVM](http://www.baeldung.com/java-jvm-warmup) and, then, perform twelve experiments. Each experiment consists of four phases: model load, engine initialization, initial transformation, and model storage. In between each execution phase, the harness sends hints to the JVM to run garbage collection and waits for one second before proceeding on to the next phase. 
  * The first phase includes the instantiation of a fresh engine instance, avoiding interference between experiments as caches are not reused.
  * Only transformation times have been considered in the quantitative analysis. 
  * For the results we use the median obtained for each of these two phases out of ten experiments, after removing the minimum and the maximum results. 
* An [adaptation of the test harness of the VIATRA CPS benchmark](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.cps2dep.yamtl#benchmark-sanity-checks) has been implemented for checking the correctness of the YAMTL solution.


## Model transformations used for the experiments

Below we provide pointers to the solutions of the transformation used in our adaptation of the **batch component** of the VIATRA CPS benchmark, giving pointers to where they are defined in the original benchmark, if available. These projects have been built as separate standalone executable jars, which we call *runners*. The runners used for the experiments together with the process used to build them is explained at the end of this section.

### Solutions used in our experiments

Our solution:
* [YAMTL](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.cps2dep.yamtl)
  * This project includes the implementation of the VIATRA CPS benchmark sanity tests to certify the correctness of a solution.

We have also partially implemented the transformation using:

* [ATL](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.data/atlFiles/Cps2Dep_atl.atl)
  * behaviours are not deep copied in the transformation, which would incur a performance penalty
  * no traceability
  * no trigger generation: `refImmediateComposite()` not defined in helper `belongsToApplicationType`
* [ATL/EMFTVM](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.data/atlFiles/Cps2Dep.atl): same transformation as above
  * behaviours are not deep copied in the transformation, which would incur a performance penalty
  * no traceability

Existing solutions that have been reused:

* [VIATRA EMF-IncQuery](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.cps2dep.viatra.eiq/src/org/eclipse/viatra/examples/cps/xform/m2m/batch/eiq/CPS2DeploymentBatchTransformationEiq.xtend)
  * corresponds [to this case](https://github.com/viatra/viatra-docs/blob/master/cps/Simple-Xtend-and-Query-M2M-transformation.adoc) in the VIATRA CPS benchmark    
* Xtend (plain): both extracted from the original benchmark
  * [Xtend (simple)](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.cps2dep.xtend.plugin/src/org/eclipse/viatra/examples/cps/xform/m2m/batch/simple/CPS2DeploymentBatchTransformationSimple.xtend)
    * corresponds [to this case](https://github.com/viatra/viatra-docs/blob/master/cps/Simple-and-optimized-Xtend-batch-M2M-transformation.adoc/#simple-and-optimized-xtend-batch-m2m-transformation) in the VIATRA CPS benchmark    
  * [Xtend (optimized](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.cps2dep.xtend.plugin/src/org/eclipse/viatra/examples/cps/xform/m2m/batch/optimized/CPS2DeploymentBatchTransformationOptimized.xtend)
    * corresponds [to this case](https://github.com/viatra/viatra-docs/blob/master/cps/Simple-and-optimized-Xtend-batch-M2M-transformation.adoc/#optimized-batch-m2m-transformation) in the VIATRA CPS benchmark


From [the list of batch solutions](https://github.com/viatra/viatra-docs/blob/master/cps/Alternative-transformation-methods.adoc#batch) considered in the VIATRA CPS benchmarks, the only one that has not been evaluated is [VIATRA Batch API](https://github.com/viatra/viatra-docs/blob/master/cps/VIATRA-transformation-API-based-batch-M2M-transformation.adoc). However, this should not affect the conclusions achieved in the experiment because this variant is not the fastest.

### Runners

[This script](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.data/runBatchBenchmarks.sh) executes the different runners of the benchmark. **Beware that its full execution may well take more than twenty-four hours**. Feel free to modify the script to execute parts of it.

The runners used in our experiments can be found [here](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.data/runners). There is a runner for each solution and scenario. Each of these runners produces a CSV file, as the ones available [here](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.data/experimental-results), containing the raw data of the different experiments for each model size.

Each of this runners has been built in the Eclipse IDE by exporting the corresponding project (containing a benchmark solution) as a  `Runnable JAR file`. The following options need to be selected:
* Select the corresponding main class from the project of choice. The main class chosen must extend the benchmark harness `FullBenchmarkRunner`, included in each project. For example, [this runner](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.cps2dep.yamtl/src/main/java/experiments/yamtl/Cps2DepRunner_ClientServer_YAMTL_full.xtend) for the YAMTL solution.
* Select the option `Package required libraries into generated JAR` for `library handling`.
* Provide the desired location for the JAR file. 




## Input models used

The different scenarios of the VIATRA CPS benchmark are discussed [here](https://github.com/viatra/viatra-cps-benchmark/wiki/Benchmark-specification#cases). We have used the VIATRA CPS model generator to generate models for each of the scenarios. These fixed input models have been used in all of our experiments:

* [client-server scenario](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.data/cps2dep/clientServer/cps)
* [publish-subscribe scenario](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.data/cps2dep/publishSubscribe/cps)
* [low synch scenario](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.data/cps2dep/lowSynch)
* [simple scaling](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.data/cps2dep/simpleScaling)
* [statistic based](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.data/cps2dep/statistics)


## Experiments

### Hardware used

MacBookPro11,5 Core i7 2.5 GHz, with four cores and 16 GB of RAM

### Software used

* ATL EMFTVM (4.0.0)
* ATL SDK - ATL Transformation Language SDK (4.0.0)
* CPS metamodels (0.1.0)
* Eclipse Oxygen.3 (4.7.3) 
* EMF - Eclipse Modeling Framework SDK (2.13.0)
* Java(TM) SE Runtime Environment (build 1.8.0\_72-b15)
* VIATRA Query and Transformation SDK (1.7.2)
* Xtend SDK Version (2.13.0)

### Raw results

* [Original results](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.data/experimental-results/XForm_CS_PS_Performance.xlsx): provided in [VIATRA CPS benchmark](https://github.com/viatra/viatra-cps-benchmark).
* [Results obtained](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.data/experimental-results) in our adapted variant of the VIATRA CPS benchmark. The results for the YAMTL and ATL solutions **may differ slightly** from the results included in the first draft of the paper as these solutions have been improved with the feedback received from the anonymous reviewers.