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

flower_gfx = love.graphics.newImage("graphics/props/flower.png")
rock_gfx = love.graphics.newImage("graphics/props/rock.png")
tree_gfx = love.graphics.newImage("graphics/props/tree.png")
arch_gfx = love.graphics.newImage("graphics/props/arch.png")
arch2_gfx = love.graphics.newImage("graphics/props/arch2.png")
pillar_gfx = love.graphics.newImage("graphics/props/pillar.png")
log_gfx = love.graphics.newImage("graphics/tiles/log.png")


function props:add(x,y,type)
	if type == "flower" then
		table.insert(props, {
			--dimensions
			x = x or 0, 
			y = y or 0,
			w = 20, 
			h = 40,
			--properties
			name = "flower",
			gfx = flower_gfx,
		})
		print("flower added @  X:"..x.." Y: "..y)
	end
	if type == "rock" then
		table.insert(props, {
			--dimensions
			x = x or 0,
			y = y or 0,
			w = 80,
			h = 50,
			--properties
			name = "rock",
			gfx = rock_gfx,
		})
		print("rock added @  X:"..x.." Y: "..y)
	end
	if type == "tree" then
		table.insert(props, {
			--dimensions
			x = x or 0, 
			y = y or 0, 
			w = 100, 
			h = 200, 
			--properties
			name = "tree",
			gfx = tree_gfx,
		})
		print("tree added @  X:"..x.." Y: "..y)
	end
	if type == "arch" then
		table.insert(props, {
			--dimensions
			x = x or 0,
			y = y or 0,
			w = 90,
			h = 250,
			--properties
			name = "arch",
			gfx = arch_gfx,
		})
		print("arch added @  X:"..x.." Y: "..y)
	end
	if type == "arch2" then
		table.insert(props, {
			--dimensions
			x = x or 0, 
			y = y or 0, 
			w = 400,
			h = 200,
			--properties
			name = "arch2",
			gfx = arch2_gfx,
		})
		print("arch2 added @  X:"..x.." Y: "..y)
	end
	if type == "pillar" then
		table.insert(props, {
			--dimensions
			x = x or 0,
			y = y or 0,
			w = 40,
			h = 160,
			--properties
			name = "pillar",
			gfx = pillar_gfx,
		})
		print("pillar added @  X:"..x.." Y: "..y)
	end
	if type == "log" then
		table.insert(props, {
			--dimensions
			x = x or 0,
			y = y or 0,
			w = 30,
			h = 30,
			--properties
			name = "log",
			gfx = log_gfx,
		})
		print("log added @  X:"..x.." Y: "..y)
	end
	
end

function props:draw()
	local count = 0
	
	for i, prop in ipairs(props) do
		if world:inview(prop) then
			count = count +1
				
			if prop.name == "arch" or prop.name == "arch2" then
				love.graphics.setColor(
					platform_r,
					platform_g,
					platform_b,
					255
				)	
			else				
				love.graphics.setColor(255,255,255,255)
			end
			
			love.graphics.draw(prop.gfx, prop.x,prop.y,0, 1, 1)

			if editing or debug then
				props:drawDebug(prop, i)
			end

		end
	end

	world.props = count
end

function props:drawDebug(prop, i)
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
