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
 
enemies = {}

walker = love.graphics.newImage( "data/images/enemies/walker.png")
floater = love.graphics.newImage( "data/images/enemies/floater.png")

spike = love.graphics.newImage( "data/images/enemies/spike.png")
spike_winter = love.graphics.newImage( "data/images/enemies/spike_winter.png")
spike_hell = love.graphics.newImage( "data/images/enemies/spike_hell.png")

spike_large = love.graphics.newImage( "data/images/enemies/spike_large.png")
spike_large_winter = love.graphics.newImage( "data/images/enemies/spike_large_winter.png")
spike_large_hell = love.graphics.newImage( "data/images/enemies/spike_large_hell.png")

icicle = love.graphics.newImage( "data/images/enemies/icicle.png")
icicle_winter = love.graphics.newImage( "data/images/enemies/icicle_winter.png")
icicle_hell = love.graphics.newImage( "data/images/enemies/icicle_hell.png")

icicle_d = love.graphics.newImage( "data/images/enemies/icicle_d.png")
icicle_d_winter = love.graphics.newImage( "data/images/enemies/icicle_d_winter.png")
icicle_d_hell = love.graphics.newImage( "data/images/enemies/icicle_d_hell.png")

spikeball = love.graphics.newImage( "data/images/enemies/spikeball.png")


function enemies:walker(x,y,movespeed,movedist)
	table.insert(enemies, {
		--movement
		movespeed = movespeed or 100,
		movedist = movedist or 200,
		movex = 1,
		--origin
		xorigin = x,
		yorigin = y,
		
		--position
		x = math.random(x,x+movedist) or 0,
		y = y or 0,
		
		--dimension
		w = 30,
		h = 30,
		
		--properties
		name = "walker",
		mass = 800,
		xvel = 0,
		yvel = 0,
		dir = "right",
		alive = true,
		score = 230,
		newY = y,
		
		gfx = walker,
		
	})
	print( "walker added @  X:"..x.." Y: "..y)
end


function enemies:spike(x,y,dir)

	if dir == 0 or dir == 1 then
		width = 80
		height = 50
	end
	if dir == 2 or dir == 3 then
		width = 50
		height = 80
	end
	table.insert(enemies, {		
		--position
		x = x or 0,
		y = y or 0,
		xorigin = x,
		yorigin = y,
		
		--dimension
		w = width,
		h = height,
		
		--properties
		name = "spike",
		alive = true,
		movedist = 0,
		gfx = spike_gfx,
		dir = dir
		
	})
	print( "spike added @  X:"..x.." Y: "..y)
end


function enemies:spike_large(x,y,dir)

	if dir == 0 or dir == 1 then
		width = 160
		height = 50
	end
	if dir == 2 or dir == 3 then
		width = 50
		height = 160
	end
	table.insert(enemies, {		
		--position
		x = x or 0,
		y = y or 0,
		xorigin = x,
		yorigin = y,
		
		--dimension
		w = width,
		h = height,
		
		--properties
		name = "spike_large",
		alive = true,
		movedist = 0,
		gfx = spike_large_gfx,
		dir = dir
		
	})
	print( "spike_large added @  X:"..x.." Y: "..y)
end

function enemies:icicle(x,y)
	table.insert(enemies, {		
		--position
		x = x or 0,
		y = y or 0,
		xorigin = x,
		yorigin = y,
		
		--dimension
		w = 20,
		h = 50,
		
		--properties
		name = "icicle",
		alive = true,
		falling = false,
		mass = 800,
		gfx = icicle_gfx,
		yvel = 0,
		jumping = 0,
		
	})
	print( "icicle added @  X:"..x.." Y: "..y)
end

function enemies:floater(x,y,movespeed,movedist)
	table.insert(enemies, {
		--movement
		movespeed = movespeed or 100,
		movedist = movedist or 400,
		movex = 1,
		--origin
		xorigin = x,
		yorigin = y,
		
		--position
		x = math.random(x,x+movedist) or 0,
		y = y or 0,
		
		--dimension
		w = 50,
		h = 40,
		
		--properties
		name = "floater",
		mass = 0,
		xvel = 0,
		yvel = 0,
		dir = "right",
		alive = true,
		score = 350,
		--newY = y,
		
		gfx = floater,
		
	})
	print( "walker added @  X:"..x.." Y: "..y)
end

