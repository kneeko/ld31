--[[

what method do I want to use for this?
the easiest is probably a bunch of pieces that are slid around?


a bunch of strips of lines probably

a child of the 'base'

]]--


Belt = class{
	init = function(self, from, to)

		local w = to - from
		local h = 5

		local stipple = 10


		local size = {w, h}
		local strips = {}

		local amount = math.ceil(w / (stipple * 0.5))

		

		self.strips = strips
		self.size = size

	end,

	update = function(self, dt)


	end,

	move = function(self)
	end,

	draw = function(self, mode, ...)
	end,

	add = function(self)
	end,

	remove = function(self)
	end,
}