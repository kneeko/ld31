Item = class{
	init = function(self)

		self._type = 'item'
		self._debug = true

		-- @todo lookup table for different images
		-- to determine the size

		local x = 30 + 300 * math.random()
		local y = 30 + 100 * math.random()

		local w = 80
		local h = 50

		self.position = {x, y, 0.8}
		self.size = {w, h}
		self.scale = {1, 1}

		self.overrides = {parallax = 1}

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
			lg.setColor(200, 220, 190)

			lg.rectangle('line', x, y, w, h)
		end

	end,
}