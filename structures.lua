structures = {}


marble = love.graphics.newImage("graphics/tiles/checked.png")

function structures:platform(x,y,w,h,movex,movey,movespeed,movedist)
	table.insert(structures, {
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
		gfx = marble
		
	})
end



function structures:checkpoint(x,y)
	table.insert(structures, {
		x = x or 0,
		y = y or 0,
		w = 5,
		h = 50,
		name = "checkpoint",
	})
end






function structures:draw()
	local count = 0
	
	local i, structure
	for i, structure in ipairs(structures) do
		if world:inview(structure) then
		count = count + 1
				
			if structure.name == "platform" then
	 	
				if structure.movey == 1 or structure.movex == 1 then
					love.graphics.setColor(structure.r+40,structure.g+40,structure.b+40,structure.o)
				else
					love.graphics.setColor(structure.r,structure.g,structure.b,structure.o)
				end
					
				--tile the texture using quad
				local quad = love.graphics.newQuad( 0,0, structure.w, structure.h, structure.gfx:getDimensions() )
				structure.gfx:setWrap("repeat", "repeat")
				love.graphics.draw(structure.gfx, quad, structure.x,structure.y)

				--shaded edges
				love.graphics.setColor(0,0,0,50)
				--right
				love.graphics.rectangle("fill", structure.x+structure.w-4, structure.y, 4, structure.h)
				--bottom
				love.graphics.rectangle("fill", structure.x, structure.y+structure.h-4, structure.w, 4)
				--left
				love.graphics.rectangle("fill", structure.x, structure.y, 4, structure.h)
			
				--top
				love.graphics.setColor(structure.r+50,structure.g+100,structure.b+60,structure.o)
				love.graphics.rectangle("fill", structure.x, structure.y, structure.w, 2)	
			end
		

		
			if structure.name == "checkpoint" then
				love.graphics.setColor(255,255,255,100)
				love.graphics.rectangle("fill", structure.x, structure.y, structure.w, structure.h)	
			end
			if debug == 1 then
				self:drawDebug(structure, i)
			end
		end
	end
	world.structures = count
end


function structures:drawDebug(structure, i)
	-- debug mode drawing
	
	-- collision area
	if structure.name == "platform" then
		love.graphics.setColor(255,0,0,100)
		love.graphics.rectangle("line", structure.x, structure.y, structure.w, structure.h)
	end
	
	
	-- yaxis waypoint
	if structure.movey == 1 then
		love.graphics.setColor(255,0,255,100)
		love.graphics.rectangle("line", structure.xorigin, structure.yorigin, structure.w, structure.h+structure.movedist)
	end
	-- xaxis waypoint
	if structure.movex == 1 then
		love.graphics.setColor(255,0,255,100)
		love.graphics.rectangle("line", structure.xorigin, structure.yorigin, structure.movedist+structure.w, structure.h)
	end 
	util:drawid(structure,i)
	util:drawCoordinates(structure)
	
end






