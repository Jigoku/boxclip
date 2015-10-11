
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
require("crates")
require("platforms")
require("checkpoints")
require("pickups")
require("enemies")
require("player")
require("input")
require("editor")


math.randomseed(os.time())
function love.load()
	love.mouse.setVisible( false )
	world:init()
	player:init()
	world:loadMap("./maps/test.map")

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
	
	world:run(dt)
	
	if editing then
		editor:run(dt)
	end
	

end

