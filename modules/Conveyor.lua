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

		self.speed = 300
		self.throttle = 1
		self.acceleration = 2
		self.moving = true
		self.target = 0
		self.threshold = {300, 300}


		-- @todo
		-- some kind of step/distance bucket
		-- for placing suitcases into
		-- and not creating duplicates

		-- keeps track of how far this conveyor has traveled
		self.traveled = 0
		self.upcoming = 0
		self.step = 500

	end,

	update = function(self, dt)

		-- @temp
		self.timer = self.timer + dt

		local speed = self.speed
		local moving = self.moving
		local target = self.target
		local throttle = self.throttle
		local acceleration = self.acceleration

		if moving then
			self.throttle = math.min(throttle + dt * acceleration, 1)
		else
			self.throttle = math.max(throttle - dt * acceleration, 0)
		end

		local dx
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
		local throttle = self.throttle
		if moving and dx then
			dx = dx * throttle
		end

		-- move stuff around
		local queue = self.queue
		for _,suitcase in ipairs(queue) do
			local position = suitcase.position
			position[1] = position[1] + dx
		end

		-- add new suitcases based on distance
		local traveled = self.traveled
		local upcoming = self.upcoming
		local step = self.step

		-- distance the conveyor has moved since last reset
		self.traveled = traveled + dx

		if self.traveled >= upcoming then
			local scanner = self.scanner
			scanner:proceed()
		end





		-- if a suitcase is being scanned
		-- set the self.scanner:scan(suitcase)

	end,

	draw = function(self, mode, ...)
		-- belt and axle will be the moving parts
		-- this is probably for debug
		local moving = self.moving
		local s = ("%s, %s"):format(tostring(moving), self.traveled)
		lg.print(s, 15, 15)

	end,

	pause = function(self)
		-- pause the queue
		-- and then move to the nearest suitcase

		-- figure out where we need to ease to

		-- shiiit... do i need to know viewport ids for this?....
		local queue = self.queue
		local threshold = self.threshold

		local nearest, selected
		local middle = lg.getWidth()*0.5
		
		for i,suitcase in ipairs(queue) do

			-- @todo account for ox and scale
			-- i could have a function in the suitcase that asks
			-- how near it is? hmmm doesn't really make sense
			local x, _, _ = unpack(suitcase.position)
			local eligible = suitcase.answer ~= 'correct!'
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

		-- nearest is signed
		-- since we will use a different threshold for that

		if nearest then
			local inbound
			-- lower threshold if the suitcase has already passed the midpoint
			if nearest < 0 then
				inbound = math.abs(nearest) < threshold[1]
			else
				inbound = math.abs(nearest) < threshold[2]
			end
			if inbound then
				self.target = nearest
				
				-- tell the scanner to pass input to this suitcase
				local scanner = self.scanner
				scanner:scan(selected)

				self.moving = false
			end
		end

	end,

	resume = function(self)

		-- resume motion
		self.moving = true

		-- clear the centering target

		-- remove the selected object from the scanner input
		local scanner = self.scanner
		scanner:clear()

	end,

	toggle = function(self)
		print('toggling')
		local moving = self.moving
		if moving then
			self:pause()
		else
			self:resume()
		end
	end,

	process = function(self, suitcase)

		-- add a suitcase to the queue
		local queue = self.queue
		table.insert(queue, suitcase)

		local upcoming = self.upcoming
		local step = self.step

		self.upcoming = upcoming + step

	end,
}