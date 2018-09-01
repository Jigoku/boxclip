--[[
 * Copyright (C) 2015 - 2018 Ricky K. Thomson
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
 
--TODO
--experiment with performance of textured polygons instead of meshes (don't need 3D)
--http://benhumphreys.ca/blog/2012/06/24/drawing-a-textured-polygon-in-love2d/
 
platforms = {}

platform_cradle = love.graphics.newImage("data/images/tiles/cradle.png")
platforms.grass = textures:load("data/images/surfaces/")
platforms.textures = textures:load("data/images/platforms/")

for _,texture in pairs(platforms.textures) do
	texture:setWrap("repeat", "repeat")
end

table.insert(editor.entities, {"platform", "platform"})
table.insert(editor.entities, {"platform_b", "platform"})	
table.insert(editor.entities, {"platform_x", "platform"})
table.insert(editor.entities, {"platform_y", "platform"})
table.insert(editor.entities, {"platform_s", "platform"})

function platforms:add(x,y,w,h,clip,movex,movey,movespeed,movedist,swing,angleorigin,texture,surface)


	table.insert(world.entities.platform, {
		--dimensions
		x = x or 0, 
		y = y or 0,
		w = w or 0,
		h = h or 0,

		--properties
		group = "platform",
				
		--movement
		movex = movex or false,
		movey = movey or false,
		movespeed = movespeed or 100,
		movedist = movedist or 200,
		clip = clip or false,
		xorigin = x,
		yorigin = y,
		carrying = false,
		
		--swing platforms
		swing = swing or false,
		angleorigin = angleorigin or 0,
		angle = angleorigin or 0,
		radius = (swing and 200 or 0),
		
		--texturing
		texture = texture or 1,
		surface = surface or 2,
		mesh = love.graphics.newMesh(4, "fan", "static"),

	})
	self:settexture(world.entities.platform[#world.entities.platform],texture)
	
	print("platform added @  X:"..x.." Y: "..y .. "(w:" .. w .. " h:".. h.. ")")
end


function platforms:settexture(platform,texture)

	local cols = math.ceil(platform.w/platforms.textures[texture]:getWidth())
	local rows = math.ceil(platform.h/platforms.textures[texture]:getHeight())
			
	platform.texture = texture
	platform.verts = { 
		--top left
		{0,0,0,0},  
		--top right
		{0+platform.w,0,cols,0},
		--bottom right
		{0+platform.w,0+platform.h,cols,rows}, 	
		--bottom left
		{0,0+platform.h,0,rows}
	}
end


function platforms:update(dt)
	-- moving platforms etc
	for i, platform in pairs(world.entities.platform) do
		if platform.movex then physics:movex(platform, dt) end
		if platform.movey then physics:movey(platform, dt) end
		if platform.swing then physics:swing(platform, dt) end
		
		physics:update(platform)
	end
end


function platforms:draw()
	local count = 0

	for i, platform in ipairs(world.entities.platform) do
		if world:inview(platform) then
			count = count + 1
			

			if platform.swing then
				chainlink:draw(platform)
					
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
				if platform.movex or platform.movey then		
					v[5] =	platform_move_r
					v[6] =	platform_move_g
					v[7] =	platform_move_b
					v[8] = 1
				elseif not platform.clip then						
					v[5] =	platform_behind_r
					v[6] =	platform_behind_g
					v[7] =	platform_behind_b
					v[8] =	1		
				else
					v[5] =	platform_r
					v[6] =	platform_g
					v[7] =	platform_b
					v[8] =	1
				end
			end
			
			platform.mesh:setVertices(platform.verts)
			platform.mesh:setTexture(self.textures[platform.texture])
				
			love.graphics.setColor(1,1,1,1)
			love.graphics.draw(platform.mesh, platform.x, platform.y)
				
			self:drawshadow(platform)
			self:drawsurface(platform)
			
			if editing or debug then platforms:drawdebug(platform, i) end
				
		end
	end
	world.platforms = count
end


function platforms:drawdebug(platform, i)
	-- debug mode drawing
	
	-- collision area
	if not platform.swing and platform.clip then
		love.graphics.setColor(1,0,0,0.15)
		love.graphics.rectangle("fill", platform.x, platform.y, platform.w, platform.h)
		love.graphics.setColor(1,0,0,1)
		love.graphics.rectangle("line", platform.x, platform.y, platform.w, platform.h)
	end
	
	if not platform.clip then
		love.graphics.setColor(0,1,0,0.15)
		love.graphics.rectangle("fill", platform.x, platform.y, platform.w, platform.h)
		love.graphics.setColor(1,0,0,1)
		love.graphics.rectangle("line", platform.x, platform.y, platform.w, platform.h)
	end
	
	-- yaxis waypoint
	if platform.movey then
		love.graphics.setColor(1,0,1,0.07)
		love.graphics.rectangle("fill", platform.xorigin, platform.yorigin, platform.w, platform.h+platform.movedist)
		love.graphics.setColor(1,0,1,1)
		love.graphics.rectangle("line", platform.xorigin, platform.yorigin, platform.w, platform.h+platform.movedist)
	end
	-- xaxis waypoint
	if platform.movex then
		love.graphics.setColor(1,0,1,0.07)
		love.graphics.rectangle("fill", platform.xorigin, platform.yorigin, platform.movedist+platform.w, platform.h)
		love.graphics.setColor(1,0,1,1)
		love.graphics.rectangle("line", platform.xorigin, platform.yorigin, platform.movedist+platform.w, platform.h)
	end 
	
	--debug connector

	if platform.swing then 
		love.graphics.setColor(1,0,1,0.39)
		love.graphics.line( platform.xorigin,platform.yorigin,platform.x,platform.y)	
		love.graphics.setColor(1,0,0,0.39)
	--[[	love.graphics.rectangle("line", 
			platform.xorigin-platform_link_origin:getWidth()/2, 
			platform.yorigin-platform_link_origin:getHeight()/2,
			platform_link_origin:getWidth(),
			platform_link_origin:getHeight()
		)--]]
	end

	editor:drawid(platform,i)
	editor:drawcoordinates(platform)
	
end



function platforms:drawshadow(platform)
	if platform.swing then return false end
	--shadows
	local offset = 15
	
	if platform.w < 40 or platform.h < 40 then
		offset = 5
	end
	
	--shaded edges
	love.graphics.setColor(0,0,0,0.33)
	--right
	love.graphics.rectangle("fill", platform.x+platform.w-offset, platform.y, offset, platform.h -offset)
	--bottom
	love.graphics.rectangle("fill", platform.x, platform.y+platform.h-offset, platform.w, offset)
	--left
	love.graphics.rectangle("fill", platform.x, platform.y, offset, platform.h - offset)
	--top
	--love.graphics.rectangle("fill", platform.x, platform.y, platform.w, offset)
end


function platforms:drawsurface(platform)
	--top surface
	love.graphics.setColor(
		platform_top_r,
		platform_top_g,
		platform_top_b,
		1
	)
			
	--[[ --untextured grass fallback
	--surface
	love.graphics.rectangle("fill", platform.x, platform.y-5, platform.w, 10)	
			
	--arced edges
	love.graphics.arc( "fill", platform.x+platform.w, platform.y, -5, math.pi/2, math.pi*1.5 )
	love.graphics.arc( "fill", platform.x, platform.y, 5, math.pi/2, math.pi*1.5 )
	--]]
				
	local offset = platforms.grass[platform.surface]:getHeight()/2
	local quad = love.graphics.newQuad( 0,0, platform.w, platforms.grass[platform.surface]:getHeight(), platforms.grass[platform.surface]:getDimensions() )
	platforms.grass[platform.surface]:setWrap("repeat", "repeat")
	love.graphics.draw(platforms.grass[platform.surface], quad, platform.x,platform.y-offset)
end
