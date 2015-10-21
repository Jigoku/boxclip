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

walker = love.graphics.newImage( "graphics/enemies/walker.png")
floater = love.graphics.newImage( "graphics/enemies/floater.png")

spike = love.graphics.newImage( "graphics/enemies/spike.png")
spike_winter = love.graphics.newImage( "graphics/enemies/spike_winter.png")
spike_hell = love.graphics.newImage( "graphics/enemies/spike_hell.png")
spike_forest = love.graphics.newImage( "graphics/enemies/spike_forest.png")

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
		height = 30
	end
	if dir == 2 or dir == 3 then
		width = 30
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
			if enemy.name == "spike" then
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
			
			if editing then
				enemies:drawDebug(enemy, i)
			end
		end
	end
	world.enemies = count
end


function enemies:drawDebug(enemy, i)
	--bounds
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
	--hitbox
	love.graphics.setColor(255,200,100,255)
	love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)
	
	if enemy.name == "walker" or enemy.name == "floater" then
		--waypoint
		love.graphics.setColor(255,0,255,100)
		love.graphics.rectangle("line", enemy.xorigin, enemy.y, enemy.movedist+enemy.w, enemy.h)
	end
	
	util:drawid(enemy,i)
	util:drawCoordinates(enemy)
end




