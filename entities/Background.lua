Background = class{
	init = function(self)

		local position = {0, 0, math.huge}
		local size = {lg.getWidth(), lg.getHeight()}
		local scale = {1, 1}

		self.position = position
		self.size = size
		self.scale = scale

		manager:register(self)
	end,

	update = function(self, dt)
	end,

	draw = function(self, mode, ...)
		local position = ...
		local size = self.size
		local scale = self.scale
		local x, y = unpack(position)
		local w, h = unpack(size)
		local sx, sy = unpack(scale)

		if mode == 'scanner' then

			lg.setColor(100, 100, 100)
			lg.rectangle('fill', x, y, w, h)

		end

	end,
}