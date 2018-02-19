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
 
platforms = {}

platform_link = love.graphics.newImage("data/images/tiles/link.png")
platform_link_origin = love.graphics.newImage("data/images/tiles/link_origin.png")
platform_cradle = love.graphics.newImage("data/images/tiles/cradle.png")

platform_grass = love.graphics.newImage("data/images/tiles/grass.png")




platforms.textures =  textures:load("data/images/textures/")

for _,texture in ipairs(platforms.textures) do
	texture:setWrap("repeat", "repeat")
end


function platforms:add(x,y,w,h,clip,movex,movey,movespeed,movedist,swing,angle,texture)

	local cols = math.ceil(w/self.textures[texture]:getWidth())
	local rows = math.ceil(h/self.textures[texture]:getHeight())

	table.insert(world.entities.platforms, {
		--dimensions
		x = x or 0, 
		y = y or 0,
		w = w or 0,
		h = h or 0,

		--properties
		group = "platforms",
				
		--movement
		movex = movex or 0,
		movey = movey or 0,
		movespeed = movespeed or 100,
		movedist = movedist or 200,
		clip = clip or 1,
		xorigin = x,
		yorigin = y,
		carrying = false,
		
		--swing platforms
		swing = swing or 0,
		angle = angle or 0,
		radius = (swing and 200 or 0),
		
		--texturing
		texture = texture or 1,
		mesh = love.graphics.newMesh(4, "fan", "static"),
		
		verts = { 
			--top left
			{0,0,0,0},  
			--top right
			{0+w,0,cols,0},
			--bottom right
			{0+w,0+h,cols,rows}, 
			--bottom left
			{0,0+h,0,rows}, 
		}
	})
	
	
	print("platform added @  X:"..x.." Y: "..y .. "(w:" .. w .. " h:".. h.. ")")
end



function platforms:drawlink(platform)

	--origin
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(platform_link_origin, platform.xorigin-platform_link_origin:getWidth()/2, platform.yorigin-platform_link_origin:getHeight()/2, 0,1,1)
	
	local r = 0

	--link
	while r < platform.radius do
		r = r + platform_link:getHeight()
		local x = r * math.cos(platform.angle) + platform.xorigin
		local y = r * math.sin(platform.angle) + platform.yorigin

		love.graphics.draw(platform_link, x-platform_link:getWidth()/2, y-platform_link:getHeight()/2, 0,1,1)
	end
	
end

