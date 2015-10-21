platforms = {}

platform_tile = love.graphics.newImage("graphics/tiles/diamond.png")

function platforms:add(x,y,w,h,movex,movey,movespeed,movedist)
	table.insert(platforms, {
		--dimensions
		x = x or 0, -- xco-ord
		y = y or 0, -- yco-ord
		w = w or 0, -- width
		h = h or 0, -- height

		--properties
		name = "platform",
				
		--movement
		movex = movex or 0,
		movey = movey or 0,
		movespeed = movespeed or 100,
		movedist = movedist or 200,
		xorigin = x,
		yorigin = y,
		gfx = platform_tile,

	})
	print("platform added @  X:"..x.." Y: "..y .. "(w:" .. w .. " h:".. h.. ")")
end

function platforms:draw()
	local count = 0
	
	local i, platform
	for i, platform in ipairs(platforms) do
		if world:inview(platform) then
		count = count + 1
				
			if platform.name == "platform" then
	 	
				if platform.movey == 1 or platform.movex == 1 then
					love.graphics.setColor(
						platform_wall_r-40,
						platform_wall_g-40,
						platform_wall_b-40,
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
				
				--tile the texture using quad
				local quad = love.graphics.newQuad( 0,0, platform.w, platform.h, platform.gfx:getDimensions() )
				platform.gfx:setWrap("repeat", "repeat")
				love.graphics.draw(platform.gfx, quad, platform.x,platform.y)
					
				--shaded edges
				love.graphics.setColor(0,0,0,50)
				--right
				love.graphics.rectangle("fill", platform.x+platform.w-4, platform.y+4, 4, platform.h-4*2)
				--bottom
				love.graphics.rectangle("fill", platform.x, platform.y+platform.h-4, platform.w, 4)
				--left
				love.graphics.rectangle("fill", platform.x, platform.y+4, 4, platform.h-8)
				
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
				
				if editing then platforms:drawDebug(platform, i) end
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






