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
 
checkpoints = {}

checkpoints.textures = {
	["front"] = love.graphics.newImage("data/images/checkpoints/front.png"),
	["back"] = love.graphics.newImage("data/images/checkpoints/back.png")
}

function checkpoints:add(x,y)
	table.insert(world.entities.checkpoint, {
		x = x or 0,
		y = y or 0,
		w = self.textures["front"]:getWidth(),
		h = self.textures["front"]:getHeight(),
		group = "checkpoint",
		activated = false,
	})
	print( "checkpoint added @  X:"..x.." Y: "..y)
end

function checkpoints:draw()
	local count = 0
	
	local i, checkpoint
	for i, checkpoint in ipairs(world.entities.checkpoint) do
		if world:inview(checkpoint) then
		count = count + 1

			if not checkpoint.activated then
				love.graphics.setColor(255,100,100,245)
			else 
				love.graphics.setColor(150,255,150,245)
			end
			
			love.graphics.draw(checkpoints.textures["back"], checkpoint.x-checkpoints.textures["back"]:getWidth()/2+checkpoints.textures["front"]:getWidth()/2,checkpoint.y,0, 1, 1)
			love.graphics.draw(checkpoints.textures["front"], checkpoint.x,checkpoint.y,0, 1, 1)
	
			--love.graphics.rectangle("fill", checkpoint.x, checkpoint.y, checkpoint.w, checkpoint.h)
			
			if editing or debug then
				self:drawdebug(checkpoint, i)
			end
		end
	end
	world.checkpoints = count
end


function checkpoints:drawdebug(checkpoint, i)

	love.graphics.setColor(255,0,0,100)
	love.graphics.rectangle("line", checkpoint.x, checkpoint.y, checkpoint.w, checkpoint.h)
	
	editor:drawid(checkpoint,i)
	editor:drawcoordinates(checkpoint)
	
end

