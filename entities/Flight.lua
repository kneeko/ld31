-- generates a series of suitcases based on parameters
-- feeds those suitcases to the suitcase manager

Flight = class{

	init = function(self)

		-- trigger a hud event SEA -> JFK
		-- set the scanner base/bezel label (?)
		-- generate suitcases for suitcase manager

		Notification('Incoming Flight')

		-- @todo
		-- add a variable delay for this

		--

		local delay = 0.2
		local f = function()
			local n = 10
			local suitcases = {}
			for i = 1, n do
				
				local suitcase = Suitcase()
				suitcase._active = false
				suitcase._visible = false
				table.insert(suitcases, suitcase)

			end

			-- pass to suitcase manager
			self.suitcases = suitcases

			local parent = self.parent
			local scene = parent._scene
			
			local manager = scene.suitcases
			local scanner = scene.scanner
			local conveyor = scanner.conveyor
			manager.suitcases = suitcases
			conveyor:resume()

			print('generated ' .. n .. ' suitcases')
		end

		self.callback = f
		self.delay = delay


	end,

	update = function(self, dt)

		local delay = self.delay

		if delay > 0 then
			self.delay = math.max(delay - dt, 0)
		end

		if self.delay == 0 then
			local callback = self.callback
			callback()
			self.delay = -1
		end

	end,

	complete = function(self)
	end,
	
}