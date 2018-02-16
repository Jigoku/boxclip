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
 
 springs = {}

spring_s = love.graphics.newImage("data/images/springs/spring_s2.png")
spring_m = love.graphics.newImage("data/images/springs/spring_m2.png")
spring_l = love.graphics.newImage("data/images/springs/spring_l2.png")

function springs:add(x,y,dir,type)

	if type == "spring_s" then
		vel = 1200
		gfx = spring_s
	elseif type == "spring_m" then
		vel = 1500
		gfx = spring_m
	elseif type == "spring_l" then
		vel = 1800
		gfx = spring_l
	end
	

	if dir == 0 or dir == 1 then
		width = gfx:getWidth()
		height = gfx:getHeight()
		end
	if dir == 2 or dir == 3 then
		width = gfx:getHeight()
		height = gfx:getWidth()
	end
	
	table.insert(world.entities, {
		--dimensions
		x = x or 0, 
		y = y or 0, 
		w = width,
		h = height,
		
		--properties
		name = "spring",
		typ = type,
		gfx = gfx,
		vel = vel,
		dir = dir,
	})
	print("spring added @  X:"..x.." Y: "..y)
	
end

function springs:draw()
	local count = 0
	
	for i, spring in ipairs(entities.match(world.entities,"spring")) do
		if world:inview(spring) then
			count = count +1
			love.graphics.setColor(255,255,255,255)
			if spring.dir == 0 then
				love.graphics.draw(spring.gfx, spring.x, spring.y, 0,1,1)
			elseif spring.dir == 1 then
				love.graphics.draw(spring.gfx, spring.x, spring.y, 0,1,-1,0,spring.h )
			elseif spring.dir == 2 then
				love.graphics.draw(spring.gfx, spring.x, spring.y, math.rad(90),1,1,0,spring.w )
			elseif spring.dir == 3 then
				love.graphics.draw(spring.gfx, spring.x, spring.y, math.rad(-90),-1,1 )
			end
			if editing or debug then
				springs:drawdebug(spring, i)
			end

		end
	end

	world.springs = count
end

function springs:drawdebug(spring, i)
	
	love.graphics.setColor(255,155,55,200)
	love.graphics.rectangle(
		"line", 
		spring.x, 
		spring.y, 
		spring.w, 
		spring.h
	)
	love.graphics.setColor(155,255,55,200)
	
	--offset for smaller collision, but unimplemented: TODO
	love.graphics.rectangle(
		"line", 
		spring.x+10, 
		spring.y+10, 
		spring.w-20, 
		spring.h-20
	)
	
	editor:drawid(spring, i)
	editor:drawcoordinates(spring)
end
