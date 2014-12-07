FlightManager = class{
	init = function(self)

	end,

	update = function(self, dt)

	end,

	draw = function(self)
	end,

	succeed = function(self)
	end,

	fail = function(self)
	end,

	add = function(self)

		print('added a flight')

		local flight = Flight()
		local scene = self._scene
		local manager = scene.suitcases
		manager.suitcases = flight.suitcases
		-- pass to manager


	end,
	
}