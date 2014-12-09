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

		cities = require('cities')

		-- so..., maybe a callback when the suitcases run out?

		-- flights passes a series of suitcase params to the suitcase manager when a new flight arrives
		-- suitcases passes those suitcases to the scanner

		--self:proceed()

		self.misses = 0
		signal.register('wrong', function()
			self.misses = self.misses + 1
		end)

		signal.register('finish', function() self:finish() end)

		local header = 'Try Saving Animals'
		local help = 'press space to begin'
		local prompt = Prompt(header, help)
		prompt.callback = function() self:start() end
		self.prompt = prompt

		-- play audio track
		local soundtrack = la.newSource('assets/audio/MuteGroove.mp3', 'stream')
		soundtrack:setLooping(true)
		soundtrack:play()

		local wooshes = {
			'assets/audio/woosh_1.mp3',
			'assets/audio/woosh_2.mp3',
			'assets/audio/woosh_3.mp3',
		}

		woosh = la.newSource(wooshes, 'static')

		ding = la.newSource('assets/audio/ding.mp3', 'static')
		boo = la.newSource('assets/audio/boo.wav', 'static')
		push = la.newSource('assets/audio/type.wav', 'static')

	end,

	update = function(self, dt)

		local flights = self.flights
		flights:update(dt)

		local scanner = self.scanner
		scanner:update(dt)

	end,

	draw = function(self)

	end,

	keypressed = function(self, key, code)
		local scanner = self.scanner
		scanner:keypressed(key, code)

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

		local suitcases = self.suitcases
		suitcases:flush()

		local flights = self.flights
		flights:clear()
		flights.active = true
		flights:add()

		local scanner = self.scanner
		scanner:clear()

		-- reste score

		local prompt = self.prompt
		prompt.exiting = true
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

		local header = 'game over'
		local help = 'press space to try again'
		local score = tostring(points)
		local prompt = Prompt(header, help, points)

		prompt.callback = function() self:start() end
		self.prompt = prompt

	end,
}