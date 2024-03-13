local fabai = {}
fabai.version = 1

fabai.neuron = function(type)
	local neuron = {}

	neuron.type = type
	neuron.value = 0
	neuron.updateValue = 0

	return neuron
end

fabai.createNetwork = function(ai)
	local net = {}

	net.compiled = false
	net.layers = {}
	net.wlayers = {}

	net.addLayer = function(self, neurons, biases)
		if self.compiled == true then
			error("neuralNet:addLayer(neurons, biases*) - network can't be compiled when adding layers", 2)
		end
		if neurons == nil then
			error("neuralNet:addLayer(neurons, biases*) - neurons must be a number", 2)
		end
		if biases == nil then
			biases = 0
		end
		if #self.layers == 0 and biases ~= 0 then
			error("neuralNet:addLayer(neurons, biases*) - input (first) layer can't have biases", 2)
		end

		local layer = {}
		for i = 1, neurons do
			table.insert(layer, ai.neuron(0))
		end
		for i = 1, biases do
			table.insert(layer, ai.neuron(1))
		end
		table.insert(self.layers, layer)
	end

	net.compile = function(self, func)
		if func == nil then
			func = function(l1, l2)
				return math.random(0, 100) / 100
			end
		end

		if self.compiled == true then
			error("neuralNet:compile(func*) - network can't be compiled twice", 2)
		end
		if #self.layers < 2 then
			error("neuralNet:compile(func*) - network must have at least 2 layers", 2)
		end

		for layerI = 1, #self.layers - 1 do
			local wlayer = {}

			for n1 = 1, #self.layers[layerI] do
				local wwlayer = {}
				for n2 = 1, #self.layers[layerI + 1] do
					table.insert(wwlayer, func(#self.layers[layerI], #self.layers[layerI + 1]))
				end
				table.insert(wlayer, wwlayer)
			end

			table.insert(self.wlayers, wlayer)
		end

		self.compiled = true
	end

	net.decompile = function(self)
		self.compiled = false
		self.wlayers = {}
	end

	net.ask = function(self, input, activationFunction)
		if activationFunction == nil then
			activationFunction = function(x)
				return 1 / (1 + math.exp(-x))
			end
		end
		if self.compiled == false then
			error("neuralNet:ask(input, activationFunction*) - network must be compiled", 2)
		end
		if #input ~= #self.layers[#self.layers] then
			error("neuralNet:ask(input, activationFunction*) - input size must equal to input (first) layer size", 2)
		end

		for i = 1, #input do
			self.layers[1][i].value = input[i]
		end

		local updateValue = 0
		for i = 1, 10 do
			updateValue = math.random(0, 9999)
			if updateValue ~= self.layers[2][1].updateValue then
				break
			end
			if i == 10 then
				error(
					"neuralNet:ask(input, activationFunction*) - failed to generate new unique updateValue, try again or change random seed",
					2
				)
			end
		end

		for layerI = 1, #self.layers - 1 do
			for n1 = 1, #self.layers[layerI] do
				for n2 = 1, #self.layers[layerI + 1] do
					if self.layers[layerI + 1][n2].type ~= 1 then
						local weight = self.wlayers[layerI][n1][n2]
						if self.layers[layerI + 1][n2].updateValue ~= updateValue then
							self.layers[layerI + 1][n2].value =
								activationFunction(((self.layers[layerI][n1].value * weight) / #self.layers[layerI]))
							self.layers[layerI + 1][n2].updateValue = updateValue
						else
							self.layers[layerI + 1][n2].value = activationFunction(
								self.layers[layerI + 1][n2].value
									+ ((self.layers[layerI][n1].value * weight) / #self.layers[layerI])
							)
						end
					end
				end
			end
		end

		local result = {}
		for i = 1, #self.layers[#self.layers] do
			result[i] = self.layers[#self.layers][i].value
		end
		return result
	end

	net.export = function(self)
		local export = {}

		export.version = ai.version
		export.compiled = self.compiled

		export.layers = {}
		for layerI = 1, #self.layers do
			local neurons = 0
			local biases = 0
			for n = 1, #self.layers[layerI] do
				if self.layers[layerI][n].type == 0 then
					neurons = neurons + 1
				else
					biases = biases + 1
				end
			end
			table.insert(export.layers, { neurons, biases })
		end

		if self.compiled == true then
			export.wlayers = {}
			for layerI = 1, #self.wlayers do
				local wlayer = {}
				for n1 = 1, #self.wlayers[layerI] do
					local wwlayer = {}
					for n2 = 1, #self.wlayers[layerI][n1] do
						local value = self.wlayers[layerI][n1][n2]
						table.insert(wwlayer, value)
					end
					table.insert(wlayer, wwlayer)
				end
				table.insert(export.wlayers, wlayer)
			end
		end

		return export
	end

	return net
end

fabai.importNetwork = function(ai, export)
	local network = ai:createNetwork()

	for layerI = 1, #export.layers do
		network:addLayer(export.layers[layerI][1], export.layers[layerI][2])
	end

	if export.compiled == true then
		for layerI = 1, #export.wlayers do
			local wlayer = {}
			for n1 = 1, #export.wlayers[layerI] do
				local wwlayer = {}
				for n2 = 1, #export.wlayers[layerI][n1] do
					local value = export.wlayers[layerI][n1][n2]
					table.insert(wwlayer, value)
				end
				table.insert(wlayer, wwlayer)
			end
			table.insert(network.wlayers, wlayer)
		end
		network.compiled = true
	end

	return network
end

return fabai
