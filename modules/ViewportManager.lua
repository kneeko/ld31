ViewportManager = class{
	init = function(self, manager)

		local viewports = {}

		-- @todo
		-- force viewport order
		-- figure out viewport ordering/culling bug

		local viewport = Viewport(1, 1)
		viewport.mode = 'default'
		viewports[1] = viewport

		local viewport = Viewport(0.7, 1.8)
		viewport.mode = 'scanner'
		viewport.origin[2] = 0.55 * viewport.size[2]
		viewport.position[2] = -0.05 * viewport.size[2]
		-- @todo proper viewport offset

		-- @temp shader test
		local shader = lg.newShader('shaders/crt.frag')
		local w, h = lg.getWidth(), lg.getHeight()
		shader:send('inputSize', {w, h})
		shader:send('outputSize', {w, h})
		shader:send('textureSize', {w, h})
		--viewport.shader = shader

		viewports[2] = viewport


		local viewport = Viewport(1, 1)
		viewport.mode = 'interface'
		viewports[3] = viewport

		self.viewports = viewports

		-- development camera zooming
		self.zooming = false

		local controller = ViewportController(manager, viewports)
		self.controller = controller
		self.manager = manager

	end,

	update = function(self, dt)

		local controller = self.controller
		controller:update(dt)

		-- todo
		-- migrate these dev controls into viewportcontroller

		local input = self.input or {}
		local ix, iy = unpack(input)
		local mx, my = lm.getPosition()
		local dx, dy, dz, dr = 0, 0, 0, 0
		self.input = {mx, my}

		local panning = self.panning
		local rotating = self.rotating
		local zooming = self.zooming and lm.isDown('l')

		if panning then
			dx = ix and ix - mx or 0
			dy = iy and iy - my or 0
		end

		if zooming then
			dz = iy and iy - my or 0
			dz = dz * 0.01
		end

		if rotating then
			dr = ix and ix - mx or 0
			dr = dr * 0.005
		end

		local controller = self.controller
		local cx, cy, cz = unpack(controller.interpolated)

		-- should the viewport have a limiter built in?
		-- that makes sense I guess

		-- send locks and unlocks?


		local viewports = self.viewports
		local manager = self.manager
		for i = 1, #viewports do
			-- TODO fix the angled translation
			--local x = cx-- + dx-- * math.cos(angle) + dy * math.sin(angle)
			--local y = cy-- + dy-- * math.sin(angle) + dy * math.cos(angle)
			--local z = cz-- + dz

			local x = cx
			local y = cy
			local z = cz + dz

			-- apply transformations to viewport
			local viewport = viewports[i]
			viewport:translate(x, y)
			viewport:zoom(z)
			viewport:rotate(dr)

			-- update the viewport bound and position using the limiter
			viewport:update(dt)
			
			-- prepare projections of scene objects for drawing
			viewport:prepare(manager)

		end
	end,

	draw = function(self)

		local manager = self.manager
		local viewports = self.viewports
		for i = 1, #viewports do
			local viewport = viewports[i]
			viewport:draw(manager)
		end

		-- controller debug
		local controller = self.controller
		--controller:draw()

	end,

	set = function(self, n)
		-- we need to clean up when this happens
		local manager = self.manager
		local viewports = self.viewports
		for i = 1, #viewports do
			local viewport = viewports[i]
			local identifier = viewport._identifier:get()
			manager:flush(identifier)
		end
		self:init(manager, n)
	end,

	resize = function(self)
		--self:init(self.n)
	end,

	project = function(self, x, y)
		local viewport = self.viewports[1]
		return viewport:project(x, y)
	end,

	inputpressed = function(self, ...)
		local controller = self.controller
		controller:inputpressed(...)
	end,

	inputreleased = function(self, ...)
		local controller = self.controller
		controller:inputreleased(...)
	end,

	keypressed = function(self, key, code)
		if key == 'lctrl' then
			--self.zooming = true
			--self.controller.zooming = true
		end
		-- pass these to the main viewport?
	end,

	keyreleased = function(self, key, code)
		if key == 'lctrl' then
			--self.zooming = false
			--self.controller.zooming = false
		end
	end,
}