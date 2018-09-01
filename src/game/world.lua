--[[
 * Copyright (C) 2015 - 2018 Ricky K. Thomson
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
world.splash = {}

world.state = {} --world.entities on checkpoint


--world.camera?

--test parallax background layers
test = love.graphics.newImage("data/images/test.png")
test2 = love.graphics.newImage("data/images/test2.png")
test:setWrap("repeat", "clamp")
test2:setWrap("repeat", "clampzero")
test_quad = love.graphics.newQuad( 0,0, love.graphics.getWidth(),test:getHeight(), test:getDimensions() )
test_quad2 = love.graphics.newQuad( 0,0, love.graphics.getWidth(),test2:getHeight(), test2:getDimensions() )
test_quad3 = love.graphics.newQuad( 0,0, love.graphics.getWidth(),test:getHeight(), test:getDimensions() )




function world:initsplash()
	--loading/act overlay
	world.splash = {}
	world.splash.bg = love.graphics.newImage("data/images/platforms/0001.png")
	world.splash.bg:setWrap("repeat", "repeat")
	world.splash.active = true
	world.splash.opacity = 1
	world.splash.timer = 3
	world.splash.fadespeed = 1
	world.splash.box_h = 100
	world.splash.box_y = -world.splash.box_h/2
	world.splash.text_y = -world.splash.box_h/2
	transitions:fadein()
end


function world:endoflevel()
	world.complete = true
	world.scoreboard = {}
	world.scoreboard.timer = 12
	world.scoreboard.title = world.maptitle
	world.scoreboard.status = "GOAL REACHED"
	world.scoreboard.w = 500
	world.scoreboard.h = 300
	world.scoreboard.padding = 10
	world.scoreboard.canvas = love.graphics.newCanvas(world.scoreboard.w,world.scoreboard.h)
	world.scoreboard.opacity = 0
	world.scoreboard.fadespeed = 1
	--world.scoreboard.wait = 3
end


function world:settheme(theme)
	--theme palettes for different level style
	--intialize default fallbacks
	love.filesystem.load( "themes/default.lua" )( )
	
	--set the desired theme name
	world.theme = theme or "default"

	--load the theme file
	if love.filesystem.load( "themes/".. theme ..".lua" )( ) then 
		console:print("failed to set theme:  " .. theme)
	else
	
		--background	
		love.graphics.setBackgroundColor(0.3,0.3,0.3,1)
		
		--only set background image if it exists
		if type(background) == "userdata" then
			background:setWrap("repeat", "repeat")
			background_quad = love.graphics.newQuad( 0,0, love.graphics.getWidth(),love.graphics.getHeight(), background:getDimensions() )
		end
	
		console:print("set theme: " .. theme)
		
	end
	
end


function world:setdefaults()
	--defaults in case not specified in map file
	
	--default gravity
	world.gravity = 2000

	--default scores (used to track/reset on death)
	-- for remembering player.score and player.gems
	world.score = 0
	world.gems = 0
	
	--reset time
	world.time = 0
	
	world.complete = false
	
	--default deadzone
	-- anything falling past this point will land here
	-- (used to stop entities being lost, eg; falling forever)
	-- if it collides with gameworld, increase this value so it's below the furthest entity
	world.deadzone = 2000 
	
	--default theme/pallete
	world:settheme("default")
	
	--default sound options
	world.mapmusic = 0
	world.mapambient = 0
	
	--default map title
	world.maptitle = "unnamed map"
	
	--default map to load on finish
	--either mapname.lua or title
	world.nextmap = "title"
end


function world:init(gamemode) 
	mode = gamemode
	--console = false
	editing = false
	paused = false
	
	--world loading/splash/act display
	if mode == "game" then
		world:initsplash()
	else
		world.splash.active = false
	end
	
	--collision counter (console/debug)
	world.collision = 0
	
	player:init() 
	world:reset()
	world:setdefaults()
	mapio:loadmap(world.map)

	-- find the spawn entity
	-- set as player spawn position
	for _, portal in ipairs(world.entities.portal) do
		if portal.type == "spawn" then
			player.spawnX = portal.x
			player.spawnY = portal.y
		end
	end	
	
	world:resetcamera()
	world:savestate()

	--enable cheats, if any
	if cheats.catlife then player.lives = player.lives +  9 end
	if cheats.millionare then player.score = player.score +  "1000000" end
	
	player:respawn()

	console:print("initialized world")
end



function world:drawparallax()

	--TODO this still needs fixing
	
	if editing then return end
	love.graphics.setColor(1,1,1,1)
	
	--paralax background sky
	if type(background) == "userdata" then
		love.graphics.draw(
			background, background_quad,0,0
		)
	end

	--back layer
	love.graphics.setColor(
		platform_top_r/2,
		platform_top_g/2,
		platform_top_b/2,
		1
	)
		
	test_quad:setViewport(
		(camera.x*2)/10*camera.scale,((camera.y*2)/40),love.graphics.getWidth(),love.graphics.getHeight()
	)
	love.graphics.draw(
		test,
		test_quad,				
		0,0
	)
	
	--middle layer
	love.graphics.setColor(
		platform_behind_r,
		platform_behind_g,
		platform_behind_b,
		1
	)

	test_quad2:setViewport(
		(camera.x*3)/10*camera.scale,((camera.y*3)/35),love.graphics.getWidth(),love.graphics.getHeight()
	)
	love.graphics.draw(
		test2,
		test_quad2,				
		0,0
	)
	
	--front layer
	love.graphics.setColor(
		platform_top_r/1.5,
		platform_top_g/1.5,
		platform_top_b/1.5,
		1
	)
		
	test_quad3:setViewport(
		(camera.x*4)/10*camera.scale,((camera.y*4)/30),love.graphics.getWidth(),love.graphics.getHeight()
	)
	love.graphics.draw(
		test,
		test_quad3,				
		0,0
	)
	--]]
