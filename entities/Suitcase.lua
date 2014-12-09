-- contains relatively positioned animals
-- based on a bunch of manually preset main components
-- and dispersed misc components

-- is created and moved by the suitcase manager

-- suitcase should have its own timer

Suitcase = class{
	init = function(self, difficulty)

		self._type = 'suitcase'
		self._debug = false

		-- get the size from a table

		local sizes = {
			{400, 350},
			{200, 350},
			{200, 260},
			{500, 290},
		}

		local index = 1 + math.floor(#sizes * math.random())

		local size = sizes[index]
		local w, h = unpack(size)

		local x = -w * 2 - 50
		local y = lg.getHeight() - 160

		local index = 1 + math.floor(#colors * math.random())
		local color = colors[index].color
		local shade = colors[index].shade

		self.color = color
		self.shade = shade


		self.position = {x, y, 1}
		self.size = {w, h}
		self.origin = {0, h}
		self.scale = {1, 1}
		self.difficulty = difficulty

		self:pack()

		self.solved = false
		self.missed = false

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


		lg.setLineWidth(8)
		if mode == 'default' then
			local color = self.color
			local shade = self.shade
			lg.setColor(color)
			lg.rectangle('fill', x - ox, y - oy, w * sx, h * sy)
			lg.setColor(shade)
			lg.rectangle('line', x - ox, y - oy, w * sx, h * sy)
		elseif mode == 'scanner' then
			lg.setColor(170, 170, 170, 100)
			lg.rectangle('line', x - ox, y - oy, w * sx, h * sy)
			local answer = self.answer
			lg.setColor(255, 255, 255)
			--fonts:draw('Inconsolata.otf', 28, answer, x - ox + 15, y - oy + 15)
		end

	end,

	bid = function(self, attempt)
		local answer = self.answer
		local correct = tonumber(attempt) == answer
		if correct then
			signal.emit('correct', tonumber(answer))
			self.solved = true
		end
		return correct
	end,

	destroy = function(self)

		local contents = self.contents
		if #contents > 0 then
			for i = 1, #contents do
				local item = contents[i]
				if not item.tossed then
					contents[i]:_destroy()
				end
			end
		end
		self:_destroy()
	end,

	check = function(self)

		local animals = self.animals
		local remaining = animals and #animals or 0
		for _,animal in ipairs(animals) do
			if animal.tossed then
				remaining = remaining - 1
			end
		end

		print(remaining .. ' animals left')

		return remaining == 0

	end,

	pack = function(self)

		-- @todo
		-- pack the suitcase with various sized items
		-- and animals

		local difficulty = self.difficulty

		local padding = 30
		local buffer = 0.45
		local threshold = 0.3
		local resolution = 4
		local min = 1
		local max = 5

		local size = self.size
		local scale = self.scale
		local w, h = unpack(size)
		local sx, sy = unpack(scale)
		w = w * sx
		h = h * sy
		local l, r, t, b = 0, w, 0, h
		l = l + padding
		r = r - padding * 2
		t = t + padding
		b = b - padding * 2

		-- @todo some of these values should be determined by the suitcase type
		-- @todo stock should go up with difficutly?
		local amount = 2 + math.floor(difficulty * math.random())
		local roll = math.random()
		if roll > 0.75 then
			amount = 0
		end

		local stock = {
			[1] = {
				type = Animal,
				--stock = math.floor(max * math.random()),
				stock = amount,
			},
			[2] = {
				type = Item,
				stock = 10,
			}

		}

		-- these parameters should be passed or the content could be generated and then stuffed into the suitcase

		local contents = {}

		for _,entry in ipairs(stock) do
			for i = 1, entry.stock do


				local item = entry.type(difficulty)
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
						local fudge = 1.4
						if (w > size[1] * fudge) or (h > size[2] * fudge) then
							allowed = false
						end
					end

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
						placed = true
						break
					else
						attempts = attempts - 1
					end

					if attempts == 0 then
						placed = true
						item:_destroy()
						break
					end
				end

			end
		end

		local counter = 0
		local animals = {}
		for i = 1, #contents do
			local item = contents[i]
			if item._type == 'animal' then
				counter = counter + 1
				table.insert(animals, item)
			end
		end

		self.contents = contents
		self.animals = animals
		self.answer = counter

	end,
}