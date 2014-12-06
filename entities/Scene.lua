Scene = class{
	init = function(self)

		local flights = FlightManager()
		self.flights = flights

	end,

	update = function(self, dt)
		local flights = self.flights
		flights:update(dt)
	end,

	draw = function(self)
	end,

	keypressed = function(self, key, code)
	end,
}