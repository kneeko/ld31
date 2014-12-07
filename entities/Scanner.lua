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
		local suitcases = scene.suitcases
		local suitcase = suitcases:pop()
		local conveyor = self.conveyor
		if suitcase then
			print('got a suitcase!')
			conveyor:process(suitcase)
		end

	end,

	scan = function(self, suitcase)
		self.scanning = suitcase
	end,

	clear = function(self)
		self.scanning = nil
	end,

	keypressed = function(self, key, code)

		local conveyor = self.conveyor
		local bezel = self.bezel
		local alarm = bezel.alarm
		local scanning = self.scanning

		-- @todo
		-- if not scanning, we should find out what would be answered anyway
		-- and do so

		if scanning then

			-- @todo find a good place to put this
			-- answer checking code and response

			-- since the ui will have some part in this
			-- maybe it makes sense to pass the suitcase to ui?

			if tonumber(key) then
				local correct = scanning:bid(key)
				if correct then
					conveyor:resume()
					scanning.answer = 'correct!'
					alarm:set('success')
				else
					conveyor:resume()
					scanning.answer = 'wrong'
					alarm:set('failure')
				end
				scanning.solved = true
			end
			

		else

			-- without pausing, try to answer anyway?
			local nearest, selected = conveyor:nearest()
			if selected then
				if tonumber(key) then
					local correct = selected:bid(key)
					if correct then
						selected.answer = 'correct!'
						alarm:set('success')
					else
						selected.answer = 'wrong'
						alarm:set('failure')
					end
					selected.solved = true
				end
			end

		end

		if key == ' ' then
			conveyor:toggle()
		end

	end,

	keyreleased = function(self, key, code)
	end,
}