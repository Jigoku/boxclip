
require("camera")
require("sound")
require("physics")
require("collision")
require("world")
require("util")
require("structures")
require("pickups")
require("player")
require("input")


debug = 1
math.random(os.time())
function love.load()
	--love.window.setFullscreen(1)

	--love.graphics.setBackgroundColor(10,10,10,255)
	love.graphics.setBackgroundColor(10,10,15,255)
	
	worldInit()
	playerInit()

	mapInit()


	-- stop following player when less 
	-- than cameraOffset (left side of screen)
end

function love.draw()
	-- set camera for world
	
	
	camera:set()
	
		love.graphics.setColor(30,30,35,255)
		love.graphics.rectangle("fill", -50, world.groundLevel+player.h, 10000, 500)	
		love.graphics.setColor(50,50,50,255)
		love.graphics.rectangle("fill", -50, world.groundLevel+player.h, 10000, 2)
		
		drawStructures()
		drawPlayer()
		drawPickups()
		
	camera:unset()
	

	-- overlays
	--drawWeather()
	
	
	-- debug info
	drawConsole()
	
end

function love.update(dt)

	if dt < 1/60 then
		love.timer.sleep(1/60 - dt)
	end

	checkInput(dt)

	physicsApply(player, dt)
	checkCollisions(dt)
	camera:setScale(1,1)	
	playerCameraFollow()

end

