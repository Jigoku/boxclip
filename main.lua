
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
	

		
		structures:draw()
		pickups:draw()
		enemies:draw()
		player:draw()
			
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(groundLevel_tile, groundLevel_quad, -50,world.groundLevel)

	camera:unset()
	
	-- overlays
	--world:drawWeather()
	
	-- debug info
	util:drawConsole()
	
end

function love.update(dt)

	if dt < 1/60 then
		love.timer.sleep(1/60 - dt)
	end

	input:check(dt)
	
	physics:world(dt)
	physics:pickups(dt)
	physics:enemies(dt)
	physics:player(player, dt)
	
	collision:checkWorld(dt)
	
	camera:setScale(1,1)
	player:follow(1)

end

