FlightManager = class{
	init = function(self)

		signal.register('completed', function() self:proceed() end)

		self:clear()

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

		print('added a flight: ' .. tostring(self.active))

	end,

	proceed = function(self)
		local active = self.active
		print('completed, active: ' .. tostring(active))
		if active then
			self:add()
		else
			scene:finish()
		end
	end,

	clear = function(self)

		local flights = {}
		self.flights = flights
		self.active = false

	end,
	
}