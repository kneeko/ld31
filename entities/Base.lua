Base = class{
	init = function(self)

		local w = lg.getWidth()
		local h = 140

		local x = 0
		local y = lg.getHeight()

		local position = {x, y, 1}

		local size = {w, h}
		local scale = {1, 1}
		local origin = {0, h}

		self.position = position
		self.size = size
		self.scale = scale
		self.origin = origin

		-- this should contain the axles
		-- not the bezel

		manager:register(self)

	end,

	update = function(self, dt)
	end,

	draw = function(self, mode, ...)

		local position = ...
		local size = self.size
		local scale = self.scale
		local origin = self.origin

		local x, y = unpack(position)
		local w, h = unpack(size)
		local sx, sy = unpack(scale)
		local ox, oy = unpack(origin)

		if mode == 'default' then

			lg.setColor(191, 178, 168)
			lg.rectangle('fill', x - ox, y - oy, w * sx, h * sy)

			lg.setColor(150, 150, 150)
			lg.line(x - ox, y - oy, x - ox + w * sx, y - oy)

		end

	end,
}