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

--maybe create "textures" class to load all of these? 
-- textures.props, textures.platforms etc. ???
-- as props.textures will be erased when props is reset
props_textures = {
	["flower"] = love.graphics.newImage("data/images/props/flower.png"),
	["grass"] = love.graphics.newImage("data/images/props/grass.png"),
	["rock"] = love.graphics.newImage("data/images/props/rock.png"),
	["tree"] = love.graphics.newImage("data/images/props/tree.png"),
	["arch"] = love.graphics.newImage("data/images/props/arch.png"),
	["arch2"] = love.graphics.newImage("data/images/props/arch2.png"),
	["pillar"] = love.graphics.newImage("data/images/props/pillar.png"),
	["log"] = love.graphics.newImage("data/images/tiles/log2.png"),
	["mesh"] = love.graphics.newImage("data/images/props/mesh.png"),
	["girder"] = love.graphics.newImage("data/images/props/girder.png")
}



function props:add(x,y,type)

	local gfx = props_textures[type]
	
	--fix this
	-- log should be moved to "traps" when class is impleneted
	if type == "log" then
		table.insert(props, {
			--dimensions
			x = x or 0,
			y = y or 0,
			w = gfx:getWidth(),
			h = gfx:getHeight(),
			--properties
			name = "log",
			gfx = gfx,
			falling = false,
			timer = 0.05,
			mass = 800,
			yvel = 0,
		})
		print("log added @  X:"..x.." Y: "..y)
		return
	end
	
	table.insert(props, {
		--dimensions
		x = x or 0, 
		y = y or 0,
		w = gfx:getWidth(),
		h = gfx:getHeight(),
		--properties
		name = type,
		gfx = gfx,
	})
	print(type .. " added @  X:"..x.." Y: "..y)

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
	
	editor:drawid(prop, i)
	editor:drawCoordinates(prop)
end
