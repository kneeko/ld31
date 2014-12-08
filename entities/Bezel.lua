-- draw around the canvas in the ui viewport

Bezel = class{
	init = function(self)

		local graphic = lg.newImage('assets/images/bezel.png')

		local sw, sh = lg.getWidth(), lg.getHeight()
	 	local w = sw * 0.7
	 	local h = sh * 0.7

		local x = sw*0.5
		local y = 20

	 	local w = graphic:getWidth()
	 	local h = graphic:getHeight()

	 	local scaling = 0.48

		local position = {x, y, math.huge}
		local size = {50, 50}
		local scale = {scaling, scaling}
		local origin = {w*0.5, 0}

		self.position = position
		self.size = size
		self.scale = scale
		self.origin = origin

		self._uncullable = true

		local alarm = Alarm()
		alarm.parent = self
		alarm.positioning = 'relative'
		self.alarm = alarm

		local lives = Panel()
		lives.parent = self
		lives.positioning = 'relative'
		self.lives = lives

		self.graphic = graphic

		local axles = {}

		-- @todo place these manually


		--[[
		for i = 1, 4 do
			-- place axles
			local axle = Axle()
			local x = (sw * i / 4) - (sw / 4) * 0.5
			axle.position[1] = x

			table.insert(axles, axle)
		end
		]]--

		local left = Axle()
		local right = Axle()

		left.position[1] = 75
		right.position[1] = sw - 45

		table.insert(axles, left)
		table.insert(axles, right)

		self.axles = axles

		manager:register(self)

	end,

	update = function(self, dt)
	end,

	draw = function(self, mode, ...)
		local position = ...
		local x, y = unpack(position)

		if mode == 'interface' then

			local scale = self.scale
			local sx, sy = unpack(scale)
			local size = self.size
			local w, h = unpack(size)

			local origin = self.origin
			local ox, oy = unpack(origin)
			local angle = 0

			-- draw the rest of the bezel here?
			local graphic = self.graphic
			lg.setColor(255, 255, 255)
			lg.draw(graphic, x, y, angle, sx, sy, ox, oy)

		end
	end,

	clear = function(self)
		local lives = self.lives
		lives:clear()
	end,
}