function platforms:draw()
	local count = 0

	for i, platform in ipairs(world.entities.platforms) do
		
		if world:inview(platform) then
		count = count + 1

			if platform.swing == 1 then
				platforms:drawlink(platform, radius)
					
				love.graphics.setColor(
					platform_behind_r,
					platform_behind_g,
					platform_behind_b,
					255
				)
				love.graphics.draw(platform_cradle, platform.x-platform_cradle:getWidth()/2,platform.y-platform_cradle:getHeight()/1.5)
			end
				
			--[[ -- old method of drawing platforms with quads (keep this here in case something breaks)
				
				local quad = love.graphics.newQuad( 0,0, platform.w, platform.h, self.textures[platform.texture]:getDimensions() )
				love.graphics.setColor(r,g,b,a)
				love.graphics.draw(self.textures[platform.texture], quad, platform.x,platform.y)
				
			--]]
			
			
			--apply world pallete/theme colors to platform mesh on the fly
			for i,v in ipairs(platform.verts) do
				if (platform.movex == 1) or (platform.movey == 1) then		
					v[5] =	platform_move_r
					v[6] =	platform_move_g
					v[7] =	platform_move_b
					v[8] = 255
				elseif platform.clip == 0 then						
					v[5] =	platform_behind_r
					v[6] =	platform_behind_g
					v[7] =	platform_behind_b
					v[8] =	255		
				else
					v[5] =	platform_r
					v[6] =	platform_g
					v[7] =	platform_b
					v[8] =	255
				end
			end
			
			platform.mesh:setVertices(platform.verts)
			platform.mesh:setTexture(self.textures[platform.texture])
				
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(platform.mesh, platform.x, platform.y)
				
				
			--shadows
			local offset
			if platform.movex == 1 or (platform.movey == 1) then
				 offset = 4
			else
				 offset = 10
			end
				
			--shaded edges
			love.graphics.setColor(0,0,0,85)
			--right
			love.graphics.rectangle("fill", platform.x+platform.w-offset, platform.y, offset, platform.h -offset)
			--bottom
			love.graphics.rectangle("fill", platform.x, platform.y+platform.h-offset, platform.w, offset)
			--left
			love.graphics.rectangle("fill", platform.x, platform.y, offset, platform.h - offset)
			--top
			--love.graphics.rectangle("fill", platform.x, platform.y, platform.w, offset)
		
			--top surface
			love.graphics.setColor(
				platform_top_r,
				platform_top_g,
				platform_top_b,
				255
			)
			
			local offset = 5
			local quad = love.graphics.newQuad( 0,0, platform.w, platform_grass:getHeight(), platform_grass:getDimensions() )
			platform_grass:setWrap("repeat", "repeat")
			love.graphics.draw(platform_grass, quad, platform.x,platform.y-offset)
			
	
			--[[ --untextured grass fallback
			--surface
			love.graphics.rectangle("fill", platform.x, platform.y-5, platform.w, 10)	
			
			--arced edges
			love.graphics.arc( "fill", platform.x+platform.w, platform.y, -5, math.pi/2, math.pi*1.5 )
			love.graphics.arc( "fill", platform.x, platform.y, 5, math.pi/2, math.pi*1.5 )
			--]]
				
				
			if editing or debug then platforms:drawdebug(platform, i) end
				
					


		end
	end
	world.platforms = count
end


function platforms:drawdebug(platform, i)
	-- debug mode drawing
	
	-- collision area
	if not (platform.swing == 1) and (platform.clip == 1) then
		love.graphics.setColor(255,0,0,40)
		love.graphics.rectangle("fill", platform.x, platform.y, platform.w, platform.h)
		love.graphics.setColor(255,0,0,255)
		love.graphics.rectangle("line", platform.x, platform.y, platform.w, platform.h)
	end
	
	if platform.clip == 0 then
		love.graphics.setColor(0,255,0,40)
		love.graphics.rectangle("fill", platform.x, platform.y, platform.w, platform.h)
		love.graphics.setColor(255,0,0,255)
		love.graphics.rectangle("line", platform.x, platform.y, platform.w, platform.h)
	end
	
	-- yaxis waypoint
	if platform.movey == 1 then
		love.graphics.setColor(255,0,255,20)
		love.graphics.rectangle("fill", platform.xorigin, platform.yorigin, platform.w, platform.h+platform.movedist)
		love.graphics.setColor(255,0,255,255)
		love.graphics.rectangle("line", platform.xorigin, platform.yorigin, platform.w, platform.h+platform.movedist)
	end
	-- xaxis waypoint
	if platform.movex == 1 then
		love.graphics.setColor(255,0,255,20)
		love.graphics.rectangle("fill", platform.xorigin, platform.yorigin, platform.movedist+platform.w, platform.h)
		love.graphics.setColor(255,0,255,255)
		love.graphics.rectangle("line", platform.xorigin, platform.yorigin, platform.movedist+platform.w, platform.h)
	end 
	
	--debug connector
	if platform.swing == 1 then 
		love.graphics.setColor(255,0,255,100)
		love.graphics.line( platform.xorigin,platform.yorigin,platform.x,platform.y)	
		love.graphics.setColor(255,0,0,100)
		love.graphics.rectangle("line", 
			platform.xorigin-platform_link_origin:getWidth()/2, 
			platform.yorigin-platform_link_origin:getHeight()/2,
			platform_link_origin:getWidth(),
			platform_link_origin:getHeight()
		)
	end
	
	editor:drawid(platform,i)
	editor:drawcoordinates(platform)
	
end







