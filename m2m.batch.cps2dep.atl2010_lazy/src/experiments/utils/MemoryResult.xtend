package experiments.utils

import org.eclipse.xtend.lib.annotations.Accessors

class MemoryResult {
	@Accessors
	var long saveMemory
	@Accessors
	var long initMemory
	@Accessors
	var long trafoMemory
	@Accessors
	var long loadMemory
	
	new (long loadMemory, long initMemory, long trafoMemory, long saveMemory) {
		this.loadMemory = loadMemory
		this.initMemory = initMemory
		this.trafoMemory = trafoMemory
		this.saveMemory = saveMemory
	}
	def public getTotalMemory() {
		initMemory + trafoMemory
	}
	
}