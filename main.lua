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

	-- set camera for world
	camera:set()
	

	if mode == 1 then
		world:draw()
	end
	

	camera:unset()
	
	-- overlays
	--world:drawWeather()
	
	-- debug info
	util:drawConsole()
	
end

function love.update(dt)

	input:check(dt)
	
	if mode == 1 then
		world:run(dt)
	end
	

end

