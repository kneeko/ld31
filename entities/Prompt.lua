Prompt = class{
	init = function(self, string)

		-- incoming flight from JFK [flag]?

		local x = lg.getWidth() * 0.5
		local y = lg.getHeight() * 0.5

		local font = fonts:add('Helvetica.ttf', 42)
		local w, h = font:getWidth(string), font:getHeight(string)
		local sx, sy = 0.7, 0.7

		local position = {x, y, 1}
		local origin = {w*0.5, h*0.5}
		local size = {w, h}
		local scale = {sx, sy}

		self.position = position
		self.origin = origin
		self.size = size
		self.scale = scale

		self.string = string
		self.font = font

		manager:register(self)

	end,

	update = function(self, dt)


	end,

	draw = function(self, mode, ...)

		-- draw the text
		local position = ...
		local x, y = unpack(position)

		if mode == 'scanner' then

			local size = self.size
			local w, h = unpack(size)

			local origin = self.origin
			local ox, oy = unpack(origin)

			local scale = self.scale
			local sx, sy = unpack(scale)

			local font = self.font
			local string = self.string

			lg.setColor(255, 255, 255)
			font:draw(string, x - ox * sx, y - oy * sx, 0, sx, sy)


		end

	end,
}