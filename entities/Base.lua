Base = class{
	init = function(self)

		local w = lg.getWidth()
		local h = 160

		local x = 0
		local y = lg.getHeight()

		local position = {x, y, 1}

		local size = {w, h}
		local scale = {2, 1}
		local origin = {w*0.5, h}

		self.position = position
		self.size = size
		self.scale = scale
		self.origin = origin

		local belt = Belt(x, x + w)
		self.belt = belt

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

			-- @todo do this in the belt
			lg.setColor(150, 150, 150)
			lg.setLineWidth(8)
			lg.line(x - ox, y - oy, x - ox + w * sx, y - oy)

		end

		-- scanner mode...

	end,
}