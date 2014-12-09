Prompt = class{
	init = function(self, string, subtitle, score, lifetime)

		-- incoming flight from JFK [flag]?


		-- Try Saving Animals
		-- press space to begin (flashing)

		-- Game Over
		-- SCORE
		-- press space to try again

		local x = lg.getWidth() * 0.5
		local y = lg.getHeight() * 0.5 + 10

		local position = {x, y, 1}
		local size = {0, 0}
		local scale = {1, 1}
		local origin = {0, 0}

		local score = score or ''

		self.position = position
		self.size = size
		self.scale = scale
		self.origin = origin

		self.font = font

		local header = Text(string, 48)
		self.header = header

		local help = Text(subtitle, 32)
		self.help = help

		local score = Text(score, 72)
		self.score = score

		self.timer = 0

		self.entry = 0
		self.entering = true

		self.exit = 0
		self.exiting = false

		self.duration = 1.2
		self.opacity = 0

		self.lifetime = lifetime
		self.sprite = airplane

		manager:register(self)

	end,

	update = function(self, dt)

		self.timer = self.timer + dt

		local opacity

		local entering = self.entering
		if entering then

			local entry = self.entry
			local duration = self.duration * 0.7
			self.entry = math.min(entry + dt, duration)

			local progress = entry / duration
			opacity = opacity and opacity * progress or progress

			local oy = 20 - 20 * easing.outCubic(progress, 0, 1, 1)
			local origin = self.origin
			origin[2] = oy



		end

		local exiting = self.exiting
		if exiting then

			local duration = self.duration * 0.2
			local exit = self.exit
			self.exit = math.min(exit + dt, duration)

			local progress = math.abs(1 - (exit / duration))

			opacity = opacity and opacity * progress or progress
			self.opacity = opacity

			if exit == duration then
				self:_destroy()
			end
		end


		self.opacity = opacity or self.opacity

		local lifetime = self.lifetime
		if lifetime and (not exiting) then
			self.lifetime = math.max(lifetime - dt, 0)
			if lifetime == 0 then
				self.exiting = true
			end
		end


	end,

	draw = function(self, mode, ...)

		-- draw the text
		local position = ...
		local x, y = unpack(position)

		local origin = self.origin
		local ox, oy = unpack(origin)

		x = x + ox
		y = y + oy

		if mode == 'scanner' then

			local opacity = self.opacity

			local scale = self.scale
			local sx, sy = unpack(scale)

			lg.setColor(255, 255, 255, 255 * opacity)

			local header = self.header
			header:draw(x, y - 20, scale)

			lg.setColor(220, 255, 220, 255 * opacity)

			local score = self.score
			score:draw(x, y - 80, scale)

			local a = 200 - 40 * math.sin(self.timer * math.pi)
			local offset = 4 * math.sin(self.timer * math.pi)

			lg.setColor(255, 255, 255, a * opacity)

			local help = self.help
			help:draw(x, y + 40 + offset, scale)

			local lifetime = self.lifetime
			if lifetime then
				lg.setColor(255, 255, 255, 200 * opacity)
				lg.draw(airplane, x - 78*0.35, y - 100, 0, 0.35, 0.35)
			end



		end

	end,
}