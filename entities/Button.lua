Button = class{
	init = function(self)


		local down = lg.newImage('assets/images/button-down.png')
		local up = lg.newImage('assets/images/button-up.png')
		local w = down:getWidth()
		local h = down:getHeight()
		local scaling = 0.5

		local position = {36, 565, 1}
		local size = {w, h}
		local scale = {scaling, scaling}

		local graphics = {
			up = up,
			down = down,
		}

		self.graphics = graphics
		self.position = position
		self.size = size
		self.scale = scale

		self.status = 'up'

		self.callbacks = {'keypressed', 'keyreleased'}

		manager:register(self)

	end,

	update = function(self, dt)

	end,

	draw = function(self, mode, ...)


		if mode == 'interface' then
			local position = ...
			local x, y = unpack(position)

			local status = self.status
			local graphic = self.graphics[status]
			local scale = self.scale
			local sx, sy = unpack(scale)

			lg.setColor(255, 255, 255)
			lg.draw(graphic, x, y, angle, sx, sy)


		end

	end,

	keypressed = function(self, key, code)
		if key == ' ' then
			self.status = 'down'
			push:setPitch(0.5)
			push:play()
		end
	end,

	keyreleased = function(self, key, code)
		if key == ' ' then
			self.status = 'up'
			push:setPitch(0.7)
			push:play()
		end
	end,
}