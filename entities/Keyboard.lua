Keyboard = class{
	init = function(self)

		local legends = {
			'0',
			'1',
			'2',
			'3',
			'4',
			'5',
			'6',
			'7',
			'8',
			'9',
		}

		local keys = {}
		for _,legend in ipairs(legends) do
			local keycap = Keycap(legend)
			table.insert(keys, keycap)
		end

	end,

	update = function(self, dt)
	end,	
}