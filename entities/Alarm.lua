Alarm = class{
	init = function(self)

		self._debug = false

		local graphic = lg.newImage('assets/images/alarm.png')

		local w = graphic:getWidth()
		local h = graphic:getHeight()

		local scaling = 0.4


		local position = {500, 49, 1}
		local size = {w, h}
		local scale = {scaling, scaling}
		local origin = {w*0.5, h}

		self.graphic = graphic
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
			self.color = {200, 255, 200}
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