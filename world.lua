--[[
 * Copyright (C) 2015 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 --]]
 
 world = {}

--add menu option to change this.
--also portal entity should have parameter for "next map" 
--which changes this string before reinitializing the world
world.map = "maps/test.map"

--groundLevel textures
water = love.graphics.newImage("graphics/tiles/water.png")
lava = love.graphics.newImage("graphics/tiles/lava.png")
blood = love.graphics.newImage("graphics/tiles/blood.png")
stream = love.graphics.newImage("graphics/tiles/stream.png")



function world:settheme(theme)
	--theme palettes for different settings
	--specified in map file as "theme=*"

	--fallbacks
	background_scrollspeed = 0
	background_scroll = 0
	groundLevel_scrollspeed = 0
	groundLevel_scroll = 0	
	spike_gfx = spike
	icicle_gfx = icicle
	background_r = 100
	background_g = 100
	background_b = 100
	platform_wall_r = 220
	platform_wall_g = 220
	platform_wall_b = 220
	platform_top_r = 140
	platform_top_g = 140
	platform_top_b = 140
	crate_r = 255
	crate_g = 255
	crate_b = 255
	groundLevel_tile = water
	groundLevel_scrollspeed = 100
	background = ""
	background_scrollspeed = 20
	
	
	--theme definitions (overrides fallbacks)
	
	if theme == "sunny" then
		background_r = 100
		background_g = 150
		background_b = 160
		platform_wall_r = 240
		platform_wall_g = 170
		platform_wall_b = 120
		platform_top_r = 120
		platform_top_g = 160
		platform_top_b = 80
		crate_r = 230
		crate_g = 220
		crate_b = 180
		groundLevel_tile = water
		groundLevel_scrollspeed = 100
		background = love.graphics.newImage("graphics/backgrounds/sky.png")
		background_scrollspeed = 20
	elseif theme == "frost" then
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
		icicle_gfx = icicle_winter
		groundLevel_tile = water
		groundLevel_scrollspeed = 60
		background = ""
	elseif theme == "hell" then
		background_r = 35
		background_g = 30
		background_b = 30
		platform_wall_r = 95
		platform_wall_g = 70
		platform_wall_b = 70
		platform_top_r = 80
		platform_top_g = 30
		platform_top_b = 30
		crate_r = 120
		crate_g = 100
		crate_b = 100
		spike_gfx = spike_hell
		icicle_gfx = icicle_hell
		groundLevel_tile = blood
		groundLevel_scrollspeed = 40
		background = love.graphics.newImage("graphics/backgrounds/dark.png")
	elseif theme == "mist" then
		background_r = 135
		background_g = 130
		background_b = 120
		platform_wall_r = 180
		platform_wall_g = 180
		platform_wall_b = 180
		platform_top_r = 110
		platform_top_g = 160
		platform_top_b = 80
		crate_r = 200
		crate_g = 170
		crate_b = 170
		groundLevel_tile = lava
		groundLevel_scrollspeed = 20
		background = love.graphics.newImage("graphics/backgrounds/cloudy.png")
	elseif theme == "dust" then
		background_r = 135
		background_g = 100
		background_b = 80
		platform_wall_r = 235
		platform_wall_g = 180
		platform_wall_b = 120
		platform_top_r = 135
		platform_top_g = 80
		platform_top_b = 20
		crate_r = 200
		crate_g = 170
		crate_b = 170
		groundLevel_tile = lava
		groundLevel_scrollspeed = 30
		
		background = love.graphics.newImage("graphics/backgrounds/dusk.png")
		background_scrollspeed = -50
	elseif theme == "swamp" then
		background_r = 100
		background_g = 115
		background_b = 80
		platform_wall_r = 175
		platform_wall_g = 155
		platform_wall_b = 70
		platform_top_r = 50
		platform_top_g = 105
		platform_top_b = 0
		crate_r = 175
		crate_g = 155
		crate_b = 70
		groundLevel_tile = stream
		groundLevel_scrollspeed = 80
		background = love.graphics.newImage("graphics/backgrounds/forest.png")
	end
		groundLevel_tile:setWrap("repeat", "repeat")
		groundLevel_quad = love.graphics.newQuad( -50,world.groundLevel, 10000, 500, groundLevel_tile:getDimensions() )
		love.graphics.setBackgroundColor(background_r,background_g,background_b,255)
		
		if type(background) == "userdata" then
			background:setWrap("repeat", "repeat")
			background_quad = love.graphics.newQuad( 0,0, love.graphics.getWidth(),love.graphics.getHeight(), background:getDimensions() )
		end

