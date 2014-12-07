-- contains relatively positioned animals
-- based on a bunch of manually preset main components
-- and dispersed misc components

-- is created and moved by the suitcase manager

-- suitcase should have its own timer

Suitcase = class{
	init = function(self)

		self._type = 'suitcase'
		self._debug = false

		self.position = {-200, 165, 1}
		self.size = {400, 270}
		self.origin = {200, 0}
		self.scale = {1, 1}


		-- @todo
		-- pack the suitcase with various sized items
		-- and animals

		local threshold = 0.3
		local min = 1
		local max = 5


		-- these parameters should be passed or the content could be generated and then stuffed into the suitcase

		local animals = {}
		if math.random() > threshold then
			local n = min + math.floor(max * math.random())
			for i = 1, n do
				local animal = Animal()
				animal.parent = self
				animal.positioning = 'relative'
				table.insert(animals, animal)
			end
			self.answer = n

		else
			self.answer = 0
		end

		self.solved = false

		-- i will really want a table for everything generated as well
		self.animals = animals



		manager:register(self)

	end,

	update = function(self, dt)
	end,

	draw = function(self, mode, ...)

		local size = self.size
		local scale = self.scale
		local origin = self.origin

		local position = ...

		local x, y = unpack(position)
		local w, h = unpack(size)
		local ox, oy = unpack(origin)
		local sx, sy = unpack(scale)


		if mode == 'default' then
			lg.setColor(238, 85, 85)
			lg.rectangle('fill', x - ox, y - oy, w * sx, h * sy)
		elseif mode == 'scanner' then
			lg.setColor(188, 85, 85)
			lg.rectangle('fill', x - ox, y - oy, w * sx, h * sy)
			local answer = self.answer
			lg.setColor(255, 255, 255)
			fonts:draw('Inconsolata.otf', 28, answer, x + 15, y + 15)
		end

	end,

	bid = function(self, attempt)
		local answer = self.answer
		local correct = tonumber(attempt) == answer
		if correct then
			self.solved = true
		end
		return correct
	end,

	destroy = function(self)
		local animals = self.animals
		for i = 1, #animals do
			animals[i]:_destroy()
		end
		self:_destroy()
	end,
}