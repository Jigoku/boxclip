name = "Boxclip"
author = "ricky thomson"
version = 0.2
build = "-alpha"
print (name .. " " .. version .. build .. " by " .. author)
default_width = 1024
default_height = 768

function love.conf(t)
	t.identity = "boxclip"
	t.version = "0.10.1"
	t.window.title = name .. " " .. version
	t.window.width = default_width
	t.window.height = default_height
	t.window.minwidth = 800
	t.window.minheight = 600
	t.modules.joystick = false
	t.modules.physics = false
	t.modules.touch = false
	t.modules.video = false 
	t.window.msaa = 0
	t.window.display = 1
	t.window.resizable = false
	t.window.vsync = true
	t.window.fullscreen = false
	t.window.fullscreentype = "exclusive"
	
end
