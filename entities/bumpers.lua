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
 
bumpers = {}

bumpers.textures = textures:load("data/images/bumpers/")

function bumpers:add(x,y)

	table.insert(self, {		
		--position
		x = x or 0,
		y = y or 0,
		w = self.textures[2]:getWidth(),
		h = self.textures[2]:getHeight(),
		
		--properties
		score = 250,
		force = 1250,
		name = "bumper",
		gfx = self.textures[2]
	})

end

function bumpers:update(dt)
	for i, bumper in ipairs(self) do
		--[[
			animate on collision
		--]]
	end
	
end

function bumpers:draw()
	local count = 0
	

	for i, bumper in ipairs(self) do
		if world:inview(bumper) then
			count = count + 1
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(bumper.gfx, bumper.x,bumper.y)

			if editing or debug then
				love.graphics.setColor(255,150,0,255)
				love.graphics.rectangle("line", bumper.x, bumper.y, bumper.w, bumper.h)
			
				editor:drawid(bumper,i)
				editor:drawCoordinates(bumper)
			end
		end
	end
	world.bumpers = count
end




