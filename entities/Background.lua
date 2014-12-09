Background = class{
	init = function(self)

		local position = {0, 0, math.huge}
		local w = lg.getWidth()
		local h = lg.getHeight()
		local size = {w, h}
		local scale = {1, 1}
		local origin = {w*0.5, h*0.5}

		local graphic = lg.newImage('assets/images/bg.png')

		self.graphic = graphic
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
			lg.setColor(50, 50, 50)
			lg.rectangle('fill', x, y, w, h)
		end

		if mode == 'default' then
			lg.setColor(255, 255, 255)
			local graphic = self.graphic
			lg.draw(graphic, -214.2857142857143, -450, 0, 1.428571428571429, 1.428571428571429)
		end


	end,
}