Score = class{
	init = function(self)


		local graphic = lg.newImage('assets/images/lcd.png')
		local w = graphic:getWidth()
		local h = graphic:getHeight()
		local scaling = 0.5

		local position = {217, 565, 1}
		local size = {w, h}
		local scale = {scaling, scaling}

		local font = fonts:add('Digital.ttf', 52)

		self.graphic = graphic
		self.position = position
		self.size = size
		self.scale = scale


		self.font = font

		self.target = 0
		self.interpolated = 0

		signal.register('score', function(n) self:add(n) end)

		manager:register(self)

	end,

	update = function(self, dt)

		local target = self.target
		local interpolated = self.interpolated

		self.interpolated = interpolated + (target - interpolated) * dt * 7
		if math.abs(interpolated - target) < 0.2 then
			self.interpolated = target
		end
		self.string = math.ceil(self.interpolated)


	end,

	draw = function(self, mode, ...)


		if mode == 'interface' then
			local position = ...
			local x, y = unpack(position)

			local font = self.font

			local string = self.string


			local graphic = self.graphic
			local scale = self.scale
			local sx, sy = unpack(scale)

			lg.setColor(255, 255, 255)
			lg.draw(graphic, x, y, angle, sx, sy)

			-- how do i manage this text correctly?

			font:set()
			lg.setColor(200, 255, 200)
			lg.print(string, x + 12, y + 12)

		end

	end,

	add = function(self, n)

		local target = self.target
		self.target = n and target + n or 0
		points = self.target

	end,
}