end


function world:draw()
	

	self:drawparallax()
	
	-- set camera for world
	camera:attach()
	
	--[[ draw deadzone here
		unimplemented
	--]]

	love.graphics.setColor(1,1,1,1)

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
	traps:draw()
	materials:draw()
	tips:draw()

	player:draw()	

	
	weather:draw()
	
	popups:draw()

	camera:detach()

	
	if mode == "editing" then
		editor:draw()
	end
	
	camera:draw()
	
	--draw the hud/scoreboard
	if mode =="game" then
		
		world:drawhud()
		
		if world.splash.opacity > 0 then 
			world:drawsplash()
		end
	end
	
	
	if world.complete then
		world:drawscoreboard()
	end
	
	if paused then
		love.graphics.setColor(0,0,0,0.6)
		love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
		love.graphics.setColor(1,1,1,0.6)
		love.graphics.setFont(fonts.huge)
		love.graphics.printf("PAUSED", 0,love.graphics.getHeight()/3,love.graphics.getWidth(),"center",0,1,1)
		love.graphics.setFont(fonts.default)
		love.graphics.line(love.graphics.getWidth()/2.5,love.graphics.getHeight()/3,love.graphics.getWidth()-love.graphics.getWidth()/2.5,love.graphics.getHeight()/3)
		love.graphics.line(love.graphics.getWidth()/2.5,love.graphics.getHeight()/3+40,love.graphics.getWidth()-love.graphics.getWidth()/2.5,love.graphics.getHeight()/3+40)
	end
end


function world:drawsplash()
	if debug then return end
	-- textured background
		love.graphics.setColor(0.2,0.2,0.2,world.splash.opacity)		
		self.splash.quad = love.graphics.newQuad( 0,0, love.graphics.getWidth(),love.graphics.getHeight(), self.splash.bg:getDimensions() )
		love.graphics.draw(self.splash.bg, self.splash.quad, 0, 0)
	
		--box
		love.graphics.setColor(platform_r/2,platform_g/2,platform_b/2,world.splash.opacity)
		love.graphics.rectangle("fill", 0,world.splash.box_y+love.graphics.getHeight()/2,love.graphics.getWidth(), world.splash.box_h )
		
		--text
		love.graphics.setFont(fonts.huge)
		love.graphics.setColor(1,1,1,world.splash.opacity)
		love.graphics.print(world.maptitle, love.graphics.getWidth()-fonts.huge:getWidth(world.maptitle)-100, world.splash.text_y+love.graphics.getHeight()/2+world.splash.box_h/2)
		love.graphics.setFont(fonts.default)
end


