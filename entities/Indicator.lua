-- @todo
-- better name
-- keep track of lives
-- signal game failure when running out

Indicator = class{
	init = function(self)

		local position = {100, 0, 1}
		local size = {20, 20}
		local scale = {1, 1}
		local origin = {0, 0}

		self._debug = true

		self.position = position
		self.size = size
		self.scale = scale
		self.origin = origin

		-- @todo
		-- this animation should last a short while
		self.timer = 0

		manager:register(self)

	end,

	update = function(self, dt)

		self.timer = math.max(self.timer - dt, 0)
		if self.timer == 0 then
			self.color = {100, 255, 200}
		end

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
		if state == 'success' then
			self.color = {50, 216, 47}
		else
			self.color = {216, 50, 47}
		end
		self.timer = 0.8
	end,
}