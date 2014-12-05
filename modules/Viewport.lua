Viewport = class{
	init = function(self, v, step, stretch, interaxial)

		local identifier = Identifier()
		self._identifier = identifier
		self._debug = false

		print('Created a viewport with identifier: ' .. identifier:get())

		local ww, wh = lg.getWidth(), lg.getHeight()
		local w = ww * stretch
		local h = wh

		local bound = {0, w, 0, h}
		local position = {step * interaxial, 0, 1}

		self.step = step * ww
		self.position = position
		self.bound = bound
		self.angle = 0

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
				threshold = {0.25 , 1.5},
				limit = {0.05, 4},
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
		local total = self.total
		local length = w * 0.5 * (1 / total)
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
		local step = self.step

		-- we're going to draw to this viewport's canvas
		lg.setCanvas(canvas)
		canvas:clear()
		
		-- draw the scene
		camera:attach()
		scene:draw(identifier, position, bound)
		camera:detach()

		-- debug info
		local debug = self._debug
		if debug then
			local limiter = self.limiter
			local x, y, z = unpack(position)
			local s = 'camera (' .. math.floor(x) .. ', ' .. math.floor(y) .. ', ' .. z .. ')'
			s = s .. '\n' .. lt.getFPS() .. ' fps'
			limiter:draw()
			lg.setColor(255, 255, 255)
			lg.print(s, 15, 15)
		end


		lg.setCanvas()

		lg.setColor(255, 255, 255)
		lg.setBlendMode('premultiplied')

		lg.draw(canvas, step)
		lg.setBlendMode('alpha')


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