Item = class{
	init = function(self)

		self._type = 'item'
		self._debug = false

		-- @todo lookup table for different images
		-- to determine the size

		local defaults = sprites.default.misc
		local scanners = sprites.scanner.misc

		local selected = math.min(1 + math.floor(#defaults * math.random()), #defaults)

		local default = defaults[selected]
		local scanner = scanners[selected]

		local w = scanner:getWidth()
		local h = scanner:getHeight()

		local graphics = {
			scanner = scanner,
			default = default,
		}

		local x = 0
		local y = 0

		local w = scanner:getWidth()
		local h = scanner:getHeight()

		local scale = 0.7
		local angle = math.pi * 2 * math.random()

		local r, g, b, a = 255, 255, 255, 100
		local variance = 35
		r = r - variance * math.random()
		g = g - variance * math.random()
		b = b - variance * math.random()

		local color = {r, g, b, a}
		self.color = color


		self.graphics = graphics
		self.position = {x, y, 0.8}
		self.size = {w, h}
		self.scale = {1, 1}
		self.origin = {w*0.5, h*0.5}
		self.angle = angle
		self.scale = {scale, scale}

		self.overrides = {parallax = 1}
		self.callbacks = {'inputpressed', 'inputreleased'}

		manager:register(self)

	end,

	update = function(self, dt)

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
			local angle = self.angle
			self.angle = angle + rotation * dt * 3


		end

		local dragging = self.dragging
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
		end

		if self.position[2] > lg.getHeight() * 2 then
			self:_destroy()
		end

	end,

	draw = function(self, mode, ...)

		local position = ...
		local size = self.size
		local scale = self.scale

		local x, y = unpack(position)
		local w, h = unpack(size)
		local sx, sy = unpack(scale)

		local graphics = self.graphics
		local graphic = graphics[mode]

		if mode == 'scanner' then

			local origin = self.origin
			local ox, oy = unpack(origin)
			local angle = self.angle

			local color = self.color

			lg.setColor(color)
			lg.draw(graphic, x, y, angle, sx, sy, ox, oy)

			--lg.rectangle('line', x, y, w, h)
		end

		local tossed = self.tossed
		if tossed and mode == 'default' then

			local origin = self.origin
			local ox, oy = unpack(origin)
			local angle = self.angle

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

			local amplification = 4
			vx = vx * amplification
			vy = vy * amplification

			local velocity = {vx, vy}
			self.velocity = velocity

			-- rotation
			local angle = math.atan2(vy, vx)
			self.rotation = angle

			self.dragging = nil

			woosh:play()

			local points = -10
			signal.emit('score', points)

			local popup = Popup(points)
			popup.position[1] = ix + 100 * math.random()
			popup.position[2] = iy + 100 * math.random()
			popup.velocity[1] = vx * 0.2
			popup.velocity[2] = vy * 0.2
			popup.angle = angle + math.pi * 0.5

			
		end


	end,
}