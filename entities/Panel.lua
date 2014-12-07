-- @todo
-- better name
-- keep track of lives
-- signal game failure when running out

Panel = class{
	init = function(self)

		local w = 150
		local h = 50


		local position = {95, -4, 1}
		local size = {w, h}
		local scale = {1, 1}
		local origin = {0, h}

		self.position = position
		self.size = size
		self.scale = scale
		self.origin = origin

		local indicator = Indicator()
		indicator.parent = self
		indicator.positioning = 'relative'

		self.color = {205, 191, 180}

		-- @todo
		-- this animation should last a short while
		self.timer = 0

		manager:register(self)

	end,

	update = function(self, dt)

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
			lg.rectangle('fill', x - ox, y - oy, w, h)
		end

	end,

	set = function(self, state)
	end,
}