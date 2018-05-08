package cps2dep.yamtl

import java.util.ArrayList
import java.util.List
import java.util.Set
import moment2.registry.EmfMetamodelRegistry
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationInstance
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.Identifiable
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.State
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.StateMachine
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.Transition
import org.eclipse.viatra.examples.cps.deployment.BehaviorState
import org.eclipse.viatra.examples.cps.deployment.BehaviorTransition
import org.eclipse.viatra.examples.cps.deployment.Deployment
import org.eclipse.viatra.examples.cps.deployment.DeploymentApplication
import org.eclipse.viatra.examples.cps.deployment.DeploymentBehavior
import org.eclipse.viatra.examples.cps.deployment.DeploymentElement
import org.eclipse.viatra.examples.cps.deployment.DeploymentHost
import org.eclipse.viatra.examples.cps.deployment.DeploymentPackage
import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment
import org.eclipse.viatra.examples.cps.traceability.TraceabilityFactory
import org.eclipse.xtend.lib.annotations.Accessors
import yamtl.core.YAMTLModule
import yamtl.dsl.Helper
import yamtl.dsl.Rule

class Cps2DepYAMTL extends YAMTLModule {
	
	@Accessors
	CPSToDeployment mapping;
	
	val CPS = CyberPhysicalSystemPackage.eINSTANCE
	val DEP = DeploymentPackage.eINSTANCE
	
	new () {
		  
		header()
			.in('cps', CPS)
			.out('dep', DEP)

		
		ruleStore( newArrayList(
			
			new Rule('CyberPhysicalSystem_2_Deployment')
				.in('cps', CPS.cyberPhysicalSystem).build()
				.out('out', DEP.deployment, [ 
					val cps = 'cps'.fetch as CyberPhysicalSystem
					val out = 'out'.fetch as Deployment
					
					out.hosts += cps.hostTypes.map[instances].flatten
						.fetch as DeploymentHost[] 
				]).build()
				.build(),
			
			new Rule('HostInstance_2_DeploymentHost')
				.in('hostInstance', CPS.hostInstance).build()
				.out('out', DEP.deploymentHost, 
					[ 
						val hostInstance = 'hostInstance'.fetch as HostInstance
						val out = 'out'.fetch as DeploymentHost
						
						out.ip = hostInstance.nodeIp
						
						out.applications += hostInstance.applications
							.fetch as DeploymentApplication[] 
					]).build()
				.build(),
	
			new Rule('ApplicationInstance_2_DeploymentApplication')
				.in('appInstance', CPS.applicationInstance)
					.filter([
						val appInstance = 'appInstance'.fetch as ApplicationInstance
						appInstance.type?.cps == this.mapping.cps
					])
					.build()
				.out('out', DEP.deploymentApplication,
					[ 
						val appInstance = 'appInstance'.fetch as ApplicationInstance
						val out = 'out'.fetch as DeploymentApplication
						
						out.id = appInstance.identifier
						// Transform state machines
						out.behavior = appInstance.type.behavior.fetch as DeploymentBehavior 
					]
				).build()
				.build(),
	
			new Rule('StateMachine_2_DeploymentBehavior')
				.in('stateMachine', CPS.stateMachine).build()
				.out('out', DEP.deploymentBehavior,
					[ 
						val stateMachine = 'stateMachine'.fetch as StateMachine
						val out = 'out'.fetch as DeploymentBehavior
						
						out.description = stateMachine.identifier

						// Transform states
						val behaviorStates = stateMachine.states.fetch as BehaviorState[]
						out.states += behaviorStates 
						
						// Transform transitions
						var behaviorTransitions = new ArrayList<BehaviorTransition>
						for (state : stateMachine.states) {
							behaviorTransitions += 
								state.outgoingTransitions.fetch as BehaviorTransition[]
						}
						out.transitions += behaviorTransitions
				
						// set current state
						val initial = stateMachine.states.findFirst[stateMachine.initial == it]
						val initialBehaviorState = initial.fetch as BehaviorState
						out.current = initialBehaviorState
					]
				).build()
				.build(),
	
			new Rule('State_2_BehaviorState')
				.in('state', CPS.state).build()
				.out('out', DEP.behaviorState,
					[ 
						val state = 'state'.fetch as State
						val out = 'out'.fetch as BehaviorState
						
						out.description = state.identifier
						out.outgoing += state.outgoingTransitions.fetch as BehaviorTransition[] 
					]
				).build()
				.build(),
	
			new Rule('Transition_2_BehaviorTransition')
				.in('transition', CPS.transition)
					.filter( [
						val transition = 'transition'.fetch as Transition 
						transition.targetState !== null
					]).build()
				.out('out', DEP.behaviorTransition, 
					[ 
						val transition = 'transition'.fetch as Transition
						val out = 'out'.fetch as BehaviorTransition
						
						out.description = transition.identifier
		
						val targetBehaviorState = transition.targetState.fetch as BehaviorState
						out.to = targetBehaviorState
						
						// triggers
						if (transition.action?.isSignal) {
							// find all enabled transitions
							val waitingTransitions = 'waitingTransitions'.fetch as List<Transition>
							
							// fetch all potential target instances
							val List<Transition> triggeredTransitions = waitingTransitions.filter[ 
								val targetTransition = it as Transition
								(targetTransition.action?.isWaitSignal(transition.action.signalId)) 
								&& 
								(targetTransition.belongsToApplicationType(transition.action.appTypeId))
								&& 
								// transitive case  
								(transition.applicationInstance.allocatedTo.reaches(
									targetTransition.applicationInstance.allocatedTo,
									// add the client to the cache as already visited
									newHashSet
								))
							].map[it as Transition].toList
							
							val List<BehaviorTransition> triggeredBehaviorTransitions = 
								triggeredTransitions.map[fetch as BehaviorTransition]
							
							out.trigger += triggeredBehaviorTransitions
							
						}
					]
				).build()
				.build()
	
		))
		
		helperStore( newArrayList(
			new Helper('waitingTransitions') [
					CPS.transition.allInstances.filter[ 
						val targetTransition = it as Transition
						(targetTransition.action?.isWaitSignal) 
					].toList
				]
				.build()
		))

		if (debug) println("constructor")
	}
	
	
	/** 
	 * HELPERS
	 */
	def belongsToApplicationType(Transition t, String appTypeId) {
		// transition -> containing state -> state machine -> application type
		val appType = t.eContainer.eContainer.eContainer as ApplicationType
		appType.identifier == appTypeId
	}

