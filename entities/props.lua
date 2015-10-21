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
 
 props = {}

flower = love.graphics.newImage("graphics/props/flower.png")
rock = love.graphics.newImage("graphics/props/rock.png")


function props:add(x,y,type)
	if type == "flower" then
		table.insert(props, {
			--dimensions
			x = x or 0, -- xco-ord
			y = y or 0, -- yco-ord
			w = 20, -- width
			h = 40, -- height
			--properties
			name = "flower",
			gfx = flower,
		})
		print("flower added @  X:"..x.." Y: "..y)
	end
	if type == "rock" then
		table.insert(props, {
			--dimensions
			x = x or 0, -- xco-ord
			y = y or 0, -- yco-ord
			w = 80, -- width
			h = 50, -- height
			--properties
			name = "rock",
			gfx = rock,
		})
		print("rock added @  X:"..x.." Y: "..y)
	end

end

function props:draw()
	local count = 0
	
	for i, prop in ipairs(props) do
		if world:inview(prop) then
			count = count +1
				
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(prop.gfx, prop.x,prop.y,0, 1, 1)

			if editing then
				props:drawDebug(prop, i)
			end

		end
	end

	world.props = count
end

function props:drawDebug(prop, i)
	--requires graphic, implement all pickups as graphics/image
	love.graphics.setColor(255,0,155,100)
	love.graphics.rectangle(
		"line", 
		prop.x, 
		prop.y, 
		prop.gfx:getWidth(), 
		prop.gfx:getHeight()
	)
	
	if prop.name == "spring" then
		love.graphics.setColor(155,255,55,200)
		love.graphics.rectangle(
			"line", 
			prop.x+10, 
			prop.y+10, 
			prop.gfx:getWidth()-20, 
			prop.gfx:getHeight()-20
		)
	end
	
	util:drawid(prop, i)
	util:drawCoordinates(prop)
end
