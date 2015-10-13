world = {}

world.map = "maps/test.map"

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
	world.checkpoints = 0
	
	sound.music05:setLooping(true)
	sound.music05:setVolume(0.5)
	sound.music05:play()
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
	
	camera:unset()
	
	--editor specifics
	if editing then
		editor:draw()
	end

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
	if (entity.x < player.x + (love.graphics.getWidth()/2*camera.scaleX)+100) 
	and (entity.x+entity.w > player.x - (love.graphics.getWidth()/2*camera.scaleX)-100)  then
		if (entity.y < player.y + (love.graphics.getHeight()/2*camera.scaleX)+100) 
		and (entity.y+entity.h > player.y - (love.graphics.getHeight()/2*camera.scaleX)-100) then
		return true
		end
	end
end

function world:loadMap(mapname)
	--cleanup the map
	repeat world:remove(enemies) until world:count(enemies) == 0
	repeat world:remove(pickups) until world:count(pickups) == 0
	repeat world:remove(crates) until world:count(crates) == 0
	repeat world:remove(platforms) until world:count(platforms) == 0
	repeat world:remove(checkpoints) until world:count(checkpoints) == 0

	--load the mapfile
	local fh = io.open(mapname, "r")

	while true do
        line = fh.read(fh)
        if not line then break end
			-- parse background color
			if string.find(line, "^background=(.+)") then
				local r,g,b,o = string.match(line, "^background=(%d+),(%d+),(%d+),(%d+)")
				love.graphics.setBackgroundColor(r,g,b,o)
			end
			--parse platforms
			if string.find(line, "^platform=(.+)") then
				
				local x,y,w,h,movex,movey,movespeed,movedist = string.match(
					line, "^platform=(%-?%d+),(%-?%d+),(%-?%d+),(%-?%d+),(%-?%d+),(%-?%d+),(%-?%d+),(%-?%d+)"
				)
				platforms:add(tonumber(x),tonumber(y),tonumber(w),tonumber(h),tonumber(movex),tonumber(movey),tonumber(movespeed),tonumber(movedist))
			end
			-- parse pickups
			if string.find(line, "^pickup=(.+)") then
				local x,y,item = string.match(
					line, "^pickup=(%-?%d+),(%-?%d+),(.+)"
				)
				pickups:add(tonumber(x),tonumber(y),item)
			end
			--parse crates
			if string.find(line, "^crate=(.+)") then
				local x,y,item = string.match(
					line, "^crate=(%-?%d+),(%-?%d+),(.+)"
				)
				crates:add(tonumber(x),tonumber(y),item)
			end
			--parse checkpoints
			if string.find(line, "^checkpoint=(.+)") then
				local x,y = string.match(
					line, "^checkpoint=(%-?%d+),(%-?%d+)"
				)
				checkpoints:add(tonumber(x),tonumber(y))
			end
			--parse enemy(walker)
			if string.find(line, "^walker=(.+)") then
				local x,y,movespeed,movedist = string.match(
					line, "^walker=(%-?%d+),(%-?%d+),(%-?%d+),(%-?%d+)"
				)
				enemies:walker(tonumber(x),tonumber(y),tonumber(movespeed),tonumber(movedist))
				
			end
    end
    fh:close()

end



function world:run()
	if player.lives < 0 then
		mode = "title"
	end
end