	def applicationInstance(Transition t) {
		// transition -> containing state -> state machine -> application type
		val appType = t.eContainer.eContainer.eContainer as ApplicationType
		appType.instances?.head
	}
	
	// DFS using a cache to break loops
	def boolean reaches(HostInstance client, HostInstance server, Set<String> visited) {
		var boolean found = false
		if (!visited.contains(client.identifier)) {
			if (client.communicateWith.map[it.identifier].contains(server.identifier))
				found=true
			else {
				visited.add(client.identifier)
				found=client.communicateWith.exists[
					it.reaches(server, visited)	
				]
			}
		}
		found
	}

	def isSignal(String action) {
		action.startsWith('sendSignal')
	}
	def isWaitSignal(String action) {
		action.startsWith("waitForSignal")
	}
	def isWaitSignal(String action, String signalId) {
		val expectedAction = '''waitForSignal(«signalId»)'''
		action == expectedAction
	}
	def String getAppTypeId(String action) {
		val String[] contents = action.substring(action.indexOf('(')+1,action.lastIndexOf(')')).split(',') 
		contents.get(0).trim()
	}
	def String getSignalId(String action) {
		val String[] contents = action.substring(action.indexOf('(')+1,action.lastIndexOf(')')).split(',') 
		contents.get(1).trim()
	}


	/**
	 * EXTRACTION OF TRACEABILITY MODEL
	 */
	def saveTraceModel(String traceModelPath) {
		val Resource trcRes = this.registry.registry.createModel(traceModelPath)
		trcRes.contents += mapping
		trcRes.save(EmfMetamodelRegistry.SAVE_OPTIONS)
	}

	def getTraceModel() {
		mapping.fetchCPS2DepTraces
	}
	
	def void fetchCPS2DepTraces(CPSToDeployment cps2dep) {
		for (redux : this.eventPool) {
			if (!CyberPhysicalSystem.isInstance(redux.defaultInObject)) {
				val trace = TraceabilityFactory.eINSTANCE.createCPS2DeploymentTrace
				trace.cpsElements.add(redux.defaultInObject as Identifiable)
				
				redux.targetMatch.forEach[outName, pair |
					val targetObject = pair.value
					trace.deploymentElements.add(targetObject as DeploymentElement)
				]
				
				cps2dep.traces.add(trace)
			}
		}
	}
}