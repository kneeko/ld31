Rumbler = class{
	init = function(self)

		local amplitude = 100
		local throttle = 0

		self.timer = 0
		self.amplitude = amplitude
		self.delta = 0
		self.period = math.pi * 2 * (4)
		self.speed = 1

		self.rumble = 0
		self.throttle = 0
		self.previous = 0

		signal.register('shake', function() self:shake() end)

		manager:register(self)

	end,

	update = function(self, dt)

		local timer = self.timer
		self.timer = timer + dt

		local rumble = self.rumble
		self.rumble = math.max(rumble - dt, 0)

		local throttle = self.throttle
		if rumble > 0 then
			local progress = math.abs(1 - (rumble / 0.6))
			progress = math.sin(progress * math.pi * 2 / 0.6) * (rumble / 0.6)
			local amplitude = 100 + 1200 * progress
			self.amplitude = amplitude
		end

		-- set a global that the viewports use
		local amplitude = self.amplitude * throttle
		local period = self.period
		local speed = self.speed

		local oscilation = math.sin(timer * period) * amplitude
		local previous = self.previous
		self.previous = oscilation

		local delta = oscilation - previous

		shake = delta * dt



	end,

	set = function(self, throttle, speed)
	end,

	shake = function(self)

		self.rumble = 0.6

	end,
}