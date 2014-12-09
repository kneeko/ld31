Popup = class{
	init = function(self, value)

		local position = {0, 0, 0.5}
		local velocity = {0, 0}
		local string


		local color, font_size
		if tonumber(value) then
			if value > 0 then
				color = {220, 255, 220}
				font_size = 30
				string = ("+%s"):format(value)
			else
				color = {255, 200, 200, 155}
				font_size = 20
				string = ("%s"):format(value)
			end
		else
			color = {255, 200, 200, 155}
				font_size = 50
				string = value
		end

		local font = fonts:add('Helvetica.ttf', font_size)

		local w = font:getWidth(string)
		local h = font:getHeight(string)

		local scale = {1, 1}
		local size = {w, h}
		local origin = {w*0.5, h*0.5}

		self.string = string

		self.position = position
		self.size = size
		self.origin = origin
		self.scale = scale
		self.angle = angle
		self.font = font
		self.color = color

		self.lifetime = 0.6 + 0.4 * math.random()
		self.velocity = velocity

		self._debug = false

		self.entry = 0
		self.exit = 0

		self.duration = 0.1

		self.entering = true
		self.exiting = false

		self.overrides = {parallax = 1}

		manager:register(self)

	end,

	update = function(self, dt)

		local velocity = self.velocity
		local vx, vy = unpack(velocity)
		velocity[1] = vx - vx * dt * 3
		velocity[2] = vy - vy * dt * 3

		local position = self.position
		local x, y = unpack(position)
		position[1] = x + vx * dt
		position[2] = y + vy * dt

		local lifetime = self.lifetime
		self.lifetime = lifetime - dt

		if lifetime < 0 then
			self.exiting = true
		end

		local entering = self.entering
		if entering then

			local entry = self.entry
			local duration = self.duration * 0.7
			self.entry = math.min(entry + dt, duration)

			local progress = entry / duration
			local scale = self.scale
			scale[1] = progress
			scale[2] = progress

		end

		local exiting = self.exiting
		if exiting then

			local duration = self.duration
			local exit = self.exit
			self.exit = math.min(exit + dt, duration)

			local progress = math.abs(1 - (exit / duration))
			local scale = self.scale
			scale[1] = progress
			scale[2] = progress

			if exit == duration then
				self:_destroy()
			end
		end


	end,

	draw = function(self, mode, ...)

		local position = ...
		local x, y = unpack(position)

		if mode == 'scanner' then

			local font = self.font
			local string = self.string
			local size = self.size
			local angle = self.angle
			local scale = self.scale
			local origin = self.origin
			local sx, sy = unpack(scale)
			local ox, oy = unpack(origin)
			local w, h = unpack(size)
			local color = self.color

			font:set()
			lg.setColor(color)
			lg.print(string, x, y, angle, sx, sy, ox, oy)

		end

	end,
}