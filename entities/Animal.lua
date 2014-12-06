Animal = class{
	init = function(self)

		self._type = 'animal'
		self._debug = true

		self.position = {0, 0, 50}
		self.size = {50, 50}
		self.scale = {1, 1}

		manager:register(self)
	end,

	update = function(self, dt)
	end,

	draw = function(self, mode, position)

		local size = self.size
		local scale = self.scale

		local x, y = unpack(position)
		local w, h = unpack(size)
		local sx, sy = unpack(scale)


		--[[
		if mode == 'scanner' then
			lg.rectangle('line', x, y, w * sx, h * sy)
		elseif mode == 'default' then
			lg.rectangle('line', x, y, w * sx, h * sy)
		end
		]]--

	end,
}