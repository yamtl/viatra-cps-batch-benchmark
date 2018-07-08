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
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.viatra.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment
import org.eclipse.viatra.examples.cps.xform.m2m.tests.CPS2DepTest
import org.junit.Test

import static org.junit.Assert.*

//@RunWith(Parameterized)
class HostMappingTest extends CPS2DepTest {
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
	def singleHost() {
		val testId = "singleHost"
		startTest(testId)
		
		var cps2dep = prepareEmptyModel(testId)
		val instance = cps2dep.prepareHostInstance
				
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertHostMapping(instance)
		
		endTest(testId)
	}
	
	def assertHostMapping(CPSToDeployment cps2dep, HostInstance instance) {
		val hosts = cps2dep.deployment.hosts
		assertFalse("Host not transformed", hosts.empty)
		val traces = cps2dep.traces
		assertFalse("Trace not created", traces.empty)
		val trace = traces.head
		assertEquals("Trace is not complete (cpsElements)", trace.cpsElements, #[instance])
		assertEquals("Trace is not complete (depElements)", trace.deploymentElements, hosts)
		assertEquals("IP not copied", instance.nodeIp, hosts.head.ip)
	}
	
	@Test
	def hostIncremental() {
		val testId = "hostIncremental"
		startTest(testId)
		
		var cps2dep = prepareEmptyModel(testId)
				
		cps2dep.initializeTransformation
		executeTransformation

		val instance = cps2dep.prepareHostInstance
		executeTransformation
		
		cps2dep.assertHostMapping(instance)
		
		endTest(testId)
	}
	
	@Test
	def removeHost() {
		val testId = "removeHost"
		startTest(testId)
		
		var cps2dep = prepareEmptyModel(testId)
		
		val host = cps2dep.prepareHostTypeWithId("single.cps.host")
		val ip = "1.1.1.1"
		val instance = host.prepareHostInstanceWithIP("single.cps.host.instance", ip)
		
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertHostMapping(instance)
		
		info("Removing host instance from model")
		host.instances -= instance
		executeTransformation

		assertTrue("Host not removed from deployment", cps2dep.deployment.hosts.empty)
		assertTrue("Trace not removed", cps2dep.traces.empty)
		
		endTest(testId)
	}
	
	@Test
	def changeHostIp() {
		val testId = "changeHostIp"
		startTest(testId)
		
		var cps2dep = prepareEmptyModel(testId)
		
		val host = cps2dep.prepareHostTypeWithId("single.cps.host")
		val ip = "1.1.1.1"
		val instance = host.prepareHostInstanceWithIP("single.cps.host.instance", ip)
				
		cps2dep.initializeTransformation
		executeTransformation

		info("Changing host IP")
		instance.nodeIp = "1.1.1.2"
		executeTransformation

		assertTrue("Host IP not changed in deployment", cps2dep.deployment.hosts.head.ip == instance.nodeIp)
		
		endTest(testId)
	}
}