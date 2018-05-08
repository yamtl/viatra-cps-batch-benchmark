package experiments.utils

import org.eclipse.xtend.lib.annotations.Accessors

class PerformanceResult {
	@Accessors
	var long loadTime
	@Accessors
	var long initTime
	@Accessors
	var long trafoTime
	@Accessors
	var long saveTime
	
	new (long loadTime, long initTime, long trafoTime, long saveTime) {
		this.loadTime = loadTime
		this.initTime = initTime
		this.trafoTime = trafoTime
		this.saveTime = saveTime
	}
	def public getTotalTime() {
		initTime + trafoTime
	}
	
}