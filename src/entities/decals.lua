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
	["water"] = love.graphics.newImage("data/images/decals/water.png"),
	["lava"] = love.graphics.newImage("data/images/decals/lava.png"),
	["blood"] = love.graphics.newImage("data/images/decals/blood.png"),
	["stream"] = love.graphics.newImage("data/images/decals/stream.png"),
	["waterfall"] = love.graphics.newImage("data/images/decals/waterfall.png"),
	["snowflake"] = love.graphics.newImage("data/images/decals/snowflake.png"),
}


decals.waterfallspin = 0
decal_water_scroll = 130
decal_lava_scroll = 36
decal_blood_scroll = 80
decal_stream_scroll = 80

function decals:add(x,y,w,h,type)
	local scrollspeed,gfx
	gfx = self.textures[type]
	gfx:setWrap("repeat", "repeat")
	
	if type == "blood" then
		scrollspeed = decal_blood_scroll
	elseif type == "lava" then
		scrollspeed = decal_lava_scroll
	elseif type == "stream" then
		scrollspeed = decal_stream_scroll
	elseif type == "water" then
		scrollspeed = decal_water_scroll
	end
	
	
	
	table.insert(self, {		
		--position
		x = x or 0,
		y = y or 0,
		w = w or 10,
		h = h or 10,
		
		--properties
		scroll = 0,
		scrollspeed = scrollspeed,
		name = type,
		gfx = gfx,
		quad = love.graphics.newQuad( x,y,w,h, self.textures[type]:getDimensions() ) 

	})

end

function decals:update(dt)
	for i, decal in ipairs(self) do
	
		if world:inview(decal) then
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
	
	if world.decals and world.decals > 0 then
		self.waterfallspin = self.waterfallspin + dt * 10
		self.waterfallspin = self.waterfallspin % (2*math.pi)
	end

end

function decals:draw()
	local count = 0
	

	for i, decal in ipairs(self) do
		if world:inview(decal) then
			count = count + 1
			
			
			--waterfall
			if decal.name == "water" then
				love.graphics.setColor(255,255,255,215)
				love.graphics.draw(decal.gfx, decal.quad, decal.x,decal.y)
			
				love.graphics.setColor(190,240,255,255)
				for i=0, decal.w, self.textures["waterfall"]:getWidth()/2 do
				
					local t = self.textures["waterfall"]
					love.graphics.draw(t, decal.x+i,decal.y,
						(love.math.random(0,1) == 1 and self.waterfallspin or -self.waterfallspin),
						1,1,t:getWidth()/2,t:getHeight()/2
					)
					
				end
				
			else
				--everything else
				love.graphics.setColor(255,255,255,255)
				love.graphics.draw(decal.gfx, decal.quad, decal.x,decal.y)
			
			end


			if editing or debug then
				editor:drawid(decal,i)
				editor:drawcoordinates(decal)
			end
		end
	end
	world.decals = count
end




