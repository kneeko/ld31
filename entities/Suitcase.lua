-- contains relatively positioned animals
-- based on a bunch of manually preset main components
-- and dispersed misc components

-- is created and moved by the suitcase manager

-- suitcase should have its own timer

Suitcase = class{
	init = function(self)

		self._type = 'suitcase'
		self._debug = true

		self.position = {-200, 140, 1}
		self.size = {400, 300}
		self.origin = {200, 0}
		self.scale = {1, 1}


		if math.random() > 0.3 then
			self.answer = math.floor(9 * math.random())
		else
			self.answer = ''
		end

		-- @todo
		-- pack the suitcase with various sized items
		-- and animals

		--[[
		local animal = Animal()
		animal.parent = self
		animal.positioning = 'relative'
		]]--

		manager:register(self)

	end,

	update = function(self, dt)
	end,

	draw = function(self, mode, position)

		local size = self.size
		local scale = self.scale
		local origin = self.origin

		local x, y = unpack(position)
		local w, h = unpack(size)
		local ox, oy = unpack(origin)
		local sx, sy = unpack(scale)

		local answer = self.answer

		if mode == 'default' then
			lg.setColor(238, 85, 85)
		else
			lg.setColor(138, 85, 85)
		end

		lg.rectangle('fill', x - ox, y - oy, w * sx, h * sy)
		
		lg.setColor(255, 255, 255)
		fonts:draw('Inconsolata.otf', 28, answer, x + 15, y + 15)

	end,

	bid = function(self, attempt)
		local answer = self.answer
		local correct = tonumber(attempt) == answer
		print(correct, attempt, answer)
		return correct
	end,
}