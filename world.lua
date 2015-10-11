world = {}

function world:init() 
	world.gravity = 400

	world.groundLevel = 200
	world.startTime = os.time()
	world.seconds = 0
	world.minutes = 0
	
	groundLevel_tile = love.graphics.newImage("graphics/tiles/water.png")
	groundLevel_tile:setWrap("repeat", "repeat")
	groundLevel_quad = love.graphics.newQuad( -50,world.groundLevel, 10000, 500, groundLevel_tile:getDimensions() )
	camera:setScale(1,1)

	--initialize entity counts
	world.platforms = 0
	world.crates = 0
	world.enemies = 0
	world.pickups = 0
end


function world:run(dt)
	world:timer()
	physics:world(dt)
	

	physics:pickups(dt)
	physics:enemies(dt)
	physics:crates(player,dt)
	physics:platforms(player, dt)
		
	if not editing then
		-- update new poisition
		player.x = player.newX
		player.y = player.newY
	
		-- stop increasing velocity if we hit ground
		if player.y+player.h > world.groundLevel  then
			player:respawn()
		end
	end
		
	collision:checkWorld(dt)
	player:follow()
end

function world:draw()
	-- set camera for world
	camera:set()

	--groundLevel placeholder
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(groundLevel_tile, groundLevel_quad, -1000,world.groundLevel)
	

	platforms:draw()
	checkpoints:draw()
	crates:draw()
	pickups:draw()
	enemies:draw()
	player:draw()	
	
	--editor specifics
	if editing then
		editor:draw()
	end
	
	camera:unset()
	
	-- overlays
	--world:drawWeather()
end


function world:timer()
	local time = os.time()
	local elapsed =  os.difftime(time-world.startTime)
	if os.difftime(time-world.startTime) == 60 then
		world.startTime = os.time()
		world.seconds = 0
		world.minutes = world.minutes +1
	end
	world.seconds = elapsed
end

function world:gettime()
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

function world:count(table)
	local count = 0
	for n, object in pairs(table) do 
		if type(object) == "table" then
			count = count + 1 
		end
	end
	return count
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


function world:inview(entity) 
	--decides if the entity is visible in the game viewport
	if (entity.x < player.x + (love.graphics.getWidth()/2*camera.scaleX)) 
	and (entity.x+entity.w > player.x - (love.graphics.getWidth()/2*camera.scaleX))  then
		return true
	end
end

function world:loadMap(mapname)
	--cleanup the map
	repeat world:remove(enemies) until world:count(enemies) == 0
	repeat world:remove(pickups) until world:count(pickups) == 0
	repeat world:remove(crates) until world:count(crates) == 0
	repeat world:remove(platforms) until world:count(platforms) == 0
	
	--load the map
	dofile(mapname)
end
