Animal = class{
	init = function(self)

		self._type = 'animal'
		self._debug = true

		self.position = {50, 100, 50}
		self.size = {200, 200}
		self.scale = {3, 3}

		self.timer = 0

		manager:register(self)
	end,

	update = function(self, dt)
		self.timer = self.timer + dt
		local position = self.position
		position[1] = 50 + 100 * math.cos(self.timer)
	end,

	draw = function(self, mode, position)

		local size = self.size
		local scale = self.scale

		local x, y = unpack(position)
		local w, h = unpack(size)
		local sx, sy = unpack(scale)

		if mode == 'scanner' then
			lg.rectangle('line', x, y, w * sx, h * sy)
		elseif mode == 'default' then
			lg.rectangle('line', x, y, w * sx, h * sy)
		end

	end,
}