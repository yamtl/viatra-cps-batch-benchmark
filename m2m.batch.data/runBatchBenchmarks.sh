#!/usr/bin/env bash
echo "####################################################################"
echo "BENCHMARKS FOR MODELS'18"
echo "####################################################################"
echo "RUNNING FROM SCRIPT: atl2010_clientServer"
java -Xmx12288m -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -jar ./runners/atl2010_batch_clientServer.jar
echo "####################################################################"
echo "RUNNING FROM SCRIPT: atl2010_publishSubscribe"
java -Xmx12288m -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -jar ./runners/atl2010_batch_publishSubscribe.jar
echo "####################################################################"
echo "RUNNING FROM SCRIPT: emftvm_clientServer"
java -Xmx12288m -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -jar ./runners/emftvm_batch_clientServer.jar
echo "####################################################################"
echo "RUNNING FROM SCRIPT: emftvm_publishSubscribe"
java -Xmx12288m -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -jar ./runners/emftvm_batch_publishSubscribe.jar
echo "####################################################################"
echo "RUNNING FROM SCRIPT: ViatraEiq_clientServer"
java -Xmx12288m -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -jar ./runners/viatraEiq_batch_clientServer.jar  
echo "####################################################################"
echo "RUNNING FROM SCRIPT: ViatraEiq_publishSubscribe"
java -Xmx12288m -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -jar ./runners/viatraEiq_batch/publishSubscriber.jar  
echo "####################################################################"
echo "RUNNING FROM SCRIPT: Xtend_clientServer"
java -Xmx12288m -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -jar ./runners/Xtend_batch_clientServer.jar  
echo "####################################################################"
echo "RUNNING FROM SCRIPT: Xtend_publishSubscribe"
java -Xmx12288m -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -jar ./runners/Xtend_batch_publishSubscribe.jar  
echo "####################################################################"
echo "RUNNING FROM SCRIPT: XtendOptimized_clientServer"
java -Xmx12288m -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -jar ./runners/XtendOptimized_batch_clientServer.jar  
echo "####################################################################"
echo "RUNNING FROM SCRIPT: XtendOptimized_publishSubscribe"
java -Xmx12288m -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -jar ./runners/XtendOptimized_batch_publishSubscribe.jar  
echo "####################################################################"
echo "RUNNING FROM SCRIPT: yamtl_clientServer"
java -Xmx12288m -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -jar ./runners/yamtl_batch_clientServer.jar   
echo "####################################################################"
echo "RUNNING FROM SCRIPT: yamtl_publishSubscribe"
java -Xmx12288m -XX:+UseConcMarkSweepGC -Djava.awt.headless=true -jar ./runners/yamtl_batch_publishSubscribe.jar  
