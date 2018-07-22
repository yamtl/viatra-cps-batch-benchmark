package experiments.utils

import org.eclipse.xtend.lib.annotations.Accessors

class PerformanceResult {
	@Accessors
	var double loadTime
	@Accessors
	var double initTime
	@Accessors
	var double trafoTime
	@Accessors
	var double saveTime
	
	new (double loadTime, double initTime, double trafoTime, double saveTime) {
		this.loadTime = loadTime
		this.initTime = initTime
		this.trafoTime = trafoTime
		this.saveTime = saveTime
	}
	def public getTotalTime() {
		initTime + trafoTime
	}
	
}