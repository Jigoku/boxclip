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

decal_water = love.graphics.newImage("graphics/tiles/water.png")
decal_lava = love.graphics.newImage("graphics/tiles/lava.png")
decal_blood = love.graphics.newImage("graphics/tiles/blood.png")
decal_stream = love.graphics.newImage("graphics/tiles/stream.png")

decal_water_scroll = 100
decal_lava_scroll = 36
decal_blood_scroll = 80
decal_stream_scroll = 80

function decals:add(x,y,w,h,t)
	local gfx, scrollspeed
	
	if t == "blood" then
		gfx = decal_blood
		scrollspeed = decal_blood_scroll
	elseif t == "lava" then
		gfx = decal_lava
		scrollspeed = decal_lava_scroll
	elseif t == "stream" then
		gfx = decal_stream
		scrollspeed = decal_stream_scroll
	elseif t == "water" then
		gfx = decal_water
		scrollspeed = decal_water_scroll
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
		scrollspeed = scrollspeed,
		name = t,
		type = type,
		gfx = gfx,
		quad = love.graphics.newQuad( x,y,w,h, gfx:getDimensions() ) 

	})

end

function decals:update(dt)
	for i, decal in ipairs(self) do
		if type(decal.gfx) == "userdata" then
			decal.scroll = decal.scroll + (decal.scrollspeed * dt)
			if decal.scroll > decal.gfx:getHeight()then
				decal.scroll = decal.scroll - decal.gfx:getHeight()
			end
			decal.quad:setViewport(0,-decal.scroll, decal.w,decal.h )
		else
			decal.scroll = 0
		end
	end
	
end

function decals:draw()
	local count = 0
	

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