end

function world:init(gamemode) 
	mode = gamemode
	console = false
	editing = false
	
	
	--move this setting into map files
	--once editor menu can adjust variables
	world.gravity = 400

	world.groundLevel = 200
	world.startTime = os.time()
	world.seconds = 0
	world.minutes = 0


	camera:setScale(1,1)

	--initialize entity counts
	world.platforms = 0
	world.crates = 0
	world.enemies = 0
	world.pickups = 0
	world.checkpoints = 0
	world.props = 0
	world.collision = 0
	world.portals = 0
	world.springs = 0
	
	world:empty()
	player:init() 
	mapio:loadmap(world.map)
	player:respawn()
	
	util:dprint("initialized world")
end



function world:draw()
	love.graphics.setColor(255,255,255,255)
	
	-- set camera for world
	camera:set()

	--paralax background
	if editing then
		--easier on the eyes for entity placement)
		love.graphics.setColor(255,255,255,50)
	end
	
	if type(background) == "userdata" then
		background_quad:setViewport(camera.x/6-background_scroll,camera.y/6,WIDTH*camera.scaleX,HEIGHT*camera.scaleY )
		love.graphics.draw(background, background_quad,camera.x-WIDTH/2*camera.scaleX,camera.y-HEIGHT/2*camera.scaleY)
	end
	
	love.graphics.setColor(255,255,255,200)
	--groundLevel placeholder
    groundLevel_quad:setViewport(0,-groundLevel_scroll,10000,500 )
	love.graphics.draw(groundLevel_tile, groundLevel_quad, -1000,world.groundLevel)


	
	
	platforms:draw()
	props:draw()
	springs:draw()
	checkpoints:draw()
	crates:draw()
	portals:draw()
	pickups:draw()
	enemies:draw()
	player:draw()	

	camera:unset()
	
	-- overlay tests
	--world:drawWeather()
	
	---cloud front layer?
	--love.graphics.setColor(255,255,255,155)
	--love.graphics.draw(background, background_quad,0,0)
	
	if mode == "editing" then
		editor:draw()
	end
	
	--draw the hud/scoreboard
	if mode =="game" then
		--love.graphics.setColor(0,0,0,50)
		--love.graphics.rectangle("fill",10,10,170,100)
		
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

function world:empty()
	repeat world:remove(enemies) until world:count(enemies) == 0
	repeat world:remove(pickups) until world:count(pickups) == 0
	repeat world:remove(crates) until world:count(crates) == 0
	repeat world:remove(props) until world:count(props) == 0
	repeat world:remove(platforms) until world:count(platforms) == 0
	repeat world:remove(checkpoints) until world:count(checkpoints) == 0
	repeat world:remove(portals) until world:count(portals) == 0
	repeat world:remove(springs) until world:count(springs) == 0
end

function world:totalents()
	--returns total entitys
	return world:count(pickups)+world:count(enemies)+world:count(platforms)+
			world:count(crates)+world:count(checkpoints)+world:count(portals)+world:count(props)+world:count(springs)
end

function world:totalentsdrawn()
	--returns total drawn entities
	return world.pickups+world.enemies+world.platforms+world.crates+
		world.checkpoints+world.portals+world.props+world.springs
end


function world:inview(entity) 
	
	--decides if the entity is visible in the game viewport
	if (entity.x < camera.x + (WIDTH/2*camera.scaleX)) 
	and (entity.x+entity.w > camera.x - (WIDTH/2*camera.scaleX))  then
		if (entity.y < camera.y + (HEIGHT/2*camera.scaleX)) 
		and (entity.y+entity.h > camera.y - (HEIGHT/2*camera.scaleX)) then
			world.collision = world.collision +1
			return true
		end
	end
	
end


function world:run(dt)

	world:timer()
	physics:world(dt)
	physics:player(dt)
	physics:pickups(dt)
	physics:enemies(dt)			
	collision:checkWorld(dt)
	player:follow(dt)

	if mode == "game" then
		if player.lives < 0 then
			util:dprint("game over")
			--add game over transition screen
			--should fade in, press button to exit to title
			title:init()
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
    
    --scroll background

	if type(background) == "userdata" then
		background_scroll = background_scroll + background_scrollspeed * dt
		if background_scroll > background:getWidth()then
			background_scroll = background_scroll - background:getWidth()
		end
	else
		background_scroll = 0
	end

	world.collision = 0
    
end
