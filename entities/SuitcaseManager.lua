SuitcaseManager = class{
	init = function(self)

		local n = 100
		local suitcases = {}
		for i = 1, n do
			local suitcase = Suitcase()
			suitcase._active = false
			suitcase._visible = false
			table.insert(suitcases, suitcase)
		end

		self.suitcases = suitcases

		-- @todo
		-- delete suitcases after a while?
		-- once a suitcase has been answered I could start a timer

	end,

	pack = function(self, flight)
	end,

	pop = function(self)

		local suitcases = self.suitcases
		if #suitcases > 0 then

			-- get the top suitcase
			local suitcase = suitcases[#suitcases]

			-- enable update and draw methods in object manager
			suitcase._active = true
			suitcase._visible = true

			-- pop it from the list
			table.remove(suitcases)
			
			-- send it to the scanner
			return suitcase
		end

	end,
}