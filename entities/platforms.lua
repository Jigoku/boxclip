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

platform_tile = love.graphics.newImage("graphics/tiles/checked.png")

platform_link = love.graphics.newImage("graphics/tiles/link.png")
platform_link_origin = love.graphics.newImage("graphics/tiles/link_origin.png")

function platforms:add(x,y,w,h,clip,movex,movey,movespeed,movedist,swing,angle)

	table.insert(platforms, {
		--dimensions
		x = x or 0, 
		y = y or 0,
		w = w or 0,
		h = h or 0,

		--properties
		name = "platform",
				
		--movement
		movex = movex or 0,
		movey = movey or 0,
		movespeed = movespeed or 100,
		movedist = movedist or 200,
		clip = clip or 1,
		xorigin = x,
		yorigin = y,
		gfx = platform_tile,
		
		--swing platforms
		swing = swing or 0,
		angle = angle or 0,
		radius = 200,

	})
	
	
	print("platform added @  X:"..x.." Y: "..y .. "(w:" .. w .. " h:".. h.. ")")
end



function platforms:drawlink(platform)

	--origin
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(platform_link_origin, platform.xorigin-platform_link_origin:getWidth()/2, platform.yorigin-platform_link_origin:getHeight()/2, 0,1,1)
	
	local r = 0

	--link
	while r < platform.radius -platform_link:getHeight() do
		r = r + platform_link:getHeight()
		local x = r * math.cos(platform.angle) + platform.xorigin
		local y = r * math.sin(platform.angle) + platform.yorigin

		love.graphics.draw(platform_link, x-platform_link:getWidth()/2, y-platform_link:getHeight()/2, 0,1,1)

	end
	
end

function platforms:draw()
	local count = 0
	
	local i, platform
	for i, platform in ipairs(platforms) do
		if world:inview(platform) then
		count = count + 1
			
			if platform.name == "platform" then
	 	

				if platform.swing == 1 then

					platforms:drawlink(platform, radius)

					local quad = love.graphics.newQuad( 0,0, platform.w+50, platform.h/1.5, platform.gfx:getDimensions() )
					platform.gfx:setWrap("repeat", "repeat")	
					
					love.graphics.setColor(
						platform_wall_r,
						platform_wall_g,
						platform_wall_b,
						255
					)	
					love.graphics.draw(platform.gfx, quad, platform.x-25,platform.y)
				
				else
				
				
				if platform.clip == 0 then
					love.graphics.setColor(
						platform_wall_r-60,
						platform_wall_g-60,
						platform_wall_b-60,
						255
					)
				else
					love.graphics.setColor(
						platform_wall_r,
						platform_wall_g,
						platform_wall_b,
						255
					)	
				end

				local quad = love.graphics.newQuad( 0,0, platform.w, platform.h, platform.gfx:getDimensions() )
				platform.gfx:setWrap("repeat", "repeat")
				love.graphics.draw(platform.gfx, quad, platform.x,platform.y)
				
				
				local offset = 4
				--shaded edges
				love.graphics.setColor(0,0,0,50)
				--right
				love.graphics.rectangle("fill", platform.x+platform.w-offset, platform.y+offset, offset, platform.h-offset*2)
				--bottom
				love.graphics.rectangle("fill", platform.x, platform.y+platform.h-offset, platform.w, offset)
				--left
				love.graphics.rectangle("fill", platform.x, platform.y+offset, offset, platform.h-offset*2)
				
				--top (placeholder surface)
				love.graphics.setColor(
					platform_top_r,
					platform_top_g,
					platform_top_b,
					255
				)
				
					love.graphics.rectangle("fill", platform.x, platform.y-5, platform.w, 10)	
					love.graphics.arc( "fill", platform.x+platform.w, platform.y, -5, math.pi/2, math.pi*1.5 )
					love.graphics.arc( "fill", platform.x, platform.y, 5, math.pi/2, math.pi*1.5 )
				
				end
				
				if editing or debug then platforms:drawDebug(platform, i) end
				
				

					
			end

		end
	end
	world.platforms = count
end


function platforms:drawDebug(platform, i)
	-- debug mode drawing
	
	-- collision area
	if platform.name == "platform" and not (platform.swing == 1) then
		love.graphics.setColor(255,0,0,100)
		love.graphics.rectangle("line", platform.x, platform.y, platform.w, platform.h)
	end
	
	
	-- yaxis waypoint
	if platform.movey == 1 then
		love.graphics.setColor(255,0,255,100)
		love.graphics.rectangle("line", platform.xorigin, platform.yorigin, platform.w, platform.h+platform.movedist)
	end
	-- xaxis waypoint
	if platform.movex == 1 then
		love.graphics.setColor(255,0,255,100)
		love.graphics.rectangle("line", platform.xorigin, platform.yorigin, platform.movedist+platform.w, platform.h)
	end 
	
	--debug connector
	if platform.swing == 1 then 
		love.graphics.setColor(255,0,255,100)
		love.graphics.line( platform.xorigin,platform.yorigin,
							platform.x,platform.y
		)	
		love.graphics.setColor(255,0,0,100)
		love.graphics.rectangle("line", platform.xorigin-platform_link_origin:getWidth()/2, platform.yorigin-platform_link_origin:getHeight()/2,platform_link_origin:getWidth(),platform_link_origin:getHeight())
	end
	
	util:drawid(platform,i)
	util:drawCoordinates(platform)
	
end






