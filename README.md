# Batch component of the VIATRA CPS benchmark

Batch component of the [VIATRA CPS benchmark](https://github.com/viatra/viatra-cps-benchmark) used to analyze the performance of the [YAMTL model transformation engine](https://yamtl.github.io).

## Benchmark Specification

* [Specification of metamodels and transformations used in original benchmark](https://github.com/viatra/viatra-cps-benchmark/wiki/Benchmark-specification)

### Model transformations used for the experiments

* [ATL](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.data/atlFiles/Cps2Dep_atl.atl)
  * no traceability
  * no trigger generation: `refImmediateComposite()` not defined in helper `belongsToApplicationType`
* [ATL/EMFTVM](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.data/atlFiles/Cps2Dep.atl): same transformation as above
  * no traceability
* [VIATRA EMF-IncQuery](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.cps2dep.viatra.eiq/src/org/eclipse/viatra/examples/cps/xform/m2m/batch/eiq/CPS2DeploymentBatchTransformationEiq.xtend): extracted from the original benchmark
* [YAMTL](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.cps2dep.yamtl/src/main/java/cps2dep/yamtl/Cps2DepYAMTL.xtend)
* Xtend (plain): both extracted from the original benchmark
  * [Xtend (simple)](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.cps2dep.xtend.plugin/src/org/eclipse/viatra/examples/cps/xform/m2m/batch/simple/CPS2DeploymentBatchTransformationSimple.xtend)
  * [Xtend (optimized](https://github.com/yamtl/viatra-cps-batch-benchmark/blob/master/m2m.batch.cps2dep.xtend.plugin/src/org/eclipse/viatra/examples/cps/xform/m2m/batch/optimized/CPS2DeploymentBatchTransformationOptimized.xtend)

### Input models used

* [client-server scenario](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.data/cps2dep/clientServer/cps)
* [publish-subscribe scenario](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.data/cps2dep/publishSubscribe/cps)


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

* [original results](experimental-results/XForm_CS_PS_Performance.xlsx): provided in [VIATRA CPS benchmark](https://github.com/viatra/viatra-cps-benchmark)
* [results obtained](https://github.com/yamtl/viatra-cps-batch-benchmark/tree/master/m2m.batch.data/experimental-results)