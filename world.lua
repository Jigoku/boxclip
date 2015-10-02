world = {}

function worldInit() 
	world.gravity = 900
	world.cameraOffset = 400
	world.groundLevel = 0
	world.startTime = os.time()
	world.seconds = 0
	world.minutes = 0

end


function worldTime()
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


function drawWeather()
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

function mapInit()
--TEST FUNCTION
		--createPlatform(player.x+50, world.groundLevel-50, 100,10, 70,60,50)
		createStructure(player.x+20, world.groundLevel-150, 100,20, 30,30,30, nil, 0,1,100,100)	
		createStructure(player.x+150, world.groundLevel-120, 100,70, 30,30,30,nil)	
		createStructure(player.x+150, world.groundLevel-320, 100,70, 30,30,30,nil)	
		createStructure(player.x+350, world.groundLevel-200, 100,20, 30,30,30,nil, 1, 0, 100, 200)	
		--createPlatform(player.x+350, world.groundLevel-50, 100,20, 30,30,30,nil, 1, 0, 100, 200)	
		createStructure(player.x+350, world.groundLevel, 100,20, 30,30,30,nil, 1, 0, 150, 200)	
		createStructure(player.x+550, world.groundLevel-600, 100,20, 30,30,30, nil, 0,1,100,400)	
		createStructure(player.x+1250, world.groundLevel-500, 300,20, 30,30,30, nil)	
		createStructure(player.x+950, world.groundLevel-600, 100,20, 30,30,30, nil, 1,0,100,200)	
		
		createStructure(player.x+1250, world.groundLevel, 50,20, 30,30,30, nil)	
		createStructure(player.x+1350, world.groundLevel-20, 50,20, 30,30,30, nil)	
		createStructure(player.x+1450, world.groundLevel-50, 50,20, 30,30,30, nil)	
		createStructure(player.x+1550, world.groundLevel-80, 50,20, 30,30,30, nil)	
		
		
		  createStructure(player.x+1750, world.groundLevel-500, 100,1000, 70,60,50, nil)	
		
		createCoin(player.x +100, player.y+player.h/2, 10,10)	
		createCoin(player.x +200, player.y+player.h/2, 10,10)	
		createCoin(player.x +300, player.y+player.h/2, 10,10)	
		createCoin(player.x +400, player.y+player.h/2, 10,10)	
		createCoin(player.x +950+50,world.groundLevel-450, 10,10)	

		createCrate(player.x +1000, player.y-player.h*2,50,50)	
		createCrate(player.x +1080, player.y-player.h*2,50,50)
		createCrate(player.x +1160, player.y-player.h*2,50,50)
		createCrate(player.x +1240, player.y-player.h*2,50,50)
end
