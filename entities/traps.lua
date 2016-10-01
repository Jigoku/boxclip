--[[
 * Copyright (C) 2016 Ricky K. Thomson
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
 
traps = {}

traps_textures = {
	["log"] = love.graphics.newImage("data/images/traps/log.png"),
	["bridge"] = love.graphics.newImage("data/images/traps/bridge.png"),
	["brick"] = love.graphics.newImage("data/images/traps/brick.png"),
}


function traps:add(x,y,type)

	local gfx = traps_textures[type]

	table.insert(traps, {
		--dimensions
		x = x or 0,
		y = y or 0,
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		--properties
		name = type,
		gfx = gfx,
		falling = false,
		timer = 0.05,
		mass = 800,
		xvel = 0,
		yvel = 0,
	})
	print(type .." added @  X:"..x.." Y: "..y)
	
end

function traps:draw()
	local count = 0
	
	for i, trap in ipairs(traps) do
		if world:inview(trap) then
			count = count +1
					
			love.graphics.setColor(255,255,255,255)

			
			love.graphics.draw(trap.gfx, trap.x,trap.y,0, 1, 1)

			if editing or debug then
				traps:drawDebug(trap, i)
			end

		end
	end

	world.traps = count
end


function traps:drawDebug(trap, i)
	love.graphics.setColor(255,0,155,100)
	love.graphics.rectangle(
		"line", 
		trap.x, 
		trap.y, 
		trap.gfx:getWidth(), 
		trap.gfx:getHeight()
	)
	
	editor:drawid(trap, i)
	editor:drawCoordinates(trap)
end


function traps:destroy(i)

end
