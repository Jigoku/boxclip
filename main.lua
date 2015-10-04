
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
	--love.window.setFullscreen(1)
	
	--love.graphics.setBackgroundColor(10,10,10,255)
	love.graphics.setBackgroundColor(10,10,15,255)
	

	world:init()

	player:init()
	world:loadMap(nil)

end

function love.draw()

	-- set camera for world
	camera:set()
	
		love.graphics.setColor(30,30,35,255)
		love.graphics.rectangle("fill", -50, world.groundLevel+player.h, 10000, 500)	
		love.graphics.setColor(50,50,50,255)
		love.graphics.rectangle("fill", -50, world.groundLevel+player.h, 10000, 2)
		
		structures:draw()
		pickups:draw()
		enemies:draw()
		player:draw()
		
		
		
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

