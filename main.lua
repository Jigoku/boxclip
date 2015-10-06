require("camera")
require("sound")
require("physics")
require("collision")
require("world")
require("util")
require("structures")
require("pickups")
require("enemies")
require("player")
require("input")




debug = 1
mode = 1

math.randomseed(os.time())
function love.load()
	
	world:init()

	player:init()
	world:loadMap(nil)

	groundLevel_tile = love.graphics.newImage("graphics/tiles/lava.png")
	groundLevel_tile:setWrap("repeat", "repeat")
	groundLevel_quad = love.graphics.newQuad( -50,world.groundLevel, 10000, 500, groundLevel_tile:getDimensions() )

end

function love.draw()

	-- draw title screen
	if mode == 0 then
		title:draw()
	end

	-- draw world
	if mode == 1 then
		world:draw()
	end
	
	-- debug info
	util:drawConsole()
	
end

function love.update(dt)

	-- process keyboard events
	input:check(dt)

	-- run title screen
	if mode == 0 then
		title:run(dt)
	end
	
	-- run world
	if mode == 1 then
		world:run(dt)
	end
	

end

