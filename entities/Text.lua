Text = class{
	init = function(self, string, size)

		local x = lg.getWidth() * 0.5
		local y = lg.getHeight() * 0.5

		local font = fonts:add('Helvetica.ttf', size)
		local w, h = font:getWidth(string), font:getHeight(string)
		local size = {w, h}

		self.string = tostring(string)
		self.font = font
		self.size = size

	end,

	update = function(self, dt)


	end,

	draw = function(self, x, y, scale)


		local size = self.size
		local w, h = unpack(size)

		local scale = scale or {1, 1}

		local origin = self.origin
		local ox, oy = w*0.5, h*0.5

		local sx, sy = unpack(scale)
		sx = sx * 0.68
		sy = sy * 0.68

		local font = self.font
		local string = tostring(self.string)

		font:set()

		lg.print(string, x - ox * sx, y - oy * sx, 0, sx, sy)


	end,
}