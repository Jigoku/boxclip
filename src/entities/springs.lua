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
 
springs = {}

springs.path = "data/images/springs/"
springs.list = {}
for _,spring in ipairs(love.filesystem.getDirectoryItems(springs.path)) do
	local name = spring:match("^(.+)%..+$")
	table.insert(springs.list, name)
	table.insert(editor.entities, {name, "spring"})
end

springs.textures = textures:load(springs.path)

function springs:add(x,y,dir,type)
	for i,spring in ipairs(springs.list) do
		if spring == type then
			if type == "spring_s" then
				vel = 1200
			elseif type == "spring_m" then
				vel = 1500
			elseif type == "spring_l" then
				vel = 1800
			end
	
			local w,h

			if dir == 0 or dir == 2 then
				w = self.textures[i]:getWidth()
				h = self.textures[i]:getHeight()
			end
			if dir == 3 or dir == 1 then
				w = self.textures[i]:getHeight()
				h = self.textures[i]:getWidth()
			end
	
			table.insert(world.entities.spring, {
				--dimensions
				x = x or 0, 
				y = y or 0, 
				w = w,
				h = h,
				
				--properties
				group = "spring",
				slot = i,
				type = type,
				vel = vel,
				dir = dir,
				
				editor_canrotate = true,
			})
			print("spring added @  X:"..x.." Y: "..y)
			return
		end
	end
	
end

function springs:update(dt)
	if editing then return end
	for _, spring in ipairs(world.entities.spring) do
		if world:inview(spring) then
			if collision:check(player.x,player.y,player.w,player.h,
				spring.x, spring.y,spring.w,spring.h) then
				player.jumping = true
				joystick:vibrate(1,1,0.25)
				sound:play(sound.effects["spring"])
				if spring.dir == 0 then
					player.y = spring.y-player.h -1 *dt
					player.yvel =  spring.vel
				elseif spring.dir == 2 then
					player.y = spring.y +spring.h +1 *dt
					player.yvel = -spring.vel
				elseif spring.dir == 1 then
					player.x = spring.x +spring.w +1 *dt
					player.xvel = spring.vel
				elseif spring.dir == 3 then
					player.x = spring.x -player.w -1 *dt
					player.xvel = -spring.vel
				end
			end
		end
	end
end

function springs:draw()
	local count = 0
	
	for i, spring in ipairs(world.entities.spring) do
		if world:inview(spring) then
			count = count +1
			love.graphics.setColor(1,1,1,1)
				
			local texture = self.textures[spring.slot]
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
	
	love.graphics.setColor(1,0.60,0.21,0.78)
	love.graphics.rectangle(
		"line", 
		spring.x, 
		spring.y, 
		spring.w, 
		spring.h
	)
	love.graphics.setColor(0.60,1,0.21,0.78)
	
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
