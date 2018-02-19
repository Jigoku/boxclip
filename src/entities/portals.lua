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
 
 portals = {}



portals.textures = {
	["goal"] = love.graphics.newImage("data/images/portals/goal.png"),
	["goal_activated"] = love.graphics.newImage("data/images/portals/goal_activated.png"),
}

function portals:add(x,y,type)
	if type == "spawn" then
		table.insert(world.entities.portal, {
			--dimensions
			x = x or 0,
			y = y or 0,
			w = player.w,
			h = player.h,
			--properties
			group = "portal",
			type = type,
		})
	
	elseif type == "goal" then
		table.insert(world.entities.portal, {
			--dimensions
			x = x or 0,
			y = y or 0,
			w = self.textures[type]:getWidth(),
			h = self.textures[type]:getHeight(),
			--properties
			group = "portal",
			type = type,
			activated = false,
			gfx = self.textures[type],
			timer = 12
		})
	end
	
	print(type .. " added @  X:"..x.." Y: "..y)
end

function portals:draw()
	local count = 0
	
	for i, p in ipairs(world.entities.portal) do
		if world:inview(p) then
		count = count + 1
				
			if p.type == "goal" then
				love.graphics.setColor(255,255,255,255)
				
				love.graphics.draw(p.gfx, p.x, p.y, 0,1,1)
				
				if p.activated then	
					--debug
					love.graphics.setFont(fonts.large)
					love.graphics.setColor(255,0,0,255)
					love.graphics.print("next map in: " .. math.round(p.timer,0),p.x-10,p.y-20)
					love.graphics.setFont(fonts.default)
				end
			end				
				
			if editing or debug then
				self:drawdebug(p, i)
			end

		end
	end
	world.portals = count
end

function portals:drawdebug(p, i)
	love.graphics.setColor(255,100,0,50)
	love.graphics.rectangle("fill", p.x,p.y,p.w,p.h)
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("line", p.x,p.y,p.w,p.h)
	
	editor:drawid(p, i)
	editor:drawcoordinates(p)
	
end


function portals:update(dt)
	if world.nextmap then

		for _,p in ipairs(world.entities.portal) do
			if p.type == "goal" and p.activated then
				p.timer = math.max(0, p.timer - dt)
				
				if p.timer <= 0 then
					if world.nextmap == "title" then title:init() return end
					world.map = world.nextmap
					world:init("game")
					player.gems = 0
				end
		
			end
		end
		
	end	
end
