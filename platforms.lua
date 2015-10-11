platforms = {}


platform_tile = love.graphics.newImage("graphics/tiles/checked.png")
--platform_tile = love.graphics.newImage("graphics/tiles/marble.png")


function platforms:add(x,y,w,h,movex,movey,movespeed,movedist)
	table.insert(platforms, {
		--dimensions
		x = x or 0, -- xco-ord
		y = y or 0, -- yco-ord
		w = w or 0, -- width
		h = h or 0, -- height
		--colour
		r = r or 200, -- red
		g = g or 130, -- green
		b = b or 50, -- blue
		o = o or 255, -- opacity
		--properties
		name = "platform",
				
		--movement
		movex = movex or 0,
		movey = movey or 0,
		movespeed = movespeed or 100,
		movedist = movedist or 200,
		xorigin = x,
		yorigin = y,
		gfx = platform_tile
		
	})
end


function platforms:draw()
	local count = 0
	
	local i, platform
	for i, platform in ipairs(platforms) do
		if world:inview(platform) then
		count = count + 1
				
			if platform.name == "platform" then
	 	
				if platform.movey == 1 or platform.movex == 1 then
					love.graphics.setColor(platform.r+40,platform.g+40,platform.b+40,platform.o)
				else
					love.graphics.setColor(platform.r,platform.g,platform.b,platform.o)
				end
					
				--tile the texture using quad
				local quad = love.graphics.newQuad( 0,0, platform.w, platform.h, platform.gfx:getDimensions() )
				platform.gfx:setWrap("repeat", "repeat")
				love.graphics.draw(platform.gfx, quad, platform.x,platform.y)

				--shaded edges
				love.graphics.setColor(0,0,0,50)
				--right
				love.graphics.rectangle("fill", platform.x+platform.w-4, platform.y, 4, platform.h)
				--bottom
				love.graphics.rectangle("fill", platform.x, platform.y+platform.h-4, platform.w, 4)
				--left
				love.graphics.rectangle("fill", platform.x, platform.y, 4, platform.h)
			
				--top
				love.graphics.setColor(platform.r+50,platform.g+100,platform.b+60,platform.o)
				love.graphics.rectangle("fill", platform.x, platform.y, platform.w, 2)	
			end
		

		
			if platform.name == "checkpoint" then
				love.graphics.setColor(255,255,255,100)
				love.graphics.rectangle("fill", platform.x, platform.y, platform.w, platform.h)	
			end
			if debug == 1 then
				self:drawDebug(platform, i)
			end
		end
	end
	world.platforms = count
end


function platforms:drawDebug(platform, i)
	-- debug mode drawing
	
	-- collision area
	if platform.name == "platform" then
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
	util:drawid(platform,i)
	util:drawCoordinates(platform)
	
end






