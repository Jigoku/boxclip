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
crate = love.graphics.newImage("graphics/crates/crate.png")

function crates:add(x,y,item)
	table.insert(crates, {
		x = x or 0,
		y = y or 0,
		w = 50,
		h = 50,
		name = "crate",
		item = item or nil,
		gfx = crate,
		destroyed = false,
		score = 50,
	})
	print( "crate added @  X:"..x.." Y: "..y)
end

function crates:addpickup(crate, i)
	--add the contents of destroyable to world if any
	if crate.item == "gem" then
		pickups:add(crate.x+crate.w/2-pickups.w/2, crate.y+crate.h/2-pickups.h/2, "gem")
	elseif crate.item == "life" then
		pickups:add(crate.x+crate.w/2-pickups.w/2, crate.y+crate.h/2-pickups.h/2, "life")
	end
end


function crates:draw()
	local count = 0
	
	local i, crate
	for i, crate in ipairs(crates) do		
		if world:inview(crate) and not crate.destroyed then
			count = count + 1
		
			love.graphics.setColor(crate_r,crate_g,crate_b,255)
			love.graphics.draw(crate.gfx,crate.x, crate.y, 0, 1, 1)
		
			if editing then
				self:drawDebug(crate, i)
			end
		end
	end
	world.crates = count
end

function crates:drawDebug(crate, i)
	love.graphics.setColor(0,255,255,100)
	love.graphics.rectangle("line", crate.x, crate.y, crate.w, crate.h)

	util:drawid(crate,i)
	util:drawCoordinates(crate)
end
