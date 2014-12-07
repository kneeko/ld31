function love.load()

	-- set a background before loading dependencies
	local bg = {113, 183, 193}
	love.graphics.setBackgroundColor(bg)
	love.graphics.clear()
	love.graphics.present()

	require('dependencies')()

	fonts = FontManager()
	input = InputManager()

	manager = ObjectManager()
	viewport = ViewportManager(manager)

	scene = Scene()

	-- input is passed through the viewport manager
	-- so that it can be projected into world space
	input:register(viewport, {'input', 'keyboard'})
	input:register(scene, {'keyboard'})

	sprites = {
		animals = {
			lg.newImage('assets/images/marlin.png'),
			lg.newImage('assets/images/rabbit.png'),
			lg.newImage('assets/images/gazelle.png'),
			lg.newImage('assets/images/duck.png'),
			lg.newImage('assets/images/octopus.png'),
		}
	}

end

function love.update(dt)
	-- inputs should always be updated first
	input:update(dt)
	scene:update(dt)
	manager:update(dt)
	-- prepares the projections for drawing
	viewport:update(dt)
end

function love.draw()
	-- everything is drawn through the viewport manager
	viewport:draw()
	scene:draw()
end

function love.mousepressed(x, y, button)
	if not love.touch then
		input:mousepressed(x, y, button)
	end
end

function love.mousereleased(x, y, button)
	if not love.touch then
		input:mousereleased(x, y, button)
	end
end

function love.touchpressed(id, x, y, pressure)
	input:touchpressed(id, x, y, pressure)
end

function love.touchreleased(id, x, y, pressure)
	input:touchreleased(id, x, y, pressure)
end

function love.keypressed(key, code)
	if key == 'escape' then
		le.quit()
	end

	if key == 'r' then
		--test:destroy()
		if not test then
			test = Suitcase()
			test.position[1] = 550
		else
			test:destroy()
			test = Suitcase()
			test.position[1] = 550
		end
	end

	input:keypressed(key, code)
end

function love.keyreleased(key, code)
	input:keyreleased(key, code)
end

function love.resize(w, h)
	viewport:resize()
end

function love.threaderror(thread, message)
	print(message)
end
