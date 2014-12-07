-- @todo
-- better name
-- keep track of lives
-- signal game failure when running out

-- maybe center over the display?

Panel = class{
	init = function(self)

		local w = 120
		local h = 50

		local position = {95, -4, 1}
		local size = {w, h}
		local scale = {1, 1}
		local origin = {0, h}

		self.position = position
		self.size = size
		self.scale = scale
		self.origin = origin

		local stock = 3
		local padding = 10

		-- create a callback here?

		local lights = {}
		for i = 1, stock do
			local indicator = Indicator()
			local x = padding + (w - padding * 2) * (i / stock - (1 / stock) * 0.5)
			local y = h * 0.5
			indicator.position[1] = x
			indicator.position[2] = y
			indicator.parent = self
			indicator.positioning = 'relative'
			table.insert(lights, indicator)
		end

		self.lights = lights

		signal.register('wrong', function()
			self:light()
		end)

		self.color = {205, 191, 180}

		-- @todo
		-- this animation should last a short while
		self.timer = 0

		manager:register(self)

	end,

	update = function(self, dt)

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
			local color = self.color
			lg.setColor(color)
			lg.rectangle('fill', x - ox, y - oy, w, h)
		end

	end,

	clear = function(self)
		local lights = self.lights
		for _,light in ipairs(lights) do
			light.lit = false
		end
	end,

	light = function(self)
		print('lighting panel indicator')
		local lights = self.lights
		local found
		for i,light in ipairs(lights) do
			if not light.lit then
				light.lit = true
				found = true
				if i == #lights then
					-- game over
					print('panel full, calling clear')
					scene:clear()
				end
				break
			end
		end
	end,

	-- @todo
	-- toggle the indicators based on the life counter
}