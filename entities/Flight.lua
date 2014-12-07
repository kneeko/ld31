-- generates a series of suitcases based on parameters
-- feeds those suitcases to the suitcase manager

Flight = class{

	init = function(self)

		-- trigger a hud event SEA -> JFK
		-- set the scanner base/bezel label (?)
		-- generate suitcases for suitcase manager

		--
		local n = 5
		local suitcases = {}
		for i = 1, n do
			
			local suitcase = Suitcase()
			suitcase._active = false
			suitcase._visible = false
			table.insert(suitcases, suitcase)

		end

		-- pass to suitcase manager
		self.suitcases = suitcases

		print('generated ' .. n .. ' suitcases')

	end,

	update = function(self, dt)
	end,

	complete = function(self)
	end,
	
}