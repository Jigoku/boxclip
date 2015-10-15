
--[[
	Boxclip 2d engine by ricky thomson

	CONTROLS
	left         : a / leftarrow
	right        : d / rightarrow
	jump         : space
	suicide      : b
	
	fullscreen   : F5
	editor mode  : F1
	console      : `
	quit         : esc
	camera scale : z
--]]

require("camera")
require("sound")
require("physics")
require("collision")
require("world")
require("util")
require("player")
require("input")
require("editor")
require("entities/crates")
require("entities/platforms")
require("entities/checkpoints")
require("entities/pickups")
require("entities/enemies")


--mode = "title"
--mode = "game"
mode = "title"

function love.load()
	math.randomseed(os.time())
	cwd = love.filesystem.getWorkingDirectory( )
	icon = love.image.newImageData( "graphics/enemies/walker.png")
	love.window.setIcon( icon )
	love.mouse.setVisible( false )
	

end

function love.draw()
	
	if mode == "title" then
		love.graphics.setBackgroundColor(0,0,0,255)
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("Press 1 for mode 'game'",100,100)
		love.graphics.print("(everything triggers on collision)",140,120)
		love.graphics.print("Press 2 for mode 'editing'",100,150)
		love.graphics.print("(some entites will not trigger on collision for editing purposes)",140,170)
	else
		world:draw()
	end
	-- draw world
	if console then
		-- debug info
		util:drawConsole()
	end
	
end

function love.update(dt)

	-- process keyboard events
	input:checkkeys(dt)

	if not (mode == "title") then
		world:timer()
		physics:world(dt)
		physics:player(dt)
		physics:pickups(dt)
		physics:enemies(dt)
		collision:checkWorld(dt)
		player:follow()
		world:run(dt)
	else
		love.audio.stop()
	end

end

