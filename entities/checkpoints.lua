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
 
 checkpoints = {}


function checkpoints:add(x,y)
	table.insert(checkpoints, {
		x = x or 0,
		y = y or 0,
		w = 5,
		h = 50,
		name = "checkpoint",
		activated = false
	})
	print( "checkpoint added @  X:"..x.." Y: "..y)
end

function checkpoints:draw()
	local count = 0
	
	local i, checkpoint
	for i, checkpoint in ipairs(checkpoints) do
		if world:inview(checkpoint) then
		count = count + 1

			if not checkpoint.activated then
				love.graphics.setColor(255,255,255,100)
			else 
				love.graphics.setColor(200,200,200,255)
			end
			love.graphics.rectangle("fill", checkpoint.x, checkpoint.y, checkpoint.w, checkpoint.h)	
			
			if editing then
				self:drawDebug(checkpoint, i)
			end
		end
	end
	world.checkpoints = count
end


function checkpoints:drawDebug(checkpoint, i)

	-- collision area
	love.graphics.setColor(255,0,0,100)
	love.graphics.rectangle("line", checkpoint.x, checkpoint.y, checkpoint.w, checkpoint.h)
	
	util:drawid(checkpoint,i)
	util:drawCoordinates(checkpoint)
	
end

