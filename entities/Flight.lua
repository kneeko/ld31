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

		local delay = 0.5
		local f = function()

			local parent = self.parent
			local difficulty = parent.difficulty
			local scene = parent._scene

			local speed = 550 + 50 * difficulty

			local scanner = scene.scanner
			local conveyor = scanner.conveyor
			conveyor.speed = speed

			local n = 8
			local suitcases = {}
			for i = 1, n do
				
				local suitcase = Suitcase(difficulty)
				suitcase._active = false
				suitcase._visible = false
				table.insert(suitcases, suitcase)

			end

			-- pass to suitcase manager
			self.suitcases = suitcases

			
			local manager = scene.suitcases
			local scanner = scene.scanner

			scanner:start()

			local conveyor = scanner.conveyor
			manager.suitcases = suitcases
			conveyor:resume()

			print('generated ' .. n .. ' suitcases')

			-- @todo
			-- call destroy on the manager?

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