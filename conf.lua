function love.conf(t)

	-- virtual console
	-- require('cupid')

	-- windows console
	t.console = true

	t.version = '0.9.1'
	t.window.title = 'ld31'
	t.window.icon = nil

	t.window.width = 1000
	t.window.height = 700
	
	t.window.vsync = true
	t.window.highdpi = true

end