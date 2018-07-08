/*******************************************************************************
 * Copyright (c) 2014-2016, IncQuery Labs Ltd. 
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   Akos Horvath, Abel Hegedus, Tamas Borbas, Marton Bur, Zoltan Ujhelyi, Robert Doczi, Daniel Segesdi, Peter Lunk - initial API and implementation
 *******************************************************************************/

package org.eclipse.viatra.examples.cps.xform.m2m.tests.mappings

import experiments.yamtl.Cps2DepTestDriver_YAMTL
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationInstance
import org.eclipse.viatra.examples.cps.deployment.DeploymentHost
import org.eclipse.viatra.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment
import org.eclipse.viatra.examples.cps.xform.m2m.tests.CPS2DepTest
import org.junit.Test

import static org.junit.Assert.*

//@RunWith(Parameterized)
class ApplicationMappingTest extends CPS2DepTest {
	// Artur
	val extension Cps2DepTestDriver_YAMTL = new Cps2DepTestDriver_YAMTL
	val extension CPSModelBuilderUtil = new CPSModelBuilderUtil
	new() {
		super()
	}
//	new(CPSTransformationWrapper wrapper, String wrapperType) {
//		super(wrapper, wrapperType)
//	}
	
	@Test
	def singleApplication() {
		val testId = "singleApplication"
		startTest(testId)
		
		var cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val instance = cps2dep.prepareAppInstance(hostInstance)
		
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertApplicationMapping(instance)
		
		endTest(testId)
	}
	
	def assertApplicationMapping(CPSToDeployment cps2dep, ApplicationInstance instance) {
		val applications = cps2dep.deployment.hosts.head.applications
		assertFalse("Application not transformed", applications.empty)
		val traces = cps2dep.traces
		assertEquals("Trace not created", 2, traces.size)
//		val lastTrace = traces.last
//		assertEquals("Trace is not complete (cpsElements)", #[instance], lastTrace.cpsElements)
//		assertEquals("Trace is not complete (depElements)", applications, lastTrace.deploymentElements)
//		assertEquals("ID not copied", instance.identifier, applications.head.id)
		
		val trace = traces.findFirst[ trace |
			trace.cpsElements.contains(instance)
		]
		assertEquals("Trace is not complete (cpsElements)", #[instance], trace.cpsElements)
		assertEquals("Trace is not complete (depElements)", applications, trace.deploymentElements)
		assertEquals("ID not copied", instance.identifier, applications.head.id)
		
		
		
	}
	
	@Test
	def applicationIncremental() {
		val testId = "applicationIncremental"
		startTest(testId)
		
		var cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance

		cps2dep.initializeTransformation
		executeTransformation

		val instance = cps2dep.prepareAppInstance(hostInstance)
		executeTransformation
		
		cps2dep.assertApplicationMapping(instance)
		
		endTest(testId)
	}
	
	@Test
	def removeApplicationFromType() {
		val testId = "removeApplicationFromType"
		startTest(testId)
		
		var cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val instance = cps2dep.prepareAppInstance(hostInstance)
		
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertApplicationMapping(instance)
		
		info("Removing application instance from model")
		instance.type.instances -= instance
		executeTransformation

		val applications = cps2dep.deployment.hosts.head.applications
		assertTrue("Application not removed from deployment", applications.empty)
		assertEquals("Trace not removed", 1, cps2dep.traces.size)
		
		endTest(testId)
	}
	
	@Test
	def deallocateApplication() {
		val testId = "deallocateApplication"
		startTest(testId)
		
		var cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val instance = cps2dep.prepareAppInstance(hostInstance)
		
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertApplicationMapping(instance)
		
		info("Removing application instance from model")
		hostInstance.applications -= instance
		executeTransformation

		val applications = cps2dep.deployment.hosts.head.applications
		assertTrue("Application not removed from deployment", applications.empty)
		assertEquals("Trace not removed", 1, cps2dep.traces.size)
		
		endTest(testId)
	}
	
	@Test
	def reallocateApplication() {
		val testId = "reallocateApplication"
		startTest(testId)
		
		var cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val instance = cps2dep.prepareAppInstance(hostInstance)
				
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertApplicationMapping(instance)
		
		val host = cps2dep.prepareHostTypeWithId("single.cps.host2")
		val hostInstance2 = host.prepareHostInstanceWithIP("single.cps.host2.instance", "1.1.1.2")
		info("Reallocating application instance to host2")
		hostInstance2.applications += instance
		executeTransformation

		val traces = cps2dep.traces.filter[cpsElements.contains(hostInstance)]
		val deploymentHosts = traces.head.deploymentElements.filter(DeploymentHost)
		val applications = deploymentHosts.head.applications
		assertTrue("Application not moved from host in deployment", applications.empty)
		
		val traces2 = cps2dep.traces.filter[cpsElements.contains(hostInstance2)]
		val deploymentHosts2 = traces2.head.deploymentElements.filter(DeploymentHost)
		val applications2 = deploymentHosts2.head.applications
		assertFalse("Application not moved to host2 in deployment", applications2.empty)
		
		endTest(testId)
	}
	
	@Test
	def changeApplicationId() {
		val testId = "changeApplicationId"
		startTest(testId)
		
		var cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val instance = cps2dep.prepareAppInstance(hostInstance)
				
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertApplicationMapping(instance)
		
		info("Changing host IP")
		instance.identifier = "simple.cps.app.instance2"
		executeTransformation

		val applications = cps2dep.deployment.hosts.head.applications
		assertEquals("Application ID not changed in deployment", instance.identifier, applications.head.id)
		
		endTest(testId)
	}
	
	@Test
	def removeHostInstanceOfApplication() {
		val testId = "removeHostInstanceOfApplication"
		startTest(testId)
		
		var cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val instance = cps2dep.prepareAppInstance(hostInstance)
				
		cps2dep.initializeTransformation
		executeTransformation

		cps2dep.assertApplicationMapping(instance)
	
		info("Deleting host instance")
		cps2dep.cps.hostTypes.head.instances -= hostInstance
		hostInstance.applications.clear
		executeTransformation
		
		val traces = cps2dep.traces.filter[cpsElements.contains(instance)]
		assertTrue("Traces not removed", traces.empty)
		
		endTest(testId)
	}
}