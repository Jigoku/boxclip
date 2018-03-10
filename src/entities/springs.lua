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

springs.textures = {
	["spring_s"] = love.graphics.newImage("data/images/springs/spring_s2.png"),
	["spring_m"] = love.graphics.newImage("data/images/springs/spring_m2.png"),
	["spring_l"] = love.graphics.newImage("data/images/springs/spring_l2.png"),
}

function springs:add(x,y,dir,type)

	if type == "spring_s" then
		vel = 1200
	elseif type == "spring_m" then
		vel = 1500
	elseif type == "spring_l" then
		vel = 1800
	end
	
	local w,h

	if dir == 0 or dir == 2 then
		w = self.textures[type]:getWidth()
		h = self.textures[type]:getHeight()
	end
	if dir == 3 or dir == 1 then
		w = self.textures[type]:getHeight()
		h = self.textures[type]:getWidth()
	end
	
	table.insert(world.entities.spring, {
		--dimensions
		x = x or 0, 
		y = y or 0, 
		w = w,
		h = h,
		
		--properties
		group = "spring",
		type = type,
		vel = vel,
		dir = dir,
		
		editor_canrotate = true,
	})
	print("spring added @  X:"..x.." Y: "..y)
	
end

function springs:draw()
	local count = 0
	
	for i, spring in ipairs(world.entities.spring) do
		if world:inview(spring) then
			count = count +1
			love.graphics.setColor(255,255,255,255)
				
			local texture = self.textures[spring.type]
			if spring.dir == 1 then
				love.graphics.draw(texture, spring.x, spring.y, math.rad(90),1,(spring.flip and -1 or 1),0,(spring.flip and 0 or spring.w))
			elseif spring.dir == 2 then
				love.graphics.draw(texture, spring.x, spring.y, 0,(spring.flip and 1 or -1),-1,(spring.flip and 0 or spring.w),spring.h)	
			elseif spring.dir == 3 then
				love.graphics.draw(texture, spring.x, spring.y, math.rad(-90),1,(spring.flip and -1 or 1),spring.h,(spring.flip and spring.w or 0))
			else
				love.graphics.draw(texture, spring.x, spring.y, 0,(spring.flip and -1 or 1),1,(spring.flip and spring.w or 0),0,0)
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
