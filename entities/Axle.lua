-- spins according to the conveyor dx


Axle = class{
	init = function(self)

		local font = fonts:add('Inconsolata.otf', 32)
		local string = '--'
		local w, h = font:getWidth(string), font:getHeight(string)

		local position = {100, lg.getHeight() - 60, 1}
		local size = {w, h}
		local scale = {1, 1}
		local origin = {w*0.5, h*0.5}
		local radius = 24

		self.position = position
		self.size = size
		self.scale = scale
		self.origin = origin

		self.angle = math.pi * 2 * math.random()
		self.radius = radius
		

		self.font = font
		self.string = string

		self.torque = 0.02


		manager:register(self)

	end,

	update = function(self, dt)
	end,

	draw = function(self, mode, ...)

		local position = ...
		local origin = self.origin
		local x, y = unpack(position)
		local ox, oy = unpack(origin)

		local angle = self.angle
		local font = self.font
		local string = self.string
		local radius = self.radius

		if mode == 'interface' then
			
			lg.setColor(205, 191, 180)
			lg.circle('fill', x - ox, y - oy, radius, 32)

			lg.setColor(150, 150, 150)
			lg.circle('line', x - ox, y - oy, radius, 32)

			lg.setColor(100, 100, 100, 160)
			font:draw(string, x - ox, y - oy, angle, 1, 1, ox, oy)
		end

	end,

	rotate = function(self, rotation)
		local angle = self.angle
		local torque = self.torque
		if rotation then
			self.angle = angle + rotation * torque
		end
	end,
}