function world:drawscoreboard()
	if debug then return end
	
	love.graphics.setCanvas(world.scoreboard.canvas)
	love.graphics.clear()
	
	--frame
	love.graphics.setColor(0,0,0,0.75)
	love.graphics.rectangle("fill",0,0,world.scoreboard.canvas:getWidth(),world.scoreboard.canvas:getHeight(),10)
	
	--title
	love.graphics.setFont(fonts.huge)
	love.graphics.setColor(0.3,0.3,0.3,1)
	love.graphics.rectangle("fill",world.scoreboard.padding,world.scoreboard.padding,world.scoreboard.canvas:getWidth()-world.scoreboard.padding*2,fonts.huge:getHeight(world.scoreboard.title)+world.scoreboard.padding*2,10)
	love.graphics.setColor(1,1,1,1)
	love.graphics.print(world.scoreboard.title, world.scoreboard.canvas:getWidth()/2-fonts.huge:getWidth(world.scoreboard.title)/2,world.scoreboard.padding*2)
	
	--love.graphics.setColor(0,255,0,255)
	--love.graphics.setFont(fonts.large)
	--love.graphics.print(world.scoreboard.status, world.scoreboard.canvas:getWidth()/2-fonts.large:getWidth(world.scoreboard.title)/2,30)
	
	--stats
	love.graphics.setFont(fonts.large)
	local y = 80
	
	love.graphics.setColor(0.8,0.8,0.8,1)
	love.graphics.print("SCORE",world.scoreboard.padding*2,y)
	love.graphics.setColor(0,1,0,1)
	love.graphics.print(player.score,world.scoreboard.canvas:getWidth()/2,y)
	
	love.graphics.setColor(0.8,0.8,0.8,1)
	love.graphics.print("TIME",world.scoreboard.padding*2,y+25)
	love.graphics.setColor(0,1,0,1)
	love.graphics.print(world:formattime(world.time),world.scoreboard.canvas:getWidth()/2,y+25)

	love.graphics.setColor(0.8,0.8,0.8,1)
	love.graphics.print("GEMS",world.scoreboard.padding*2,y+50)
	love.graphics.setColor(0,1,0,1)
	love.graphics.print(player.gems,world.scoreboard.canvas:getWidth()/2,y+50)
	
	love.graphics.setCanvas()
	
	--draw canvas
	love.graphics.setColor(1,1,1,world.scoreboard.opacity)
	love.graphics.draw(world.scoreboard.canvas,love.graphics.getWidth()/2-world.scoreboard.canvas:getWidth()/2, love.graphics.getHeight()/2-world.scoreboard.canvas:getHeight()/2)
end


function world:drawhud()
	if debug then return end
	love.graphics.setFont(fonts.hud)
	
	love.graphics.setColor(0,0,0,0.6)

	love.graphics.printf("SCORE", 21,21,300,"left",0,1,1)
	love.graphics.printf("TIME", 21,41,300,"left",0,1,1)
	love.graphics.printf("GEMS", 21,61,300,"left",0,1,1)
	love.graphics.printf(player.score, 21,21,150,"right",0,1,1)
	love.graphics.printf(world:formattime(world.time), 21,41,150,"right",0,1,1)
	love.graphics.printf(player.gems, 21,61,150,"right",0,1,1)	
	
	love.graphics.printf("x"..player.lives, 21,love.graphics.getHeight()-40+1,50,"right",0,1,1)
	
	
	love.graphics.setColor(1,1,1,0.6)
	love.graphics.printf("SCORE", 20,20,300,"left",0,1,1)
	love.graphics.printf("TIME", 20,40,300,"left",0,1,1)
	love.graphics.printf("GEMS", 20,60,300,"left",0,1,1)
	love.graphics.printf(player.score, 20,20,150,"right",0,1,1)
	love.graphics.printf(world:formattime(world.time), 20,40,150,"right",0,1,1)
	love.graphics.printf(player.gems, 20,60,150,"right",0,1,1)
	
	love.graphics.printf("x"..player.lives, 20,love.graphics.getHeight()-40,50,"right",0,1,1)
	love.graphics.setFont(fonts.hud)
	
	love.graphics.draw(pickups.textures[2],20,love.graphics.getHeight()-40,0,0.5,0.5)
end


function world:timer(dt)
	if not world.complete then
		--update the world time
		world.time = world.time + 1 *dt	
	end
end


function world:formattime(n)
	return  
		string.format("%02d",n / 60 % 60) .. ":" .. 
		string.format("%02d",n % 60)
end

	
function world:reset()
	--clear all entities from the world
	--reinitialise default tables

	world.entities = {
		--maybe these should be swapped around
		--then use group name for entity info (editor)
		["material"] = {group = "materials"},
		["trap"] = {group = "traps"},
		["enemy"] = {group = "enemies"},
		["pickup"] = {group = "pickups"},
		["portal"] = {group = "portals"},
		["crate"] = {group = "crates"},
		["checkpoint"] = {group = "checkpoints"},
		["bumper"] = {group = "bumpers"},
		["spring"] = {group = "springs"},
		["platform"] = {group = "platform"},
		["prop"] = {group = "props"},
		["decal"] = {group = "decals"},
		["tip"] = {group = "tips"}

	}
end


function world:totalents()
	--return the total number of entities
	local c = 0
	for _, type in pairs(world.entities) do
		for _, e in pairs(type) do
			c = c + 1
		end
	end
	return c
