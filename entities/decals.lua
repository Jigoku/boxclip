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
 
decals = {}

decals.textures = {
	water = love.graphics.newImage("graphics/tiles/water.png"),
	lava = love.graphics.newImage("graphics/tiles/lava.png"),
	blood = love.graphics.newImage("graphics/tiles/blood.png"),
	stream = love.graphics.newImage("graphics/tiles/stream.png"),
}




function decals:add(x,y,w,h,t)
	local gfx
	
	if t == "blood" then
		gfx = self.textures.blood
	elseif t == "lava" then
		gfx = self.textures.lava
	elseif t == "stream" then
		gfx = self.textures.stream
	elseif t == "water" then
		gfx = self.textures.water
	end
	gfx:setWrap("repeat", "repeat")
	
	table.insert(self, {		
		--position
		x = x or 0,
		y = y or 0,
		w = w or 10,
		h = h or 10,
		
		--properties
		scroll = 0,
		scrollspeed = 100,
		name = t,
		type = type,
		gfx = gfx,
		quad = love.graphics.newQuad( x,y,w,h, gfx:getDimensions() ) 

	})

end

function decals:update(dt)
		--scroll groundLevel
		
	for i, decal in ipairs(self) do
		if type(decal.gfx) == "userdata" then
			decal.scroll = decal.scroll + (decal.scrollspeed * dt)
			if decal.scroll > decal.gfx:getHeight()then
				decal.scroll = decal.scroll - decal.gfx:getHeight()
			end
			decal.quad:setViewport(0,-decal.scroll, decal.w,decal.h )
		else
			decal.scroll = 0
		end --]]
	end
	
end

function decals:draw()
	local count = 0
	
	local i, decal
	for i, decal in ipairs(self) do
		if world:inview(decal) then
			count = count + 1
			
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(decal.gfx, decal.quad, decal.x,decal.y)

			if editing or debug then
				util:drawid(decal,i)
				util:drawCoordinates(decal)
			end
		end
	end
	world.decals = count
end




