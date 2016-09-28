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
--   world.map = "maps/test"
world.splash = {}

--loading/act display
function world:initSplash()
	world.splash = {}
	world.splash.bg = love.graphics.newImage("data/images/tiles/checked.png")
	world.splash.bg:setWrap("repeat", "repeat")
	world.splash.active = true
	world.splash.opacity = 255
	world.splash.timer = 3
	world.splash.fadespeed = 400
	world.splash.box_h = 100
	world.splash.box_y = -world.splash.box_h/2
	world.splash.text_y = -world.splash.box_h/2
	transitions:fadein()
end

function world:settheme(theme)
	--theme palettes for different level style

	--intialize default fallbacks
	love.filesystem.load( "themes/default.lua" )( )
	
	world.theme = theme or "default"

	-- load the theme file
	if love.filesystem.load( "themes/".. theme ..".lua" )( ) then 
		console:print("failed to set theme:  " .. theme)
	else
		--groundLevel_tile:setWrap("repeat", "repeat")
		--groundLevel_quad = love.graphics.newQuad( -50,world.groundLevel, 10000, 500, groundLevel_tile:getDimensions() )
		love.graphics.setBackgroundColor(background_r,background_g,background_b,255)
		
		--only set background if it exists
		if type(background) == "userdata" then
			background:setWrap("repeat", "repeat")
			background_quad = love.graphics.newQuad( 0,0, love.graphics.getWidth(),love.graphics.getHeight(), background:getDimensions() )
		end
	
		console:print("set theme: " .. theme)
		
	end
	
	love.graphics.setBackgroundColor(background_r,background_g,background_b,255)	
end



function world:init(gamemode) 
	
	
	mode = gamemode
	--console = false
	editing = false
	paused = false
	
	--world loading/splash/act display
	if mode == "game" then
		world:initSplash()
	else
		world.splash.active = false
	end
	
	--move this setting into map files
	--once editor menu can adjust variables
	world.gravity = 400

	-- 
	-- y co-ordinate of deadzone
	-- anything falling past this point will land here
	-- (used to stop entities being lost, eg; falling forever)
	-- if it collides with gameworld, increase this value so it's below the map
	world.bedrock = 2000 
	
	camera:setScale(camera.defaultscale,camera.defaultscale)
	
	world:reset()

	mapio:loadmap(world.map)
	
	if cheats.catlife then player.lives = player.lives +  9 end
	if cheats.millionare then player.score = player.score +  "1000000" end
	
	player:respawn()

	console:print("initialized world")
end


    

function world:draw()
	
	love.graphics.setColor(255,255,255,255)
	
	-- set camera for world
	camera:set()

	--paralax background
	if not editing then
		if type(background) == "userdata" then
			love.graphics.draw(background, background_quad,camera.x-game.width/2*camera.scaleX,camera.y-game.height/2*camera.scaleY)
		end
	end
	
	--[[ draw bedrock here
	
	--]]
	


	love.graphics.setColor(255,255,255,255)
	
	decals:draw()
	props:draw()
	platforms:draw()
	springs:draw()
	bumpers:draw()
	checkpoints:draw()
	crates:draw()
	portals:draw()
	pickups:draw()
	enemies:draw()
	materials:draw()
	
	player:draw()	

	camera:unset()
	
	if mode == "editing" then
		editor:draw()
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
		love.graphics.printf(world:formatTime(world.time), 21,61,150,"right",0,1,1)
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
		love.graphics.printf(world:formatTime(world.time), 20,60,150,"right",0,1,1)
		love.graphics.printf(player.gems, 20,80,150,"right",0,1,1)
		love.graphics.setFont(fonts.default)
		
		if world.splash.opacity > 0 then 
			world:drawSplash()
		end
	end
	
	if paused then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill",0,0,game.width,game.height)
		love.graphics.setColor(255,255,255,155)
		love.graphics.setFont(fonts.huge)
		love.graphics.printf("PAUSED", game.width/2,game.height/3,0,"center",0,1,1)
		love.graphics.setFont(fonts.default)
	end
end


	

