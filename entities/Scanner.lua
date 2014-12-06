-- contains a conveyer
-- knows the position of the inner display
Scanner = class{
	init = function(self)

		local conveyor = Conveyor()
		conveyor.scanner = self
		self.conveyor = conveyor

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
		if suitcase then
			print('got a suitcase!')
			local conveyor = self.conveyor
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
		local scanning = self.scanning
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
				else
					conveyor:resume()
				end
			end
			

		elseif key == 'n' then
			self:proceed()
		end

		if key == ' ' then
			conveyor:toggle()
		end

	end,

	keyreleased = function(self, key, code)
	end,
}