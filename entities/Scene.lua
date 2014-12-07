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

		-- so..., maybe a callback when the suitcases run out?

		-- flights passes a series of suitcase params to the suitcase manager when a new flight arrives
		-- suitcases passes those suitcases to the scanner

		--self:proceed()

		self.counter = 0
		signal.register('correct', function(n)
			self.counter = self.counter + n
		end)

		self.misses = 0
		signal.register('wrong', function()
			self.misses = self.misses + 1
		end)

		signal.register('finish', function() self:finish() end)


		local prompt = Prompt('count the animals\npress space to start the conveyor')
		prompt.callback = function() self:start() end
		self.prompt = prompt


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

		lg.print(self.misses, 15, 15)

	end,

	keypressed = function(self, key, code)
		local scanner = self.scanner
		scanner:keypressed(key, code)

		--[[
		if key == 'return' then
			local flights = self.flights
			flights.active = true
			flights:add()
			self.prompt:_destroy()
			self.prompt = nil
		end
		]]--

		if key == 'a' then
			
			self:clear()

		end

		if key == ' ' then
			local prompt = self.prompt
			if prompt then
				prompt.callback()
			end
		end

	end,

	keyreleased = function(self, key, code)
		local scanner = self.scanner
		scanner:keyreleased(key, code)
	end,

	proceed = function(self)
		local flights = self.flights
		flights:add()
	end,

	start = function(self)

		-- @todo properly init

		local suitcases = self.suitcases
		suitcases:flush()

		local flights = self.flights
		flights:clear()
		flights.active = true
		flights:add()

		local scanner = self.scanner
		scanner:clear()

		local prompt = self.prompt
		prompt:_destroy()
		self.prompt = nil

	end,

	clear = function(self)

		local flights = self.flights
		flights.active = false

		local scanner = self.scanner
		local suitcases = self.suitcases

		scanner:abort()
		
		suitcases:flush()

	end,

	finish = function(self)

		print('game over')

		local prompt = Prompt('game over')
		prompt.callback = function() self:start() end
		self.prompt = prompt

	end,
}