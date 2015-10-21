world = {}

--add menu option to change this.
--also portal entity should have parameter for "next map" 
--which changes this string before reinitializing the world
world.map = "maps/test.map"

--groundLEvel textures
water = love.graphics.newImage("graphics/tiles/water.png")
lava = love.graphics.newImage("graphics/tiles/lava.png")
blood = love.graphics.newImage("graphics/tiles/blood.png")

function world:settheme(theme)
	--theme palettes for different settings
	--specified in map file as "theme=*"
	if theme == "jungle" then
		background_r = 100
		background_g = 150
		background_b = 130
		platform_wall_r = 210
		platform_wall_g = 150
		platform_wall_b = 100
		platform_top_r = 100
		platform_top_g = 140
		platform_top_b = 60
		crate_r = 230
		crate_g = 220
		crate_b = 180
		spike_gfx = spike
		groundLevel_tile = water
		groundLevel_scrollspeed = 100
	elseif theme == "winter" then
		background_r = 130
		background_g = 150
		background_b = 150
		platform_wall_r = 115
		platform_wall_g = 170
		platform_wall_b = 170
		platform_top_r = 170
		platform_top_g = 180
		platform_top_b = 190
		crate_r = 200
		crate_g = 255
		crate_b = 255
		spike_gfx = spike_winter
		groundLevel_tile = water
		groundLevel_scrollspeed = 100
	elseif theme == "hell" then
		background_r = 35
		background_g = 30
		background_b = 30
		platform_wall_r = 95
		platform_wall_g = 90
		platform_wall_b = 90
		platform_top_r = 80
		platform_top_g = 30
		platform_top_b = 30
		crate_r = 120
		crate_g = 100
		crate_b = 100
		spike_gfx = spike_hell
		groundLevel_tile = blood
		groundLevel_scrollspeed = 100

	end
		groundLevel_tile:setWrap("repeat", "repeat")
		groundLevel_quad = love.graphics.newQuad( -50,world.groundLevel, 10000, 500, groundLevel_tile:getDimensions() )
	
end

function world:init() 
	console = false
	editing = false
	
	--move this setting into map files
	--once editor menu can adjust variables
	world.gravity = 400

	world.groundLevel = 200
	world.startTime = os.time()
	world.seconds = 0
	world.minutes = 0
	
	groundLevel_scroll = 0

	camera:setScale(1,1)

	--initialize entity counts
	world.platforms = 0
	world.crates = 0
	world.enemies = 0
	world.pickups = 0
	world.checkpoints = 0
	world.scenery = 0
	world.collision = 0
	world.portals = 0
end



