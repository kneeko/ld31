ObjectManager = class{
	init = function(self)

		local available = {}
		local objects = {}
		local sorter = ObjectSorter(objects)
		local renderer = ObjectRenderer(objects, sorter)
		local identifier = Identifier()

		self.available = available
		self.objects = objects
		self.sorter = sorter
		self.renderer = renderer
		self.index = {}
		self._identifier = identifier

		print('ObjectManager init\'d with identifier ' .. identifier:get())

	end,

	update = function(self, dt)

		local objects = self.objects
		local sorter = self.sorter
		local heap = self:get()
		for i = 1, #heap do
			local key = heap[i]
			local object = objects[key]
			if object._active then

				-- update the game object
				if object.update then
					object:update(dt)
				end

				if object._listening then
					object:verify()
				end

				-- @todo figure out when to move this object in the sorter
				--sorter:move(key)

			end

			-- @todo allow this to be cached indefinitely
			-- cache the bounds for this frame
			-- @todo change this method name
			if object.compute then
				object:compute()
			end

		end

	end,

	prepare = function(self, identifier, camera, viewport)
		-- generate a list of visible scene objects and cache their projection
		local renderer = self.renderer
		renderer:prepare(identifier, camera, viewport)

	end,

	flush = function(self, identifier)
		-- invalidate projection caches for a specific identifier
		local objects = self.objects
		local heap = self:get()
		for i = 1, #heap do
			local key = heap[i]
			local object = objects[key]
			object.projections[identifier] = nil
		end
		local renderer = self.renderer
		renderer:flush(identifier)

		print('Flushed cached projections and draw queues for viewport with id: ' .. identifier)

	end,

	-- called by the viewport manager
	draw = function(self, ...)
		local renderer = self.renderer
		renderer:draw(...)
	end,

	callback = function(self, method, ...)

		local index = self.index
		local objects = self.objects
		local keys = index[method]
		if keys then
			for _,key in ipairs(keys) do
				local object = objects[key]
				object[method](object, ...)
			end
		end

	end,

	register = function(self, object)

		local identifier = self._identifier:get()

		if not object then
			local status = ('ObjectManager (%s) was passed an invalid object for registration.'):format(identifier)
			print(status)
			return
		end

		local objects = self.objects
		local sorter = self.sorter
		local available = self.available
		local transmitter = self.transmitter
		local heap = self:get() or {}

		local key
		for i,suggestion in ipairs(available) do
			local suggestion = available[i]
			table.remove(available, i)
			local n = heap[#heap]
			if n then
				if suggestion < heap[#heap] then
					key = suggestion
					break
				end
			end
		end

		-- if there was nothing available then just add a new key
		key = key or #objects + 1

		-- store the main reference to the object
		objects[key] = object

		-- give the object a ref to its manager
		object._manager = self

		-- copy fallback values from entity
		object:include(Entity:init(key, identifier))
		object:include(Entity)

		-- include any requested classes
		local includes = object.includes or {}
		for _,include in ipairs(includes) do
			object:include(include:init())
			object:include(include)
		end

		-- index any requested callbacks
		-- are these ever going to be something apart from input?
		-- if so, I could skip this and just register them with that!
		-- although if I want to do some processing specific to the object manager
		-- this lets me filter them through that
		local index = self.index
		local callbacks = object.callbacks or {}
		for _,callback in ipairs(callbacks) do
			index[callback] = index[callback] or {}
			index[callback][#index[callback] + 1] = key
		end

		sorter:insert(key)

		return key
	end,

	release = function(self, key)

		local objects = self.objects
		local available = self.available
		local sorter = self.sorter
		local index = self.index
		local heap = self:get()
		local object = objects[key]
		if type(object) == 'table' then
			local callbacks = object.callbacks or {}
			for _,callback in ipairs(callbacks) do
				local keys = index[callback] or {}
				for i,v in ipairs(keys) do
					if v == key then
						table.remove(keys, i)
					end 
				end
			end
			sorter:remove(key)
			available[#available + 1] = key
			objects[key] = nil
			-- does this actually remove all other references?
			object = nil
		end
		
	end,

	pop = function(self)
		local objects = self.objects
		local heap = self:get()
		local i = math.ceil(#heap * math.random())
		local key = heap[i]
		if key then
			self:release(key)
		end
	end,

	get = function(self)
		local objects = self.objects
		local heap = {}
		for key,object in pairs(objects) do
			heap[#heap + 1] = key
		end
		return heap
	end,

	propogate = function(self, method, ...)
		local objects = self.objects
		local index = self.index
		if index[method] then
			for _,key in ipairs(index[method]) do
				local object = objects[key]
				if object then
					if object[method] then
						object[method](object, ...)
					else
						local identifier = self._identifier:get()
						local err = string.format('[%s] object %s with type "%s" has not defined callback %s.',
							identifier, object._key, object._type, method)
						print(err)
					end
				else
					local identifier = self._identifier:get()
					local err = string.format('[%s] object key %s points to nil while propogating method %s.',
						identifier, key, mode)
					print(err)
				end
			end
		end
	end,

	inputpressed = function(self, ...)
		--local identifier, x, y, button = ...
		-- how do I keep this viewport agnostic?
		self:propogate('inputpressed', ...)
	end,

	inputreleased = function(self, ...)
		--local x, y, button = ...
		-- how do I keep this viewport agnostic?
		self:propogate('inputreleased', ...)
	end,

}