function enemies:spikeball(x,y)
	table.insert(enemies, {
		
		gfx = spikeball,
		
		--dimension
		w = 70,
		h = 70,
		--origin
		xorigin = x,
		yorigin = y,
		
		--position
		x = x or 0,
		y = y or 0,
		

		
		--properties
		name = "spikeball",
		
		speed = 2,
		alive = true,
		--newY = y,
		swing = 1,
		angle = 0,
		radius = 200,

	})
	print( "spikeball added @  X:"..x.." Y: "..y)
end

function enemies:draw()
	local count = 0
	
	local i, enemy
	

	
	for i, enemy in ipairs(enemies) do
		if type(enemy) == "table" and enemy.alive and world:inview(enemy) then
			count = count + 1
				
			if enemy.name == "walker" or enemy.name == "floater" then
				love.graphics.setColor(255,255,255,255)
				--love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.w, enemy.h)
				if enemy.movespeed < 0 then
					love.graphics.draw(enemy.gfx, enemy.x, enemy.y, 0, 1, 1)
				elseif enemy.movespeed > 0 then
					love.graphics.draw(enemy.gfx, enemy.x+enemy.gfx:getWidth(), enemy.y, 0, -1, 1)
				end
			end
			
			love.graphics.setColor(255,255,255,255)
			if enemy.name == "spike" or enemy.name == "spike_large" then
			
				if enemy.dir == 0 then
					love.graphics.draw(enemy.gfx, enemy.x, enemy.y, 0,1,1)
				elseif enemy.dir == 1 then
					love.graphics.draw(enemy.gfx, enemy.x, enemy.y, 0,1,-1,0,enemy.h )
				elseif enemy.dir == 2 then
					love.graphics.draw(enemy.gfx, enemy.x, enemy.y, math.rad(90),1,1,0,enemy.w )
				elseif enemy.dir == 3 then
					love.graphics.draw(enemy.gfx, enemy.x, enemy.y, math.rad(-90),-1,1 )
				end
			end
			
			if enemy.name == "icicle" then
				love.graphics.draw(enemy.gfx, enemy.x, enemy.y, 0,1,1)
			end
			
			if enemy.name == "spikeball" then
				platforms:drawlink(enemy)
				love.graphics.draw(enemy.gfx, enemy.x-enemy.gfx:getWidth()/2, enemy.y-enemy.gfx:getHeight()/2, 0,1,1)
			end
			
			if editing or debug then
				enemies:drawDebug(enemy, i)
			end
		end
	end
	world.enemies = count
end


function enemies:drawDebug(enemy, i)

	if enemy.name == "spikeball" then
		--bounds
		love.graphics.setColor(255,0,0,255)
		love.graphics.rectangle("line", enemy.x-enemy.gfx:getWidth()/2+5, enemy.y-enemy.gfx:getHeight()/2+5, enemy.gfx:getWidth()-10, enemy.gfx:getHeight()-10)
		--hitbox
		love.graphics.setColor(255,200,100,255)
		love.graphics.rectangle("line", enemy.x-enemy.gfx:getWidth()/2, enemy.y-enemy.gfx:getHeight()/2, enemy.gfx:getWidth(), enemy.gfx:getHeight())

		--waypoint
		love.graphics.setColor(255,0,255,100)
		love.graphics.line(enemy.xorigin,enemy.yorigin,enemy.x,enemy.y)	
		love.graphics.circle("line", enemy.xorigin,enemy.yorigin, enemy.radius,enemy.radius)	
		
		--selectable area in editor
		love.graphics.setColor(255,0,0,100)
		love.graphics.rectangle("line", 
			enemy.xorigin-platform_link_origin:getWidth()/2,enemy.yorigin-platform_link_origin:getHeight()/2,
			platform_link_origin:getWidth(),platform_link_origin:getHeight()
		)

	else
	--all other enemies
		--bounds
		love.graphics.setColor(255,0,0,255)
		love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
		--hitbox
		love.graphics.setColor(255,200,100,255)
		love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)
	end

	--waypoint	
	if enemy.name == "walker" or enemy.name == "floater" then
		
		love.graphics.setColor(255,0,255,50)
		love.graphics.rectangle("fill", enemy.xorigin, enemy.y, enemy.movedist+enemy.gfx:getWidth(), enemy.gfx:getHeight())
		love.graphics.setColor(255,0,255,255)
		love.graphics.rectangle("line", enemy.xorigin, enemy.y, enemy.movedist+enemy.gfx:getWidth(), enemy.gfx:getHeight())
	end

	
	editor:drawid(enemy,i)
	editor:drawCoordinates(enemy)
end



function enemies:die(enemy)
	enemy.alive = false
	sound:play(sound.effects["kill"])
	console:print(enemy.name .." killed")	
end
