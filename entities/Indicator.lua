-- @todo
-- better name
-- keep track of lives
-- signal game failure when running out

Indicator = class{
	init = function(self)

		local position = {500, 60, 1}

		local w = 20
		local h = 20
		local size = {w, h}
		local scale = {1, 1}
		local origin = {w*0.5, h*0.5}

		self._debug = false

		self.position = position
		self.size = size
		self.scale = scale
		self.origin = origin

		self.color = {120, 82, 82, 140}


		-- @todo
		-- this animation should last a short while
		self.timer = math.pi * 2 * math.random()

		manager:register(self)

	end,

	update = function(self, dt)

		self.timer = self.timer + dt

	end,

	draw = function(self, mode, ...)
		local position = ...
		local x, y = unpack(position)

		local size = self.size
		local scale = self.scale
		local origin = self.origin

		local w, h = unpack(size)
		local sx, sy = unpack(scale)
		local ox, oy = unpack(origin)

		if mode == 'interface' then

			local color = self.color
			lg.setColor(color)

			local lit = self.lit
			if lit then
				lg.setColor(200, 82, 82)
			end
			local r = w*0.5

			lg.setLineWidth(3)
			lg.circle('fill', x, y, r, 32)

			lg.setColor(175, 160, 149)
			lg.circle('line', x, y, r, 32)

			if lit then
				lg.setBlendMode('additive')
				local timer = self.timer
				local a = 40 + 6 * math.sin(timer * math.pi * 3)
				local r = (r * 1.7) + 1 * math.sin(timer * math.pi * 3)
				lg.setColor(255, 0, 0, a)
				lg.circle('fill', x, y, r, 32)
				lg.setBlendMode('alpha')

				lg.setColor(255, 0, 0, a * 0.2)
				lg.circle('line', x, y, r, 32)
				lg.setBlendMode('alpha')
			end


		end

	end,
}