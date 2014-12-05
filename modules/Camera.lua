Camera = class{
	init = function(self, n)
		-- position
		-- origin
		self.x = 0
		self.y = 0
		self.z = 1
		self.r = 0

		local n = n
		local p = 1 / n
		self.p = p
		self.n = n

		self.w = lg.getWidth() * p
		self.h = lg.getHeight()
	end,

	attach = function(self)
	
		local x, y, z = self.x, self.y, self.z
		local r = self.r
		local w = self.w
		local h = self.h
		local p = self.p
		local n = self.n

		lg.push()
		lg.scale(z)

		-- this doesn't handle rotation correctly
		local ox = w / (2 * z) + w*(n-1)*0.5
		local oy = h / (2 * z)

		-- rotate around center of viewport
		lg.translate(ox, oy)
		lg.rotate(r)

		-- draw at the camera position
		lg.translate(-x, -y)

	end,

	detach = function(self)
		lg.pop()
	end,

	set = function(self, x, y, z, r, origin)
		self.x = x or self.x
		self.y = y or self.y
		self.z = z or self.z
	end,

	zoom = function(self, z)
		self.z = z
	end,

	rotate = function(self, r)
		self.r = r or self.r
	end,

	project = function(self, ix, iy)

		-- todo make this handle rotation correctly

		local x, y, z = self.x, self.y, self.z
		local w, h = self.w, self.h
		local r = self.r

		local cos = math.cos(-r)
		local sin = math.sin(-r)

		-- its almost like this happens in the wrong order...

		local tx = (ix - w*0.5) / z
		local ty = (iy - h*0.5) / z

		--px = px*cos + py*sin
		--py = py*cos + px*sin

		local px = tx*cos + ty*sin
		local py = ty*cos + tx*sin

		px = px + x
		py = py + y

		return px, py
	end,

}