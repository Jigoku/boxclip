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
		})
	end
	
	print(type .. " added @  X:"..x.." Y: "..y)
end

function portals:draw()
	local count = 0
	
	for i, portal in ipairs(world.entities.portal) do
		if world:inview(portal) then
		count = count + 1
				
			if portal.type == "goal" then
				love.graphics.setColor(255,255,255,255)
				
				love.graphics.draw(self.textures[portal.type], portal.x, portal.y, 0,1,1)
				
				if portal.activated then	
					--debug
					love.graphics.setFont(fonts.large)
					love.graphics.setColor(255,0,0,255)
					love.graphics.print("next map in: " .. math.round(world.scoreboard.timer,0),portal.x-10,portal.y-20)
					love.graphics.setFont(fonts.default)
				end
			end				
				
			if editing or debug then
				self:drawdebug(portal, i)
			end

		end
	end
	world.portals = count
end

function portals:drawdebug(portal, i)
	love.graphics.setColor(255,100,0,50)
	love.graphics.rectangle("fill", portal.x,portal.y,portal.w,portal.h)
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("line", portal.x,portal.y,portal.w,portal.h)
	
	editor:drawid(portal, i)
	editor:drawcoordinates(portal)
	
end