function world:drawSplash()

	-- textured background
		love.graphics.setColor(50,50,50,world.splash.opacity)		
		self.splash.quad = love.graphics.newQuad( 0,0, game.width,game.height, self.splash.bg:getDimensions() )
		love.graphics.draw(self.splash.bg, self.splash.quad, 0, 0)
	
		
		--box
		love.graphics.setColor(platform_r/2,platform_g/2,platform_b/2,world.splash.opacity)
		love.graphics.rectangle("fill", 0,world.splash.box_y+game.height/2,game.width, world.splash.box_h )
		love.graphics.setFont(fonts.huge)
		
		--text
		love.graphics.setColor(255,255,255,world.splash.opacity)
		love.graphics.print(world.maptitle, game.width/1.5, world.splash.text_y+game.height/2+world.splash.box_h/2)
		love.graphics.setFont(fonts.default)
			

end


function world:timer(dt)
	--update the world time
	world.time = world.time + 1 *dt	
end


function world:formatTime(n)
	return  
		string.format("%02d",n / 60 % 60) .. ":" .. 
		string.format("%02d",n % 60)
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
	for n, object in ripairs(objects) do 
		if type(object) == "table" then
			table.remove(objects, n)
		end
	end
end

function world:reset()
	world.time = 0
	world.collision = 0
	 world:remove(enemies) 
	 world:remove(pickups) 
	 world:remove(crates) 
	 world:remove(props) 
	 world:remove(platforms)
	 world:remove(checkpoints)
	 world:remove(portals) 
	 world:remove(springs) 
	 world:remove(decals) 
	 world:remove(bumpers) 
	 world:remove(materials) 
end

function world:totalents()
	--returns total entitys
	return world:count(pickups)+world:count(enemies)+world:count(platforms)+
			world:count(crates)+world:count(checkpoints)+world:count(portals)+world:count(props)+world:count(springs)+world:count(decals)
end

function world:totalentsdrawn()
	--returns total drawn entities
	return world.pickups+world.enemies+world.platforms+world.crates+
		world.checkpoints+world.portals+world.props+world.springs+world.decals
end


function world:inview(entity) 
	--check if entity is offset (probably swinging or rotating)
		if entity.swing == 1 then
			if (entity.xorigin-entity.radius < camera.x + (game.width/2*camera.scaleX)) 
			and (entity.xorigin+entity.w+entity.radius > camera.x - (game.width/2*camera.scaleX))  then
				if (entity.yorigin-entity.radius < camera.y + (game.height/2*camera.scaleX)) 
				and (entity.yorigin+entity.h+entity.radius > camera.y - (game.height/2*camera.scaleX)) then
					world.collision = world.collision +1
				return true
				end
			end
		else
			--decides if the entity is visible in the game viewport
			if (entity.x < camera.x + (game.width/2*camera.scaleX)) 
			and (entity.x+entity.w > camera.x - (game.width/2*camera.scaleX))  then
				if (entity.y < camera.y + (game.height/2*camera.scaleX)) 
				and (entity.y+entity.h > camera.y - (game.height/2*camera.scaleX)) then
					world.collision = world.collision +1
					return true
				end
			end	
		
		end
	
end




function world:update(dt)
	
	if not paused then 

		collision:checkWorld(dt)
		physics:world(dt)
		physics:player(dt)
		physics:pickups(dt)
		physics:enemies(dt)			
		player:setcamera(dt)
		decals:update(dt)
		portals:update(dt)
		world.collision = 0
		
		if type(background) == "userdata" then
			background_scroll = background_scroll + background_scrollspeed * dt
			if background_scroll > background:getWidth()then
				background_scroll = background_scroll - background:getWidth()
			end
			background_quad:setViewport(camera.x/5-background_scroll,camera.y/10,game.width*camera.scaleX,game.height*camera.scaleY )
		else
			background_scroll = 0
		end
	
		
		
		if mode == "game" then
		
			--trigger world splash/act display
			if world.splash.opacity > 0 then 
				world.splash.timer = math.max(0, world.splash.timer - dt)
		
				if world.splash.timer <= 0 then
					world.splash.timer = 0
					world.splash.active = false
					world.splash.opacity = world.splash.opacity -world.splash.fadespeed *dt
					world.splash.text_y = world.splash.text_y + world.splash.fadespeed *dt
					world.splash.box_y = world.splash.box_y + world.splash.fadespeed *dt
				end
				return 
			end
		
		
			if player.lives < 0 then
				console:print("game over")
				--add game over transition screen
				--should fade in, press button to exit to title
				title:init()
			end
			

			--[[
			if player.gems == 100 then
				player.gems = 0
				player.lives = player.lives +1
				sound:play(sound.effects["lifeup"])
			end
			--]]
		end

	
		world:timer(dt)
	
		
	end

		
end
