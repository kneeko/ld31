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

		manager:register(self)

	end,

	update = function(self, dt)
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
		end

	end,

	start = function(self)
	end,

	pause = function(self)
	end,

	resume = function(self)
	end,
}