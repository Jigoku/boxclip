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
 
crates = {}
crate = love.graphics.newImage("data/images/crates/crate.png")

function crates:add(x,y,type)
	table.insert(world.entities.crate, {
		x = x or 0,
		y = y or 0,
		w = 50,
		h = 50,
		group = "crate",
		type = type or nil,
		gfx = crate,
		destroyed = false,
		score = 50,
		mass = 300,
		yvel = 0,
	})
	print( "crate added @  X:"..x.." Y: "..y)
end




function crates:draw()
	local count = 0
	
	local i, crate
	for i, crate in ipairs(world.entities.crate) do		
		if world:inview(crate) and not crate.destroyed then
			count = count + 1
		
			love.graphics.setColor(crate_r,crate_g,crate_b,255)
			love.graphics.draw(crate.gfx,crate.x, crate.y, 0, 1, 1)
		
			if editing or debug then
				self:drawdebug(crate, i)
			end
		end
	end
	world.crates = count
end

function crates:drawdebug(crate, i)
	love.graphics.setColor(0,255,255,100)
	love.graphics.rectangle("line", crate.x, crate.y, crate.w, crate.h)

	editor:drawid(crate,i)
	editor:drawcoordinates(crate)
end
