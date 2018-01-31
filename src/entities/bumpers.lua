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
bumpers.scalespeed =  10
bumpers.maxscale = 2

function bumpers:add(x,y)

	table.insert(self, {		
		--position
		x = x or 0,
		y = y or 0,
		w = self.textures[2]:getWidth(),
		h = self.textures[2]:getHeight(),
		
		--properties
		score = 250,
		force = 1000,
		name = "bumper",
		scale = 1,
		gfx = self.textures[2]
	})

end

function bumpers:update(dt)
	for i, bumper in ipairs(self) do
		if bumper.scale > 1 then
			bumper.scale = bumper.scale - bumpers.scalespeed *dt
			if bumper.scale <= 1 then
				bumper.scale = 1
			end
		end
	end
end

function bumpers:draw()
	local count = 0
	

	for i, bumper in ipairs(self) do
		if world:inview(bumper) then
			count = count + 1
			love.graphics.setColor(255,255,255,255)

			--offset for centred scaling
			local ox, oy = bumper.w *.5, bumper.h * .5

			love.graphics.draw(
				bumper.gfx, bumper.x+ox, bumper.y+oy, 0, 
				bumper.scale, bumper.scale,
				ox,oy	
			)

			if editing or debug then
				love.graphics.setColor(255,150,0,255)
				love.graphics.rectangle("line", bumper.x, bumper.y, bumper.w, bumper.h)
			
				editor:drawid(bumper,i)
				editor:drawcoordinates(bumper)
			end
		end
	end
	world.bumpers = count
end




