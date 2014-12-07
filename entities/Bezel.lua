-- draw around the canvas in the ui viewport

Bezel = class{
	init = function(self)

		local sw, sh = lg.getWidth(), lg.getHeight()
	 	local w = sw * 0.7
	 	local h = sh * 0.7
		local x = (sw - w)*0.5
		local y = (sh - h)*0.4

		local position = {x, y, math.huge}
		local size = {50, 50}
		local scale = {1, 1}

		self.position = position
		self.size = size
		self.scale = scale

		local alarm = Alarm()
		alarm.parent = self
		alarm.positioning = 'relative'
		self.alarm = alarm

		local stopwatch = Stopwatch()
		stopwatch.parent = self
		stopwatch.positioning = 'relative'
		self.stopwatch = stopwatch

		local axles = {}
		for i = 1, 4 do
			-- place axles
			local axle = Axle()
			local x = (sw * i / 4) - (sw / 4) * 0.5
			axle.position[1] = x

			table.insert(axles, axle)
		end

		self.axles = axles

		manager:register(self)

	end,

	update = function(self, dt)
	end,

	draw = function(self, mode, ...)
		local position = ...
		local x, y = unpack(position)

		if mode == 'interface' then

			lg.setColor(205, 191, 180)
			lg.setLineWidth(8)
			lg.rectangle('line', x, y, lg.getWidth() * 0.7, lg.getHeight() * 0.7)

		end
	end,
}