end


function world:totalentsdrawn()
	--returns total drawn entities visible on screen
	return world.pickups+world.enemies+world.platforms+world.crates+
		world.checkpoints+world.portals+world.props+world.springs+world.decals+world.traps
end


function world:inview(entity) 
	local x,y = camera:toWorldCoords(entity.x,entity.y)
	
	if entity.swing then
		if (camera.x + love.graphics.getWidth()/2/camera.scale > entity.xorigin-entity.radius) 
		and (camera.x - love.graphics.getWidth()/2/camera.scale < entity.xorigin+entity.w+entity.radius)
		and (camera.y + love.graphics.getHeight()/2/camera.scale > entity.yorigin-entity.radius)
		and (camera.y - love.graphics.getHeight()/2/camera.scale < entity.yorigin+entity.h+entity.radius)
			then
			world.collision = world.collision +1
			return true
		end
	else
	
		--decides if the entity is visible to the camera
				
		if (camera.x + (love.graphics.getWidth()/2/camera.scale) > entity.x ) 
		and (camera.x - (love.graphics.getWidth()/2/camera.scale) < entity.x+entity.w)
		and (camera.y + (love.graphics.getHeight()/2/camera.scale) > entity.y)
		and (camera.y - (love.graphics.getHeight()/2/camera.scale) < entity.y+entity.h)
			then
			world.collision = world.collision +1
			return true
		end
	end
end



function world:update(dt)
	
	if not paused then 
		camera:update(dt)
		weather:update(dt)
		physics:world(dt)
		popups:update(dt)
		platforms:update(dt)
		player:update(dt)
		decals:update(dt)
		materials:update(dt)
		portals:update(dt)
		checkpoints:update(dt)
		springs:update(dt)
		pickups:update(dt)
		bumpers:update(dt)
		enemies:update(dt)
		tips:update(dt)
		
		world.collision = 0

		-- camera follows player
		if player.alive and not world.complete then
			camera:follow(player.x+player.w/2, player.y+player.h/2)
		end

		-- draw background
		if type(background) == "userdata" then
			background_scroll = background_scroll + background_scrollspeed * dt
			if background_scroll > background:getWidth()then
				background_scroll = background_scroll - background:getWidth()
			end
			background_quad:setViewport(camera.x/50-background_scroll,-camera.y/100,love.graphics.getWidth(),love.graphics.getHeight() )
		else
			background_scroll = 0
		end


		if mode == "game"  then
			--trigger world splash/act display
			if world.splash.opacity > 0 then 
				world.splash.timer = math.max(0, world.splash.timer - dt)
		
				if world.splash.timer <= 0 then
					world.splash.timer = 0
					world.splash.active = false
					world.splash.opacity = world.splash.opacity -world.splash.fadespeed *dt
					world.splash.text_y = world.splash.text_y + world.splash.fadespeed *dt
					world.splash.box_y = world.splash.box_y + world.splash.fadespeed*500 *dt
				end
				return 
			end
		
			--end of level (show scoreboard)
			if world.complete then
				world.scoreboard.opacity = math.min(1, world.scoreboard.opacity+world.scoreboard.fadespeed*dt)
				world.scoreboard.timer = math.max(0, world.scoreboard.timer - dt)
				if world.scoreboard.timer <= 0 then
					if world.nextmap == "title" then title:init() return end
					world.map = world.nextmap
					world:init("game")
				end
			else
				--check for activated "goal" entity
				for _,p in ipairs(world.entities.portal) do
					if p.type == "goal" and p.activated then
						world:endoflevel()
					end
				end
			end
		
		end
		world:timer(dt)
	
	end
end


function world:resetcamera()
	camera = Camera(camera.x,camera.y,love.graphics.getWidth(),love.graphics.getHeight(),love.graphics.getWidth() / default_width)
	camera:setFollowStyle('LOCKON')
	camera:setFollowLerp(0.065)
	--camera:setFollowLerp(0.2)
end


function world.savestate()
	world.score = player.score
	world.gems = player.gems
	world.state = table.deepcopy(world.entities)
end


function world.loadstate()
	player.score = world.score
	player.gems = world.gems
	world.entities = table.deepcopy(world.state)
end


function world:sendtoback(t,i)
	local item = t[i]
	table.remove(t,i)
	table.insert(t,1,item)

	console:print( t[i].group .. " (" .. i .. ") sent to back" )
end


function world:sendtofront(t,i)
	local item = t[i]
	table.remove(t,i)
	table.insert(t,#t,item)

	console:print( t[i].group .. " (" .. i .. ") sent to front" )
end
