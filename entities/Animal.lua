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

		local defaults = sprites.default.animals
		local scanners = sprites.scanner.animals


		if not defaults then
			error()
		end

		local selected = 1 + math.floor(difficulty * math.random())

		local default = defaults[selected]
		local scanner = scanners[selected]

		local w = scanner:getWidth()
		local h = scanner:getHeight()


		local graphics = {
			default = default,
			scanner = scanner
		}

		self.value = selected * 100

		local angle = math.pi * 2 * math.random()
		local scale = 0.4 + 0.1 * math.random()

		local r, g, b, a = 255, 255, 255, 255
		local variance = 35
		r = r - variance * math.random()
		g = g - variance * math.random()
		b = b - variance * math.random()

		local color = {r, g, b, a}
		self.color = color

		self.position = {x, y, 1}
		self.size = {w, h}
		self.scale = {scale, scale}
		self.angle = angle
		self.direction = angle
		self.origin = {w*0.5, h*0.5}

		self.graphics = graphics

		self.overrides = {parallax = 1}

		local step = 1.6

		self.timer = 0
		self.upcoming = step * math.random()
		self.wiggling = 0
		self.throttle = 0
		self.duration = 0.7
		self.step = step
		self.fudging = 1.5

		self.callbacks = {'inputpressed', 'inputreleased'}

		manager:register(self)

	end,

	update = function(self, dt)


		local dragging = self.dragging
		local throttle = self.throttle
		local tossed = self.tossed

		if tossed then
			-- apply velocity to position

			-- @todo animals will need to be responsible for removing themselves
			-- @todo add gravity to velocity
			-- @todo add a target with lerping for a better feel
			local velocity = self.velocity

			-- this should come in gradually maybe?
			velocity[2] = velocity[2] + dt * 900
			local vx, vy = unpack(velocity)


			self.position[1] = self.position[1] + vx * dt
			self.position[2] = self.position[2] + vy * dt

			-- add to direction
			local rotation = self.rotation
			local direction = self.direction
			self.direction = direction + rotation * dt * 3


		end

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

		local direction = self.direction
		self.angle = direction + angle

		if dragging then

			local source = dragging.source
			local previous = dragging.previous
			local x, y, pressure, active = source()
			local px, py = unpack(previous)
			local dx, dy = x - px, y - py
			previous[1] = x
			previous[2] = y

			self.position[1] = self.position[1] + dx
			self.position[2] = self.position[2] + dy

			-- @todo
			-- if a certain threshold away
			-- just release the object

		end

		if self.position[2] > lg.getHeight() * 2 then
			self:_destroy()
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

		local graphics = self.graphics

		if mode == 'scanner' then
			local color = self.color
			local graphic = graphics['scanner']
			lg.setColor(color)
			lg.draw(graphic, x, y, angle, sx, sy, ox, oy)
		end

		local tossed = self.tossed
		if tossed and mode == 'default' then
			local graphic = graphics['default']
			local color = self.color
			lg.setColor(color)
			lg.draw(graphic, x, y, angle, sx, sy, ox, oy)
		end

	end,

	inputpressed = function(self, identifier, x, y, id, pressure, source, project)


		if tonumber(id) or id == 'l' then 
			if self:intersecting(identifier, x, y) then

				local drag = {
					intial = {x, y},
					previous = {x, y},
					source = project,
				}

				-- @todo make this more interial

				self.dragging = drag

			end
		end

	end,

	inputreleased = function(self, identifier, x, y, id, pressure)

		-- release from drag
		local dragging = self.dragging
		if dragging then

			self.tossed = true
			self.solved = true

			local ix, iy = unpack(dragging.intial)
			local vx, vy = x - ix, y - iy

			local amplification = 3.5
			vx = vx * amplification
			vy = vy * amplification

			local velocity = {vx, vy}
			self.velocity = velocity

			-- rotation
			local angle = math.atan2(vy, vx)
			self.rotation = angle

			self.dragging = nil

			local points = self.value
			signal.emit('score', points)

			woosh:play()

			local popup = Popup(points)
			popup.position[1] = ix + 100 * math.random()
			popup.position[2] = iy + 100 * math.random()
			popup.velocity[1] = vx * (0.2 + 0.05 * math.random())
			popup.velocity[2] = vy * (0.2 + 0.05 * math.random())
			popup.angle = angle + math.pi * 0.5

			
		end


	end,

	wiggle = function(self)
		self.wiggling = 0
	end,
}