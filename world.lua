world = {}

function world:init() 
	world.gravity = 900
	world.cameraOffset = 400
	world.groundLevel = 0
	world.startTime = os.time()
	world.seconds = 0
	world.minutes = 0

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

function world:loadMap(name)
--TEST FUNCTION
		--structures:platform(player.x+50, world.groundLevel-50, 100,10, 70,60,50)
		structures:platform(player.x+20, world.groundLevel-150, 100,20, 30,30,30, nil, 0,1,100,100)	
		structures:platform(player.x+150, world.groundLevel-120, 100,70, 30,30,30,nil)	
		structures:platform(player.x+150, world.groundLevel-320, 100,70, 30,30,30,nil)	
		structures:platform(player.x+350, world.groundLevel-200, 100,20, 30,30,30,nil, 1, 0, 100, 200)	
		--structures:platform(player.x+350, world.groundLevel-50, 100,20, 30,30,30,nil, 1, 0, 100, 200)	
		structures:platform(player.x+350, world.groundLevel, 100,20, 30,30,30,nil, 1, 0, 150, 200)	
		structures:platform(player.x+550, world.groundLevel-600, 100,20, 30,30,30, nil, 0,1,100,400)	
		structures:platform(player.x+1250, world.groundLevel-500, 300,20, 30,30,30, nil)	
		structures:platform(player.x+950, world.groundLevel-600, 100,20, 30,30,30, nil, 1,0,100,200)	
		
		structures:platform(player.x+1250, world.groundLevel, 50,20, 30,30,30, nil)	
		structures:platform(player.x+1350, world.groundLevel-20, 50,20, 30,30,30, nil)	
		structures:platform(player.x+1450, world.groundLevel-50, 50,20, 30,30,30, nil)	
		structures:platform(player.x+1550, world.groundLevel-80, 50,20, 30,30,30, nil)	
		
		structures:platform(player.x+1750, world.groundLevel-500, 100,1000, 70,60,50, nil)	
		
		pickups:coin(player.x +100, player.y+player.h/2, 10,10)	
		pickups:coin(player.x +200, player.y+player.h/2, 10,10)	
		pickups:coin(player.x +300, player.y+player.h/2, 10,10)	
		pickups:coin(player.x +400, player.y+player.h/2, 10,10)	
		pickups:coin(player.x +950+50,world.groundLevel-450, 10,10)	

		structures:crate(player.x +1000, player.y-player.h*2,50,50)	
		structures:crate(player.x +1080, player.y-player.h*2,50,50)
		structures:crate(player.x +1160, player.y-player.h*2,50,50)
		structures:crate(player.x +1240, player.y-player.h*2,50,50)
end
