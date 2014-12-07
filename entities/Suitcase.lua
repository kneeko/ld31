-- contains relatively positioned animals
-- based on a bunch of manually preset main components
-- and dispersed misc components

-- is created and moved by the suitcase manager

-- suitcase should have its own timer

Suitcase = class{
	init = function(self)

		self._type = 'suitcase'
		self._debug = false

		-- get the size from a table

		local w = 400
		local h = 350

		local x = -w
		local y = lg.getHeight() - 160


		self.position = {x, y, 1}
		self.size = {w, h}
		self.origin = {w*0.5, h}
		self.scale = {1, 1}


		self:pack()


		self.solved = false

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
			lg.setColor(170, 170, 170, 100)
			lg.rectangle('line', x - ox, y - oy, w * sx, h * sy)
			local answer = self.answer
			lg.setColor(255, 255, 255)
			fonts:draw('Inconsolata.otf', 28, answer, x - ox + 15, y - oy + 15)
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
		local contents = self.contents
		if #contents > 0 then
			for i = 1, #contents do
				contents[i]:_destroy()
			end
		end
		self:_destroy()
	end,

	pack = function(self)

		-- @todo
		-- pack the suitcase with various sized items
		-- and animals

		local padding = 15
		local buffer = 0.45
		local threshold = 0.3
		local resolution = 4
		local min = 1
		local max = 5

		local size = self.size
		local w, h = unpack(size)
		local l, r, t, b = 0, w, 0, h
		l = l + padding
		r = r - padding * 2
		t = t + padding
		b = b - padding * 2

		-- @todo some of these values should be determined by the suitcase type
		local stock = {
			[1] = {
				type = Animal,
				--stock = math.floor(max * math.random()),
				stock = 3,
			},
			[2] = {
				type = Item,
				stock = 0,
			}

		}

		-- these parameters should be passed or the content could be generated and then stuffed into the suitcase

		local contents = {}

		for _,entry in ipairs(stock) do
			for i = 1, entry.stock do


				local item = entry.type()
				item.parent = self
				item.positioning = 'relative'

				-- @todo
				-- items of the same type need to avoid overlapping

				item:compute()

				local bound = item.bound
				local il, ir, it, ib = unpack(bound.edges)

				local w = ir - il
				local h = ib - it

				local attempts = 50

				local placed
				while not placed do

					local fx = math.floor(math.random() * resolution) / (resolution - 1)
					local fy = math.floor(math.random() * resolution) / (resolution - 1)

					local pl = il + w
					local pr = il + r
					local pt = it + h
					local pb = it + b

					local x = l + pl + (pr - pl) * fx
					local y = t + pt + (pb - pt) * fx

					item.position[1] = x
					item.position[2] = y

					local allowed = true

					-- @todo reject objects that are taller than suitcase...
					-- @todo fix this....

					if allowed then
						for j,neighbor in ipairs(contents) do
							if neighbor._type == item._type then
								local sq = function(n) return math.pow(n, 2) end
								local nx, ny = unpack(neighbor.position)
								local distance = sq(x - nx) + sq(y - ny)
								local dimension = math.min(w, h) * buffer
								if distance < (dimension * dimension) then
									allowed = false
								end
							end
						end
					end

					if allowed then
						table.insert(contents, item)
						print('added')
						placed = true
						break
					else
						item:_destroy()
						attempts = attempts - 1
					end

					if attempts == 0 then
						placed = true
						break
					end
				end

			end
		end

		local animals = 0
		for i = 1, #contents do
			local item = contents[i]
			if item._type == 'animal' then
				animals = animals + 1
			end
		end

		self.contents = contents
		self.answer = animals

	end,
}