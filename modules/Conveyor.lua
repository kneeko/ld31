-- accepts 'move' deltas
-- and shifts a belt and 


-- accepts suitcases
-- accepts a pause command
-- accepts a resume command

Conveyor = class{
	init = function(self)

		local queue = {}
		self.queue = queue
		self.timer = 0

		self.speed = 0
		self.throttle = 0
		self.acceleration = 2
		self.moving = false
		self.aborting = falase
		self.target = 0
		self.threshold = {300, 300}

		-- @todo
		-- some kind of step/distance bucket
		-- for placing suitcases into
		-- and not creating duplicates

		-- keeps track of how far this conveyor has traveled
		self.traveled = 0
		self.upcoming = 0
		self.step = 50

		-- this value will depend on the size of the largest suitcase and the screen width
		self.max = lg.getWidth() * (1 + 0.5)
		self.limit = lg.getWidth() * 0.8

		local rumbler = Rumbler()
		self.rumbler = rumbler

		local grind = la.newSource('assets/audio/grinding.mp3', 'static')
		grind:setVolume(0)
		grind:setLooping(true)
		grind:setPitch(0.7 + self.throttle)
		grind:play()

		self.grind = grind

	end,

	update = function(self, dt)

		-- @temp
		self.timer = self.timer + dt

		local speed = self.speed
		local moving = self.moving
		local target = self.target
		local throttle = self.throttle
		local acceleration = self.acceleration
		local flushing = self.flushing

		if flushing and throttle == 0 then
			self.moving = false
		end

		local slowed = self.slowed
		if moving and slowed and (not flushing) then
			local rate = 0.3
			if throttle > rate then
				self.throttle = math.max(throttle - dt * acceleration, rate)
			else
				self.throttle = math.min(throttle + dt * acceleration, rate)
			end
		elseif moving and (not flushing) then
			self.throttle = math.min(throttle + dt * acceleration, 1)
		else
			self.throttle = math.max(throttle - dt * acceleration, 0)
		end

		local rumbler = self.rumbler
		rumbler.throttle = throttle

		local grind = self.grind
		grind:setPitch(0.7 + self.throttle + 0.3 * math.min(speed / 700, 1))
		grind:setVolume(self.throttle * 0.3)

		local dx
		local throttle = self.throttle
		if moving then
			dx = speed * dt
			if target > 0 then
				local tx = target * dt * 3
				self.target = target - tx
				dx = dx + tx
			end
		else
			dx = target * dt * 3
			-- remove the delta from the target
			self.target = target - dx
		end

		-- throttle when moving for smooth acceleration
		-- i'd like to apply this to the target switching as well
		-- but i'm not sure how
		if moving and dx then
			dx = dx * throttle
		end

		local flushing = self.flushing
		if flushing then
			dx = dx * throttle
		end

		-- move stuff around
		local aborting = self.aborting
		local active = self.active
		local queue = self.queue
		local max = self.max
		local limit = self.limit
		for i,suitcase in ipairs(queue) do
			local position = suitcase.position
			position[1] = position[1] + dx
			if position[1] > limit then
				if (not suitcase.missed) and (not suitcase.solved) then
					-- only if active
					if active and (not aborting) then
						local solved = suitcase:check()
						if solved then
							suitcase.solved = true
						else
							suitcase.missed = true
							signal.emit('wrong')

							boo:play()

							-- add popup
							local popup = Popup('-1 life')
							popup.position[1] = lg.getWidth() * 0.5
							popup.position[2] = lg.getHeight() * 0.5
							popup.velocity[2] = -50


						end
					end
				end
			end
			if position[1] > max then
				suitcase:destroy()
				table.remove(queue, i)
			end
		end

		-- move axels
		-- this should belong in the bezel
		local scanner = self.scanner
		local bezel = scanner.bezel
		local axles = bezel.axles
		for _,axle in ipairs(axles) do
			axle:rotate(dx)
		end

		-- move belt

		-- add new suitcases based on distance
		local traveled = self.traveled
		local upcoming = self.upcoming
		local step = self.step

		-- distance the conveyor has moved since last reset
		self.traveled = traveled + dx

		-- if met, add a new suitcase
		if self.traveled >= upcoming then
			local scanner = self.scanner
			scanner:proceed()
		end

		local queue = self.queue
		if #queue == 0 and moving then
			if active then
				self:flush()
				signal.emit('completed')
			end
		end

		-- if a suitcase is being scanned
		-- set the self.scanner:scan(suitcase)

	end,

	draw = function(self, mode, ...)
		-- belt and axle will be the moving parts
		-- this is probably for debug
		local moving = self.moving
		local s = ("%s, %s, %s"):format(tostring(moving), self.traveled, self.throttle)
		lg.print(s, 15, 15)

	end,

	pause = function(self)
		-- pause the queue
		-- and then move to the nearest suitcase



		local nearest, selected = self:nearest()
		if nearest and selected then

			self.target = nearest
				
			-- tell the scanner to pass input to this suitcase
			local scanner = self.scanner
			scanner:scan(selected)

			self.moving = false

			-- unpause the timer
			-- set the value to ... what?

		end

	end,

	flush = function(self)
		print('flushing conveyor')
		-- this seems dangerous
		-- and is probably the source of the other problem...
		self.traveled = 0
		self.upcoming = 0
		self.flushing = true
		self.active = false
	end,

	abort = function(self)

		print('aborting conveyor')
		self.moving = true
		self.flushing = false
		self.active = true
		self.aborting = true
		--self.aborting = true

		local scanner = self.scanner
		scanner.scanning = nil
	end,

	-- @todo
	-- accept some arguments to make this more general
	nearest = function(self)

		local nearest, selected
		local queue = self.queue
		local threshold = self.threshold
		local middle = lg.getWidth()*0.5

		for i,suitcase in ipairs(queue) do

			-- @todo account for ox and scale
			-- i could have a function in the suitcase that asks
			-- how near it is? hmmm doesn't really make sense
			local x, _, _ = unpack(suitcase.position)
			local eligible = not suitcase.solved
			if eligible then
				local distance = middle - x
				if nearest then
					local nearer = math.abs(nearest) > math.abs(distance)
					nearest = nearer and distance or nearest
				else
					nearest = distance
				end

				if nearest == distance then
					selected = suitcase
				end
			end
		end

		if nearest then
			local inbound
			-- lower threshold if the suitcase has already passed the midpoint
			if nearest < 0 then
				inbound = math.abs(nearest) < threshold[1]
			else
				inbound = math.abs(nearest) < threshold[2]
			end
			if inbound then
				return nearest, selected
			end
		end


	end,

	resume = function(self)

		print('resuming the conveyor')

		-- resume motion
		self.moving = true
		self.flushing = false
		self.active = true
		self.aborting = false

		-- clear the centering target

		-- remove the selected object from the scanner input
		local scanner = self.scanner
		scanner.scanning = nil
		scanner.stopwatch:hide()

	end,

	toggle = function(self)
		local moving = self.moving
		if moving then
			self:pause()
		else
			self:resume()
		end
	end,

	process = function(self, suitcase)

		local flushing = self.flushing
		local aborting = self.aborting
		if (not flushing) and (not aborting) then

			-- add a suitcase to the queue
			local queue = self.queue
			table.insert(queue, suitcase)

			local size = suitcase.size
			local w, h = unpack(size)

			local upcoming = self.upcoming
			local step = self.step

			self.upcoming = upcoming + step + w * 2

			print('processing suitcase ' .. suitcase._key)

			-- @todo
			-- after a certain number in the queue
			-- we can pretty darn sure these are no longer visible

			-- this won't work for distance based stuff
			-- i need to remove them based on distance...

		end
	end,
}