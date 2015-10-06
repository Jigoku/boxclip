world = {}

function world:init() 
	world.gravity = 400
	world.cameraOffset = 400
	world.groundLevel = 200
	world.startTime = os.time()
	world.seconds = 0
	world.minutes = 0
	
	groundLevel_tile = love.graphics.newImage("graphics/tiles/lava.png")
	groundLevel_tile:setWrap("repeat", "repeat")
	groundLevel_quad = love.graphics.newQuad( -50,world.groundLevel, 10000, 500, groundLevel_tile:getDimensions() )
	
end


function world:run(dt)
	physics:world(dt)
	physics:pickups(dt)
	physics:enemies(dt)
	physics:player(player, dt)
	
	collision:checkWorld(dt)
	
	camera:setScale(1,1)
	player:follow(1)
end

function world:draw()
	-- set camera for world
	camera:set()

	--groundLevel placeholder
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(groundLevel_tile, groundLevel_quad, -50,world.groundLevel)

	structures:draw()
	pickups:draw()
	enemies:draw()
	player:draw()	
	
	camera:unset()
	
	-- overlays
	world:drawWeather()
end


function world:time()
	local time = os.time()
	local elapsed =  os.difftime(time-world.startTime)
	if os.difftime(time-world.startTime) == 60 then
		world.startTime = os.time()
		world.seconds = 0
		world.minutes = world.minutes +1
	end
	world.seconds = elapsed

	return string.format("%02d",world.minutes) .. ":" .. string.format("%02d",world.seconds)
end


function world:drawWeather()
	--rain gimick overlay
	maxParticle=5000
	local i = 0
	for star = i, maxParticle do
		local x = math.random(-400,4000)
		local y = math.random(-400,4000)
			love.graphics.setColor(255,255,255,15)
			love.graphics.line(x, y, x-5, y+40)
	end
end

function world:remove(objects)
	-- pass table here
	-- removes all entity types from world
	local n = 0
	for n, object in pairs(objects) do 
		if type(object) == "table" then
			table.remove(objects, n)
		end
	end
end

function world:loadMap(name)
--TEST FUNCTION

		repeat world:remove(enemies) until util:count(enemies) == 0
		repeat world:remove(pickups) until util:count(pickups) == 0
		repeat world:remove(structures) until util:count(structures) == 0

	
	love.graphics.setBackgroundColor(70,50,50,255)

		structures:platform(0, 0+player.h, 1330,200, 0,0)	
		structures:platform(1600, 0+player.h, 10000,200, 0,0)	
		structures:platform(0, world.groundLevel-800+player.h, 310,800, 0,0)	
		structures:platform(player.x+20, -350, 100,20, 0,1,100,300)	
		structures:platform(player.x+150, -120, 100,70)	
		structures:platform(player.x+150, -320, 100,70)	
		structures:platform(player.x+150, -520, 100,70)	
		structures:platform(player.x+150, -720, 100,70)	
		structures:platform(player.x+350, -320, 100,20, 1, 0, 100, 200)	
		structures:platform(player.x+350, -10, 100,20, 1, 0, 150, 200)	
		structures:platform(player.x+550, -600, 100,20, 0,1,100,400)	
		structures:platform(player.x+1250, -500, 300,20)	
		structures:platform(player.x+950, -600, 100,20, 1,0,100,200)	
		structures:platform(player.x+1250, 0, 50,20)	
		structures:platform(player.x+1350, -20, 50,20)	
		structures:platform(player.x+1450, -50, 50,20)	
		structures:platform(player.x+1550, -80, 50,20)	
		structures:platform(player.x+1750, -500, 100,1000)	
		
		pickups:gem(player.x +100, player.y+player.h/2)	
		pickups:gem(player.x +200, player.y+player.h/2)	
		pickups:gem(player.x +300, player.y+player.h/2)	
		pickups:gem(player.x +400, player.y+player.h/2)	
		pickups:gem(player.x +950+50,-450)	

		pickups:life(player.x +700, player.y+player.h/2)	

		structures:crate(700,-500,"gem")	
		structures:crate(760,-500,"gem")	
		structures:crate(820,-500,"gem")	
		structures:crate(700,-560,"gem")	
		structures:crate(760,-620,"gem")	
		structures:crate(820,-680,"life")	


		structures:crate(1400, player.y-player.h*2, "gem")	
		structures:crate(1480, player.y-player.h*2, "gem")
		structures:crate(1560, player.y-player.h*2, "gem")
		structures:crate(1640, player.y-player.h*2, "gem")
		
		enemies:walker(1000, 0,50,300)
		enemies:walker(500, 0,50,300)
end
