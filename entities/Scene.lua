Scene = class{
	init = function(self)

		local background = Background()

		local flights = FlightManager()
		local suitcases = SuitcaseManager()
		local scanner = Scanner()

		flights._scene = self
		suitcases._scene = self
		scanner._scene = self

		self.flights = flights
		self.suitcases = suitcases
		self.scanner = scanner

		flights:add()

		-- flights passes a series of suitcase params to the suitcase manager when a new flight arrives
		-- suitcases passes those suitcases to the scanner


	end,

	update = function(self, dt)

		local flights = self.flights
		flights:update(dt)

		local scanner = self.scanner
		scanner:update(dt)

	end,

	draw = function(self)
		local scanner = self.scanner
		--scanner:draw()
	end,

	keypressed = function(self, key, code)
		local scanner = self.scanner
		scanner:keypressed(key, code)
	end,

	keyreleased = function(self, key, code)
		local scanner = self.scanner
		scanner:keyreleased(key, code)
	end,
}