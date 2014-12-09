local set = love.graphics.setFont

FontManager = class{
	init = function(self, directory)
		self.directory = directory or 'assets/fonts/'
		self.fonts = {}
	end,

	add = function(self, name, size, scaling)

		if not name then
			error('Invalid name when adding a font.')
			return
		end

		-- load a font
		local fonts = self.fonts
		local directory = self.directory
		local path = directory .. name

		local name = name
		local scaling = scaling or 1
		local size = size and size * scaling or 0
		local filter = 'linear'

		local font = fonts[name] or Font(self, name, path, filter)
		fonts[name] = font

		local instance = font:load(size)

		return instance

	end,

	draw = function(self, name, size, string, ...)
		local scaling = self.scaling or 1
		local size = size * scaling
		local instance = self:add(name, size)
		instance:draw(string, ...)
	end,

	batch = function(self, pool)
		for _,args in ipairs(pool) do
			local name, size, scaling = unpack(args)
			self:add(name, size, scaling)
		end
	end,
}

Font = class{

	init = function(self, manager, name, path, filter)

		-- load a font
		self.manager = manager
		self.name = name
		self.path = path
		self.filter = filter
		self.stack = {}
		self.instances = {}

	end,

	draw = function(self, size, string, ...)

		self:setFont(size)
		lg.print(string, ...)

	end,

	getWidth = function(self, size, string)
		local font = self:getFont(size)
		local width = font:getWidth(string)
		return width
	end,

	getHeight = function(self, size, string)
		local font = self:getFont(size)
		local height = font:getHeight(string)
		return height
	end,

	getFont = function(self, size)
		local stack = self.stack
		local font = stack[size]
		return font
	end,

	setFont = function(self, size)
		local font = self:getFont(size)
		lg.setFont(font)
	end,

	load = function(self, size)

		local stack = self.stack
		if not stack[size] then

			local path = self.path
			local font = lg.newFont(path, size)

			-- set scaling filter
			local filter = self.filter
			font:setFilter(filter, filter)

			-- add this size to the stack
			stack[size] = font

			-- preload characters
			local numbers = '0123456789'
			local lowercase = 'abcdefghijklmnopqrstuvwxyz'
			local uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
			local symbols = '+!.?'
			local chars = numbers .. lowercase .. uppercase .. symbols
			local _, _ = self:getWidth(size, chars), self:getHeight(size, chars)

		end

		-- create a new instance if one doesn't already exist
		local instances = self.instances
		local instance = instances[size] or FontInstance(self, size)
		instances[size] = instance
		
		-- return the instance to the caller, who can now use it to print
		return instance

	end,
}

FontInstance = class{
	init = function(self, font, size)

		self.font = font
		self.size = size
		self.cache = {
			width = {
				count = 0,
				cap = 128,
				pool = {},
				method = 'getWidth',
			},
			height = {
				count = 0,
				cap = 128,
				pool = {},
				method = 'getHeight'
			},
		}

	end,

	draw = function(self, string, ...)
		local size = self.size
		self.font:draw(size, string, ...)
	end,

	set = function(self)
		local size = self.size
		self.font:setFont(size)
	end,

	getWidth = function(self, string)
		return self:getDimension('width', string)
	end,

	getHeight = function(self, string)
		return self:getDimension('height', string)
	end,

	getDimension = function(self, dimension, string)

		local string = tostring(string)
		local cache = self.cache[dimension]

		-- if the cache misses, compute the dimension and store it
		if not cache.pool[string] then

			local font = self.font
			local size = self.size

			-- add the dimension to the appropriate cache
			cache.pool[string] = font[cache.method](font, size, string)
			cache.count = cache.count + 1

			-- if cache hits its limit, remove anything but the one we just added
			if cache.count > cache.cap then
				for key,val in pairs(cache.pool) do
					if key ~= string then
						cache.pool[key] = nil
						cache.count = cache.count - 1
						break
					end
				end
			end

		end

		local dimension = cache.pool[string]

		return dimension
	end,

}