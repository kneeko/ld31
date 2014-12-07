FlightManager = class{
	init = function(self)

		local flights = {}
		self.flights = flights

	end,

	update = function(self, dt)

		local flights = self.flights
		for i = 1, #flights do
			flights[i]:update(dt)
		end

	end,

	draw = function(self)
	end,

	succeed = function(self)
	end,

	fail = function(self)
	end,

	add = function(self)

		local flights = self.flights
		local flight = Flight()
		flight.parent = self
		table.insert(flights, flight)

	end,
	
}