
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



function love.load()
	math.randomseed(os.time())
	cwd = love.filesystem.getWorkingDirectory( )
	icon = love.image.newImageData( "graphics/enemies/walker.png")
	love.window.setIcon( icon )
	love.mouse.setVisible( false )
	
	world:init()
	player:init()
	
	world:loadMap("maps/test.map")
end

function love.draw()
	world:draw()
	
	-- draw world
	if console then
		-- debug info
		util:drawConsole()
	end
	
end

function love.update(dt)

	-- process keyboard events
	input:check(dt)
	
	world:timer()
	physics:world(dt)
	physics:player(dt)
	physics:pickups(dt)
	physics:enemies(dt)
	collision:checkWorld(dt)
	player:follow()
	
	if editing then editor:run(dt) end
	
end

