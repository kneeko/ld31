function love.load()

	-- set a background before loading dependencies
	local bg = {113, 183, 193}
	love.graphics.setBackgroundColor(bg)
	love.graphics.clear()
	love.graphics.present()

	require('dependencies')()

	math.randomseed(os.time())

	fonts = FontManager()
	input = InputManager()

	manager = ObjectManager()
	viewport = ViewportManager(manager)

	scene = Scene()

	-- input is passed through the viewport manager
	-- so that it can be projected into world space
	input:register(viewport, {'input', 'keyboard'})
	input:register(scene, {'keyboard'})

	-- @todo
	-- scale these images to a more reasonable size
	-- spritebatching

	airplane = lg.newImage('assets/images/airplane.png')

	sprites = {
		default = {
			animals = {
				lg.newImage('assets/images/rabbit-color.png'),
				lg.newImage('assets/images/duck-color.png'),
				lg.newImage('assets/images/octopus-color.png'),
				lg.newImage('assets/images/gazelle-color.png'),
				lg.newImage('assets/images/marlin-color.png'),
			},
			misc = {
				lg.newImage('assets/images/brush-color.png'),
				lg.newImage('assets/images/camera-color.png'),
				lg.newImage('assets/images/charger-color.png'),
				lg.newImage('assets/images/flipflops-color.png'),
				lg.newImage('assets/images/headphones-color.png'),
				lg.newImage('assets/images/laptop-color.png'),
				lg.newImage('assets/images/notebook-color.png'),
				lg.newImage('assets/images/shirts-color.png'),
				lg.newImage('assets/images/thermos-color.png'),
			}
		},
		scanner = {
			animals = {
				lg.newImage('assets/images/rabbit.png'),
				lg.newImage('assets/images/duck.png'),
				lg.newImage('assets/images/octopus.png'),
				lg.newImage('assets/images/gazelle.png'),
				lg.newImage('assets/images/marlin.png'),
			},
			misc = {
				lg.newImage('assets/images/brush.png'),
				lg.newImage('assets/images/camera.png'),
				lg.newImage('assets/images/charger.png'),
				lg.newImage('assets/images/flipflops.png'),
				lg.newImage('assets/images/headphones.png'),
				lg.newImage('assets/images/laptop.png'),
				lg.newImage('assets/images/notebook.png'),
				lg.newImage('assets/images/shirts.png'),
				lg.newImage('assets/images/thermos.png'),
			}
		},
	}

	colors = {
		{
			color = {238, 85, 85},
			shade = {228, 75, 75},
		},
		{
			color = {83, 117, 76},
			shade = {97, 127, 91},
		},
		{
			color = {53, 58, 61},
			shade = {34, 37, 39},
		},
		{
			color = {142, 74, 69},
			shade = {120, 66, 62},
		},
		{
			color = {72, 62, 120},
			shade = {67, 59, 106},
		},
		{
			color = {72, 62, 120},
			shade = {67, 59, 106},
		},
	}

end


			-- @todo
			-- handle numpad
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
