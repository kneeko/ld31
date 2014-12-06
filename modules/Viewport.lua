Viewport = class{
	init = function(self, s, z)

		local identifier = Identifier()
		self._identifier = identifier
		self._debug = false

		print('Created a viewport with identifier: ' .. identifier:get())

		local w, h = lg.getWidth(), lg.getHeight()

		local bound = {0, w, 0, h}
		local position = {0, 0, z}
		local size = {w, h}
		local angle = 0
		local scale = {s, s}
		local origin = {w*0.5, h*0.5}

		self.position = position
		self.bound = bound
		self.angle = angle
		self.scale = scale
		self.origin = origin
		self.size = size

		-- limiter ruleset
		local ruleset = {
			-- x
			[1] = {
				filter = function(delta)
					local z = position[3]
					local reciprocal = 1 / z
					local filtered = delta * reciprocal
					return filtered
				end,
			},
			-- y
			[2] = {
				filter = function(delta)
					local z = position[3]
					local reciprocal = 1 / z
					local filtered = delta * reciprocal
					return filtered
				end,
			},
			-- z (zoom)
			[3] = {
				threshold = {0.25 , 8},
				limit = {0.05, 8},
				filter = function(delta)
					return delta
				end,
			}
		}
		local limiter = Limiter(position, ruleset)


		-- v is the number of viewports
		-- but this is really a terrible way to deal with multiple cameras
		-- especially since in practice they probably won't be used for stereoscopy
		-- but more likely ui overlays etc
		self.total = v
		self.camera = Camera(v)
		self.canvas = lg.newCanvas(w, h)
		self.timer = 0
		self.limiter = limiter

	end,

	update = function(self, dt)

		

		local limiter = self.limiter
		limiter:update(dt)

		local position = self.position
		local x, y, z = unpack(position)
		
		-- update the bound
		local bound = self.bound
		local w, h = lg.getWidth(), lg.getHeight()

		-- scale the viewport bound by the reciprocal of the zoom
		-- in order to cull at the canvas edge
		local reciprocal = 1 / z
		local length = w * 0.5
		local height = h * 0.5

		local l = length - length * reciprocal
		local r = length + length * reciprocal
		local t = height - height * reciprocal
		local b = height + height * reciprocal

		bound[1] = l
		bound[2] = r
		bound[3] = t
		bound[4] = b

		-- update the camera position
		local camera = self.camera
		local ox = w * 0.5
		local oy = h * 0.5
		local angle = self.angle
		camera:set(x + ox, y + oy, z)
		camera:rotate(angle)

	end,

	draw = function(self, scene)

		local position = self.position
		local bound = self.bound
		local camera = self.camera
		local canvas = self.canvas
		local identifier = self._identifier:get()

		local mode = self.mode

		-- we're going to draw to this viewport's canvas
		lg.setCanvas(canvas)
		canvas:clear()
		
		-- draw the scene
		camera:attach()
		scene:draw(identifier, position, bound, mode)
		camera:detach()

		-- debug info
		local debug = self._debug
		if debug then
			local limiter = self.limiter
			local x, y, z = unpack(position)
			local s = ('camera (%s, %s, %s)\n %s fps\nmode: %s'):format(math.floor(x), math.floor(y), z, lt.getFPS(), mode)
			lg.setColor(255, 255, 255)
			lg.print(s, 15, 15)
			--limiter:draw()
		end


		local angle = self.angle
		local size = self.size
		local scale = self.scale
		local origin = self.origin

		local w, h = unpack(size)
		local sx, sy = unpack(scale)
		local ox, oy = unpack(origin)

		local x = w*0.5
		local y = h*0.5

		local shader = self.shader

		lg.setCanvas()
		lg.setShader(shader)
		lg.setColor(255, 255, 255)
		lg.setBlendMode('premultiplied')

		-- draw the viewport canvas
		-- which has the scene rendered to it
		lg.draw(canvas, x, y, angle, sx, sy, ox, oy)

		lg.setBlendMode('alpha')
		lg.setShader()

	end,

	prepare = function(self, scene)

		local identifier = self._identifier:get()
		local position = self.position
		local bound = self.bound
		scene:prepare(identifier, position, bound)

	end,

	translate = function(self, dx, dy)

		local limiter = self.limiter
		limiter:shift(1, dx)
		limiter:shift(2, dy)

	end,

	zoom = function(self, dz)

		local limiter = self.limiter
		limiter:shift(3, dz)

	end,

	rotate = function(self, dr)
		local angle = self.angle
		self.angle = dr and angle + dr or angle
	end,
}