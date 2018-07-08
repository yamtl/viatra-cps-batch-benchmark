package org.eclipse.viatra.examples.cps.generator.utils

import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemFactory
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.HostType
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.State
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.StateMachine
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.Transition
import org.eclipse.viatra.examples.cps.deployment.BehaviorTransition
import org.eclipse.viatra.examples.cps.deployment.DeploymentFactory
import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment
import org.eclipse.viatra.examples.cps.traceability.TraceabilityFactory
import static org.junit.Assert.*

///////////////////////////////////////////////////////////////////////////////////////////
// HELPERS from org.eclipse.viatra.examples.cps.generator.utils.CPSModelBuilderUtil
///////////////////////////////////////////////////////////////////////////////////////////
class CPSModelBuilderUtil {
	protected extension CyberPhysicalSystemFactory cpsFactory = CyberPhysicalSystemFactory.eINSTANCE
	protected extension DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
	protected extension TraceabilityFactory traceFactory = TraceabilityFactory.eINSTANCE
	
	def prepareEmptyModel(String cpsId) {
		val rs = new ResourceSetImpl()
		val cpsRes = rs.createResource(URI.createURI("dummyCPSUri"))
		val depRes = rs.createResource(URI.createURI("dummyDeploymentUri"))
		val trcRes = rs.createResource(URI.createURI("dummyTraceabilityUri"))
		
		val cps = createCyberPhysicalSystem => [
			identifier = cpsId
		]
		cpsRes.contents += cps
		
		val dep = createDeployment
		depRes.contents += dep
		 
		val cps2dep = createCPSToDeployment => [
			it.cps = cps
			it.deployment = dep
		]
		trcRes.contents += cps2dep
		cps2dep
	}
	
	def assertActionMapping(CPSToDeployment cps2dep, Transition sendTransition, Transition waitTransition) {
		
		val sendTrace = cps2dep.traces.findFirst[cpsElements.contains(sendTransition)]
		assertFalse("Send transition not transformed", sendTrace.deploymentElements.empty)
		
		val waitTrace = cps2dep.traces.findFirst[cpsElements.contains(waitTransition)]
		assertFalse("Wait transition not transformed", waitTrace.deploymentElements.empty)
		
		val depSend = sendTrace.deploymentElements.head as BehaviorTransition
		val depWait = waitTrace.deploymentElements.head as BehaviorTransition
		assertEquals("Trigger incorrect", #[depWait], depSend.trigger)
	}
	
	
	
	def prepareHostTypeWithId(CPSToDeployment cps2dep, String hostId) {
		prepareHostTypeWithId(cps2dep.cps, hostId);
	}
	
	def prepareHostTypeWithId(CyberPhysicalSystem cps, String hostId) {
		println('''Adding host type (ID: «hostId») to model''')
		val host = createHostType => [
			identifier = hostId
		]
		cps.hostTypes += host
		host
	}
	
	def prepareHostInstanceWithIP(HostType host, String instanceId, String ip) {
		println('''Adding host instance (IP: «ip») to host type «host.identifier»''')
		val instance = createHostInstance => [
			identifier = instanceId
			nodeIp = ip
		]
		host.instances += instance
		instance
	}
	
	def prepareHostInstance(CPSToDeployment cps2dep) {
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val ip = "1.1.1.1"
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", ip)
		hostInstance
	}
	
	def prepareApplicationTypeWithId(CPSToDeployment cps2dep, String appId) {
		prepareApplicationTypeWithId(cps2dep.cps, appId);
	}
	
	def prepareApplicationTypeWithId(CyberPhysicalSystem cps, String appId) {
		println('''Adding application type (ID: «appId») to model''')
		val appType = createApplicationType => [
			identifier = appId
		]
		cps.appTypes += appType
		appType
	}
	
	def prepareApplicationInstanceWithId(ApplicationType app, String appId, HostInstance host) {
		println('''Adding application instance (ID: «appId») to «app.identifier»''')
		val instance = createApplicationInstance => [
			identifier = appId
			allocatedTo = host
		]
		app.instances += instance
		instance
	}
	
	def prepareApplicationInstanceWithId(ApplicationType app, String appId) {
		println('''Adding application instance (ID: «appId») to «app.identifier»''')
		val instance = createApplicationInstance => [
			identifier = appId
		]
		app.instances += instance
		instance
	}

	def prepareAppInstance(CPSToDeployment cps2dep, HostInstance hostInstance) {
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val instance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		instance
	}
	
	def prepareStateMachine(ApplicationType app, String smId) {
		println('''Adding state machine (ID: «smId») to «app.identifier»''')
		val instance = createStateMachine => [
			identifier = smId
		]
		app.behavior = instance
		instance
	}
	
	def prepareState(StateMachine sm, String stateId) {
		println('''Adding state (ID: «stateId») to «sm.identifier»''')
		val state = createState => [
			identifier = stateId
		]
		sm.states += state
		state
	}
	
	def prepareTransition(State source, String trID, State target) {
		println('''Adding transition (ID: «trID») between «source.identifier» and «target.identifier»''')
		val transition = source.prepareTransition(trID)
		transition.targetState = target
		transition
	}
	
	def prepareTransition(State source, String trID) {
		val transition = createTransition => [
			identifier = trID
		]
		source.outgoingTransitions += transition
		transition
	}
	
	def prepareCommunication(HostInstance srcHost, HostInstance trgHost) {
		println('''Create connection from «srcHost.identifier» to «trgHost.identifier»''')
		srcHost.communicateWith.add(trgHost);
	}
	
//	def static calculateHostInstancesToHostClassMap(CPSFragment fragment){
//		val hostClassToInstanceMap = HashMultimap.<HostClass, HostInstance>create;
//		fragment.hostTypes.keySet.forEach[hc |
//			val instances = fragment.hostTypes.get(hc).map[ht | 
//				ht.instances
//			].flatten
//			
//			hostClassToInstanceMap.putAll(hc, instances)
//		]
//		return hostClassToInstanceMap;
//	}
}