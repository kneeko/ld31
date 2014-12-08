--[[

make a test animal
figure out the mesh thing
wiggling the vertices should work

]]-- 


Animal = class{
	init = function(self, difficulty)

		self._type = 'animal'
		self._debug = false

		local x = 30 + 300 * math.random()
		local y = 30 + 100 * math.random()

		-- @todo
		-- randomly select this asset
		-- with parameters
		local choices = sprites.animals
		local selected = 1 + math.floor(difficulty * math.random())
		local graphic = choices[selected]
		local w = graphic:getWidth()
		local h = graphic:getHeight()

		local angle = math.pi * 2 * math.random()
		local scale = 0.4 + 0.1 * math.random()

		local r, g, b, a = 255, 255, 255, 255
		local variance = 35
		r = r - variance * math.random()
		g = g - variance * math.random()
		b = b - variance * math.random()

		local color = {r, g, b, a}
		self.color = color

		self.position = {x, y, 0.5}
		self.size = {w, h}
		self.scale = {scale, scale}
		self.angle = angle
		self.rotation = angle
		self.origin = {w*0.5, h*0.5}

		self.graphic = graphic

		self.overrides = {parallax = 1}

		local step = 1.6

		self.timer = 0
		self.upcoming = step * math.random()
		self.wiggling = 0
		self.duration = 0.7
		self.step = step

		self.callbacks = {'inputpressed', 'inputreleased'}

		manager:register(self)

	end,

	update = function(self, dt)
		--self.angle = self.angle + dt

		local timer = self.timer
		local step = self.step
		local upcoming = self.upcoming
		self.timer = timer + dt
		if timer > upcoming then
			self.upcoming = timer + step + step * math.random()
			self:wiggle()
		end


		local duration = self.duration
		self.wiggling = math.min(self.wiggling + dt, duration)
		local wiggling = self.wiggling
		local amplitude = math.pi * 0.015
		local angle = math.sin(wiggling / duration * math.pi * 5) * amplitude * math.abs(1 - (wiggling / duration))
		-- @todo remember the intial angle

		local rotation = self.rotation
		self.angle = rotation + angle

		local dragging = self.dragging
		if dragging then

		end

	end,

	draw = function(self, mode, ...)

		local position = ...
		local size = self.size
		local scale = self.scale
		local angle = self.angle
		local origin = self.origin

		local x, y = unpack(position)
		local w, h = unpack(size)
		local sx, sy = unpack(scale)
		local ox, oy = unpack(origin)


		if mode == 'scanner' then
			local graphic = self.graphic
			local color = self.color
			lg.setColor(color)
			lg.draw(graphic, x, y, angle, sx, sy, ox, oy)
		end

	end,

	inputpressed = function(self, identifier, x, y, id, pressure, source, project)


		if tonumber(id) or id == 'l' then 
			if self:intersecting(identifier, x, y) and not self.raised then

				self.dragging = source
			end
		end

	end,

	inputreleased = function(self, identifier, x, y, id, pressure)

		-- release
		self.dragging = nil

	end,

	wiggle = function(self)
		self.wiggling = 0
	end,
}