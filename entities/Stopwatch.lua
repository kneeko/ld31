Stopwatch = class{
	init = function(self)

		local padding = 90
		local w = lg.getWidth() * 0.7 - padding
		local h = 25
		local x = padding

		local position = {x, -15, 1}
		local size = {w, h}
		local origin = {0, h}
		local scale = {1, 1}

		self.position = position
		self.size = size
		self.scale = scale
		self.origin = origin

		self.timer = 0
		self.duration = 2
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

		if mode == 'interface' then
			lg.setLineWidth(1)
			lg.setColor(255, 255, 255)
			lg.rectangle('line', x - ox, y - oy, w, h)

			local s = self.timer
			fonts:draw('Helvetica.ttf', 18, s, x - ox + 10, y - oy)

		end

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