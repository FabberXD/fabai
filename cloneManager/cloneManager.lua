local cloneManager = {}

cloneManager.createClones = function(manager, ai, count)
	local clones = {}

	for i = 1, count do
		table.insert(ai:createNetwork())
	end

	return clones
end

cloneManager.importClones = function(manager, ai, exports)
	local clones = {}

	for i = 1, #exports do
		table.insert(ai:importNetwork(exports[i]))
	end

	return clones
end

cloneManager.addLayer = function(manager, clones, neurons, biases)
	for i = 1, #clones do
		clones[i]:addLayer(neurons, biases)
	end
end

cloneManager.compile = function(manager, clones, func)
	for i = 1, #clones do
		clones[i]:compile(func)
	end
end

cloneManager.decompile = function(manager, clones)
	for i = 1, #clones do
		clones[i]:decompile(func)
	end
end

cloneManager.ask = function(manager, clones, input, activationFunction)
	local results = {}
	for i = 1, #clones do
		table.insert(results, clones[i]:ask(input, activationFunction))
	end
	return results
end

cloneManager.export = function(manager, clones)
	local exports = {}
	for i = 1, #clones do
		table.insert(exports, clones[i]:export())
	end
	return exports
end

return cloneManager
