Item = class{
	init = function(self)

		self._type = 'item'
		self._debug = false

		-- @todo lookup table for different images
		-- to determine the size

		local choices = sprites.misc
		local selected = 1 + math.floor(#choices * math.random())
		local graphic = choices[selected]

		local x = 0
		local y = 0

		local w = graphic:getWidth()
		local h = graphic:getHeight()

		local scale = 0.7
		local angle = math.pi * 2 * math.random()

		local r, g, b, a = 255, 255, 255, 30
		local variance = 35
		r = r - variance * math.random()
		g = g - variance * math.random()
		b = b - variance * math.random()

		local color = {r, g, b, a}
		self.color = color


		self.graphic = graphic
		self.position = {x, y, 0.8}
		self.size = {w, h}
		self.scale = {1, 1}
		self.origin = {w*0.5, h*0.5}
		self.angle = angle
		self.scale = {scale, scale}

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

			local origin = self.origin
			local ox, oy = unpack(origin)
			local angle = self.angle

			local graphic = self.graphic
			local color = self.color

			lg.setColor(color)
			lg.draw(graphic, x, y, angle, sx, sy, ox, oy)

			--lg.rectangle('line', x, y, w, h)
		end

	end,
}