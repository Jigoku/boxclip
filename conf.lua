function love.conf(t)
	t.version = "0.9.2"
	t.window.title = "Platform 0.1"
	t.window.width = 800
    t.window.height = 600
    t.modules.joystick = false
    t.modules.physics = false
    t.window.fsaa = 2
    t.window.resizable = true
    t.window.vsync = true
    t.window.fullscreen = false
end
