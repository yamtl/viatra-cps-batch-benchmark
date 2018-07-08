package experiments.yamtl

import cps2dep.yamtl.Cps2DepYAMTL
import org.apache.log4j.Logger
import org.eclipse.viatra.examples.cps.deployment.Deployment
import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment
import org.eclipse.xtend.lib.annotations.Accessors

class Cps2DepTestDriver_YAMTL {
	protected extension Logger logger = Logger.getLogger("Cps2DepTestDriver_YAMTL")
	
	@Accessors
	var Cps2DepYAMTL xform 
	
	def initializeTransformation(CPSToDeployment cps2dep) {
		if ((cps2dep.cps === null) || (cps2dep.deployment === null)) 
			throw new IllegalArgumentException()
		
		xform = new Cps2DepYAMTL
		xform.fromRoots = false
		xform.mapping = cps2dep
		val cpsRes = xform.mapping.cps.eResource
		xform.loadInputResources(#{'cps' -> cpsRes})
	}
	
	def CPSToDeployment executeTransformation() {
		// reset
		xform.mapping.traces.clear
		xform.transitionToBTransitionList.clear
		xform.stateToBStateList.clear
		xform.smToBehList.clear
		xform.reachableWaitForTransitionsMap.clear
		xform.depAppToAppInstance.clear
		xform.reset()
		
		
		xform.execute()
		
		xform.getTraceModel()
		
		val depRes = xform.getOutputModel('dep')
		xform.mapping.deployment = depRes.contents.findFirst[Deployment.isInstance(it)] as Deployment
		
		xform.mapping
	}
	
	def startTest(String testId){
    	info('''START TEST: type: YAMTL ID: «testId»''')
    }
    
    def endTest(String testId){
    	info('''END TEST: type: YAMTL ID: «testId»''')
    }
	

}