-- contains a conveyer
-- knows the position of the inner display
Scanner = class{
	init = function(self)

		local bezel = Bezel()
		self.bezel = bezel

		local conveyor = Conveyor()
		conveyor.scanner = self
		self.conveyor = conveyor

		local base = Base()
		self.base = base

		self.timer = 0

		self.active = false

		local stopwatch = Stopwatch()
		stopwatch.scanner = self
		self.stopwatch = stopwatch

	end,

	update = function(self, dt)

		local conveyor = self.conveyor
		conveyor:update(dt)

		-- @todo
		-- this won't work, it needs to be position based
		-- inside of the conveyor
		if conveyor.moving then
			self.timer = self.timer - dt
		end
		if self.timer <= 0 then
			self.timer = 2.2
		end

	end,

	draw = function(self)
		local conveyor = self.conveyor
		conveyor:draw()
	end,

	-- @todo
	-- only call proceed when allowed
	proceed = function(self)

		local scene = self._scene
		local active = self.active
		local suitcases = scene.suitcases
		local suitcase = suitcases:pop()
		local conveyor = self.conveyor
		if suitcase and active then
			conveyor:process(suitcase)
		end

	end,

	scan = function(self, suitcase)
		self.scanning = suitcase
		local stopwatch = self.stopwatch
		stopwatch:show(suitcase)
	end,

	clear = function(self)
		self.scanning = nil
		local bezel = self.bezel
		bezel:clear()
		local score = bezel.score
		score.target = 0
	end,

	abort = function(self)
		local conveyor = self.conveyor
		conveyor:abort()
		self.active = false
	end,

	keypressed = function(self, key, code)

		local conveyor = self.conveyor
		local bezel = self.bezel
		local scanning = self.scanning
		local active = self.active

		-- @todo
		-- if not scanning, we should find out what would be answered anyway
		-- and do so

		if key == ' ' then
			conveyor.slowed = true
		end

		local button = bezel.button
		button:keypressed(key, code)

	end,

	keyreleased = function(self, key, code)
		if key == ' ' then
			local conveyor = self.conveyor
			conveyor.slowed = false
		end

		local bezel = self.bezel
		local button = bezel.button
		button:keyreleased(key, code)
	end,

	guess = function(self, suitcase, guess, success, failure)

		local bezel = self.bezel
		local active = self.active

		local valid = active and tonumber(guess)

		-- @todo
		-- handle numpad

		if valid then

			local correct = suitcase:bid(guess)

			if correct then
				suitcase.answer = 'correct!'
				suitcase.solved = true
				if success then
					success()
				end
			else
				suitcase.answer = 'wrong'
				suitcase.missed = true
				suitcase.solved = true
				signal.emit('wrong')
				if failure then
					failure()
				end
			end

			return true

		else
			print('not active')
		end


		return false

	end,

	start = function(self)
		self.active = true
		print('starting scanner')
	end
}