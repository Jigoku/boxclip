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

enemies.textures = {
	["walker"] = love.graphics.newImage( "data/images/enemies/walker.png"),
	["floater"] = love.graphics.newImage( "data/images/enemies/floater.png"),
	["spike"] = love.graphics.newImage( "data/images/enemies/spike.png"),
	["spike_large"] = love.graphics.newImage( "data/images/enemies/spike_large.png"),
	["icicle"] = love.graphics.newImage( "data/images/enemies/icicle.png"),
	["icicle_d"] = love.graphics.newImage( "data/images/enemies/icicle_d.png"),
	["spikeball"] = love.graphics.newImage( "data/images/enemies/spikeball.png"),
}





function enemies:add(x,y,movespeed,movedist,dir,type)

	if type == "walker" then
		table.insert(world.entities, {
			--movement
			movespeed = movespeed or 100,
			movedist = movedist or 200,
			movex = 1,
			dir = 0,
			--origin
			xorigin = x,
			yorigin = y,
			
			--position
			x = love.math.random(x,x+movedist) or 0,
			y = y or 0,
			
			--dimension
			w = self.textures[type]:getWidth(),
			h = self.textures[type]:getHeight(),
			
			--properties
			name = "enemy",
			type = type,
			mass = 800,
			xvel = 0,
			yvel = 0,
			dir = "right",
			alive = true,
			score = 230,
			newY = y,
			
			gfx = self.textures[type],
			
		})
		
	elseif type == "hopper" then
		table.insert(world.entities, {
			--movement
			movespeed = movespeed or 100,
			movedist = movedist or 200,
			movex = 0,
			dir = 0,
			--origin
			xorigin = x,
			yorigin = y,
			
			--position
			x = x or 0,
			y = y or 0,
			
			--dimension
			w = self.textures[type]:getWidth(),
			h = self.textures[type]:getHeight(),
			
			--properties
			name = "enemy",
			type = type,
			mass = 800,
			xvel = 0,
			yvel = 0,
			dir = "right",
			alive = true,
			score = 230,
			newY = y,
			
			gfx = self.textures[type],
			
		})

	elseif type == "spike" then
		if dir == 0 or dir == 1 then
			width = self.textures[type]:getWidth()
			height = self.textures[type]:getHeight()
		end
		if dir == 2 or dir == 3 then
			width = self.textures[type]:getHeight()
			height = self.textures[type]:getWidth()
		end
		table.insert(world.entities, {		
			--position
			x = x or 0,
			y = y or 0,
			xorigin = x,
			yorigin = y,
			
			--dimension
			w = width,
			h = height,
			
			--properties
			name = "enemy",
			type = type,
			alive = true,
			movedist = 0,
			gfx = self.textures[type],
			dir = dir,
			movespeed = 0,
			movedist = 0,
			
		})

	elseif type == "spike_large" then
		if dir == 0 or dir == 1 then
			width = self.textures[type]:getWidth()
			height = self.textures[type]:getHeight()
		end
		if dir == 2 or dir == 3 then
			width = self.textures[type]:getHeight()
			height = self.textures[type]:getWidth()
		end
		table.insert(world.entities, {		
			--position
			x = x or 0,
			y = y or 0,
			xorigin = x,
			yorigin = y,
			
			--dimension
			w = width,
			h = height,
			
			--properties
			name = "enemy",
			type = type,
			alive = true,
			movedist = 0,
			movespeed = 0,
			gfx = self.textures[type],
			dir = dir
			
		})

	elseif type == "icicle" then
		table.insert(world.entities, {		
			--position
			x = x or 0,
			y = y or 0,
			xorigin = x,
			yorigin = y,
			
			--dimension
			w = self.textures[type]:getWidth(),
			h = self.textures[type]:getHeight(),
			
			--properties
			name = "enemy",
			type = type,
			alive = true,
			falling = false,
			mass = 800,
			gfx = self.textures[type],
			yvel = 0,
			jumping = 0,
			movespeed = 0,
			movedist = 0,
			dir = 0,
		})

	elseif type == "floater" then
		table.insert(world.entities, {
			--movement
			movespeed = movespeed or 100,
			movedist = movedist or 400,
			movex = 1,
			--origin
			xorigin = x,
			yorigin = y,

			--position
			x = love.math.random(x,x+movedist) or 0,
			y = y or 0,
		
			--dimension
			w = self.textures[type]:getWidth(),
			h = self.textures[type]:getHeight(),
		
			--properties
			name = "enemy",
			type = type,
			mass = 0,
			xvel = 0,
			yvel = 0,
			dir = 0,

			alive = true,
			score = 350,
			--newY = y,
			
			gfx = self.textures[type],
		
		})
	
	elseif type == "spikeball" then
		table.insert(world.entities, {
		
			gfx = self.textures[type],
			w = self.textures[type]:getWidth(),
			h = self.textures[type]:getHeight(),
			xorigin = x,
			yorigin = y,
			x = x or 0,
			y = y or 0,
			
			--properties
			name = "enemy",
			type = type,
			speed = 3,
			alive = true,
			swing = 1,
			angle = 0,
			radius = 200,
			movespeed = 0,
			movedist = 0,
			dir = 0,
		})
	end
	print( type .. " added @  X:"..x.." Y: "..y)
end


function enemies:draw()
	local count = 0

	for i, enemy in ipairs(entities.match(world.entities,"enemy")) do
		if enemy.alive and world:inview(enemy) then
			count = count + 1
				
			if enemy.type == "walker" or enemy.type == "floater" then
				love.graphics.setColor(255,255,255,255)
				--love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.w, enemy.h)
				if enemy.movespeed < 0 then
					love.graphics.draw(enemy.gfx, enemy.x, enemy.y, 0, 1, 1)
				elseif enemy.movespeed > 0 then
					love.graphics.draw(enemy.gfx, enemy.x+enemy.gfx:getWidth(), enemy.y, 0, -1, 1)
				end
			end
			
			love.graphics.setColor(255,255,255,255)
			if enemy.type == "spike" or enemy.type == "spike_large" then
			
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
			
			if enemy.type == "icicle" then
				love.graphics.draw(enemy.gfx, enemy.x, enemy.y, 0,1,1)
			end
			
			if enemy.type == "spikeball" then
				platforms:drawlink(enemy)
				love.graphics.draw(enemy.gfx, enemy.x, enemy.y, -enemy.angle*2,1,1,enemy.w/2,enemy.h/2)
			end
			
			if editing or  debug then
				enemies:drawdebug(enemy, i)
			end
		end
	end
	world.enemies = count
end


function enemies:drawdebug(enemy, i)

	if enemy.type == "spikeball" then
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
	if enemy.type == "walker" or enemy.type == "floater" then
		
		love.graphics.setColor(255,0,255,50)
		love.graphics.rectangle("fill", enemy.xorigin, enemy.y, enemy.movedist+enemy.gfx:getWidth(), enemy.gfx:getHeight())
		love.graphics.setColor(255,0,255,255)
		love.graphics.rectangle("line", enemy.xorigin, enemy.y, enemy.movedist+enemy.gfx:getWidth(), enemy.gfx:getHeight())
	end

	
	editor:drawid(enemy,i)
	editor:drawcoordinates(enemy)
end






