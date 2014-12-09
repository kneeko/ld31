Stopwatch = class{
	init = function(self)

		local x = lg.getWidth() * 0.225
		local y = lg.getHeight() - 145
		local h = 5
		local w = lg.getWidth() * 0.55

		self._uncullable = true

		local position = {x, y, 1}
		local size = {w, h}
		local origin = {0, h}
		local scale = {1, 1}

		self.position = position
		self.size = size
		self.scale = scale
		self.origin = origin

		self.color = {130, 130, 130, 0}

		self.timer = 0
		self.duration = 5
		self.active = false

		manager:register(self)

	end,

	update = function(self, dt)

		local active = self.active
		local duration = self.duration
		local timer = self.timer
		if active then
			self.timer = math.min(timer + dt, duration)
			if self.timer == duration then
				local suitcase = self.suitcase
				if suitcase then
					local scanner = self.scanner
					scanner:guess(suitcase, 0)
					local conveyor = scanner.conveyor
					conveyor:resume()
					self:hide()
				end
				self:pause()
			end
		end

	end,

	draw = function(self, mode, ...)

		local position = ...
		local x, y = unpack(position)

		local size = self.size
		local w, h = unpack(size)

		local origin = self.origin
		local ox, oy = unpack(origin)

		if mode == 'scanner' then

			local color = self.color
			local timer = self.timer
			local duration = self.duration
			local interpolated = w * math.abs(1 - (timer / duration))
			lg.setLineWidth(1)
			lg.setColor(color)
			lg.rectangle('line', x - ox, y - oy, w, h)

			lg.rectangle('fill', x - ox, y - oy, interpolated, h)

		end

	end,

	show = function(self, suitcase)

		self.color = {130, 130, 130}
		self.active = true
		self.suitcase = suitcase

		local duration = suitcase.duration or self.duration
		local timer = suitcase.remainder or 0

		-- get the timer  and duration from the suitcase
		self:set(duration, timer)

	end,

	hide = function(self)


		local suitcase = self.suitcase
		if suitcase then
			suitcase.remainder = self.timer
		end

		self.color = {130, 130, 130, 0}
		self.active = false

		self.suitcase = nil
	end,

	set = function(self, duration, time)
		self.timer = time or self.timer
		self.duration = duration or self.duration
	end,

	start = function(self)
		self.timer = 0
		self:resume()
	end,

	pause = function(self)
		self.active = false
	end,

	resume = function(self)
		self.active = true
	end,
}