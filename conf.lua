name = "platform"
version = 0.1

function love.conf(t)
	t.version = "0.9.2"
	t.window.title = name .. " " .. version
	t.window.width = 1024
	t.window.height = 768
	t.modules.joystick = false
	t.modules.physics = false
	t.window.fsaa = 0
	t.window.resizable = true
	t.window.vsync = true
	t.window.fullscreen = false
end
