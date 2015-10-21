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

goal = love.graphics.newImage("graphics/portals/goal.png")
goal_activated = love.graphics.newImage("graphics/portals/goal_activated.png")

function portals:add(x,y,type)
	if type == "spawn" then
		table.insert(portals, {
			--dimensions
			x = x or 0, -- xco-ord
			y = y or 0, -- yco-ord
			w = player.w, -- width
			h = player.h, -- height
			--properties
			name = "spawn",
		})
		print("spawn added @  X:"..x.." Y: "..y)
	elseif type == "goal" then
		table.insert(portals, {
			--dimensions
			x = x or 0, -- xco-ord
			y = y or 0, -- yco-ord
			w = 60, -- width
			h = 60, -- height
			--properties
			name = "goal",
			activated = false,
			gfx = goal
		})
		print("goal added @  X:"..x.." Y: "..y)
	end
end

function portals:draw()
	local count = 0
	
	for i, portal in ipairs(portals) do
		if world:inview(portal) then
		count = count + 1
				
			if portal.name == "goal" then
				love.graphics.setColor(255,255,255,255)
				if not portal.activated then	
					love.graphics.draw(portal.gfx, portal.x, portal.y, 0,1,1)
				else
					love.graphics.draw(goal_activated, portal.x, portal.y, 0,1,1)
				end
			end				
				
			if editing then
				--don't need to see spawn outside of editing
				if portal.name == "spawn" then
					love.graphics.setColor(255,100,0,100)
					love.graphics.rectangle("fill", portal.x,portal.y,portal.w,portal.h)
					love.graphics.setColor(255,0,0,255)
					love.graphics.rectangle("line", portal.x,portal.y,portal.w,portal.h)
				end
				portals:drawDebug(portal, i)
			end

		end
	end
	world.portals = count
end

function portals:drawDebug(portal, i)
	--requires graphic, implement all pickups as graphics/image
	util:drawid(portal, i)
	util:drawCoordinates(portal)
end