function world:draw()
	love.graphics.setColor(255,255,255,255)
	
	-- set camera for world
	camera:set()

	--groundLevel placeholder
    groundLevel_quad:setViewport(0,-groundLevel_scroll,10000,500 )
	love.graphics.draw(groundLevel_tile, groundLevel_quad, -1000,world.groundLevel)


	platforms:draw()
	scenery:draw()
	checkpoints:draw()
	crates:draw()
	portals:draw()
	pickups:draw()
	enemies:draw()
	player:draw()	
	
	camera:unset()
	
	
	if editing then
		editor:draw()	
	end
	
	if mode == "editing" then

		--print some editor controls
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("comma (axis info)",10, love.window.getHeight()-220)
		love.graphics.print("period (entity info)",10, love.window.getHeight()-200)
		love.graphics.print("M (mmap)",10, love.window.getHeight()-180)
		love.graphics.print("` (console)",10, love.window.getHeight()-160)
		love.graphics.print("F1 (edit)",10, love.window.getHeight()-140)
		love.graphics.print("F12 - savemap)",10, love.window.getHeight()-120)
		love.graphics.print("kp2/4/6/8 (reposition platforms)",10, love.window.getHeight()-100)
		love.graphics.print("kp+/kp- (select entity)",10, love.window.getHeight()-80)
		love.graphics.print("C (copy)",10, love.window.getHeight()-60)
		love.graphics.print("P (paste)",10, love.window.getHeight()-40)
		love.graphics.print("Z (zoom)",10, love.window.getHeight()-20)
		love.graphics.setColor(0,255,155,155)
		
		love.graphics.setFont(fonts.large)
		love.graphics.print("editing",love.window.getWidth()-80, 10,0,1,1)
		love.graphics.setFont(fonts.default)
	end
	
	--draw the hud/scoreboard
	if mode =="game" then
		love.graphics.setFont(fonts.scoreboard)
		love.graphics.setColor(0,0,0,155)
		love.graphics.printf("SCORE", 21,21,300,"left",0,1,1)
		love.graphics.printf("LIVES", 21,41,300,"left",0,1,1)
		love.graphics.printf("TIME", 21,61,300,"left",0,1,1)
		love.graphics.printf("GEMS", 21,81,300,"left",0,1,1)
		love.graphics.printf(player.score, 21,21,150,"right",0,1,1)
		love.graphics.printf(player.lives, 21,41,150,"right",0,1,1)
		love.graphics.printf(world:gettime(), 21,61,150,"right",0,1,1)
		love.graphics.printf(player.gems, 21,81,150,"right",0,1,1)
		love.graphics.setFont(fonts.default)
		
		love.graphics.setFont(fonts.scoreboard)
		love.graphics.setColor(255,255,255,155)
		love.graphics.printf("SCORE", 20,20,300,"left",0,1,1)
		love.graphics.printf("LIVES", 20,40,300,"left",0,1,1)
		love.graphics.printf("TIME", 20,60,300,"left",0,1,1)
		love.graphics.printf("GEMS", 20,80,300,"left",0,1,1)
		love.graphics.printf(player.score, 20,20,150,"right",0,1,1)
		love.graphics.printf(player.lives, 20,40,150,"right",0,1,1)
		love.graphics.printf(world:gettime(), 20,60,150,"right",0,1,1)
		love.graphics.printf(player.gems, 20,80,150,"right",0,1,1)
		love.graphics.setFont(fonts.default)
	end

	-- overlays
	--world:drawWeather()
end


function world:timer()
	--update the world time
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
	--returns the world time (eg 00:00)
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
	--count tables within a table
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

function world:totalents()
	--returns total entitys
	return world:count(pickups)+world:count(enemies)+world:count(platforms)+
			world:count(crates)+world:count(checkpoints)+world:count(portals)+world:count(scenery)
end

function world:totalentsdrawn()
	--returns total drawn entities
	return world.pickups+world.enemies+world.platforms+world.crates+
		world.checkpoints+world.portals+world.scenery
end


function world:inview(entity) 
	--decides if the entity is visible in the game viewport
	if (entity.x < player.x + (love.graphics.getWidth()/2*camera.scaleX)+200) 
	and (entity.x+entity.w > player.x - (love.graphics.getWidth()/2*camera.scaleX)-200)  then
		if (entity.y < player.y + (love.graphics.getHeight()/2*camera.scaleX)+200) 
		and (entity.y+entity.h > player.y - (love.graphics.getHeight()/2*camera.scaleX)-200) then
			world.collision = world.collision +1
			return true
		end
	end
	
end


function world:run(dt)
	if mode == "game" then
		if player.lives < 0 then
			mode = "title"
		end
		

		--[[
		if player.gems == 100 then
			player.gems = 0
			player.lives = player.lives +1
			sound:play(sound.lifeup)
		end
		--]]
	end
	--love.audio.stop( )
	
	--scroll groundLevel!
	groundLevel_scroll = groundLevel_scroll + groundLevel_scrollspeed * dt
	  if groundLevel_scroll > groundLevel_tile:getHeight()then
        groundLevel_scroll = groundLevel_scroll - groundLevel_tile:getHeight()
    end
	world.collision = 0
    
end
