structures = {}




function structures:platform(x,y,w,h,movex,movey,movespeed,movedist)
	table.insert(structures, {
		--dimensions
		x = x or 0, -- xco-ord
		y = y or 0, -- yco-ord
		w = w or 0, -- width
		h = h or 0, -- height
		--colour
		r = r or 120, -- red
		g = g or 130, -- green
		b = b or 140, -- blue
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
		gfx = love.graphics.newImage("graphics/tiles/marble.png")
		
	})
end

function structures:crate(x,y,item)
	table.insert(structures, {
		x = x or 0,
		y = y or 0,
		w = 50,
		h = 50,
		name = "crate",
		item = item or nil,
		gfx = love.graphics.newImage("graphics/crate.png"),
	})
end


function structures:destroy(crate, i)
	--add the contents of destroyable to world if any
	if crate.item == "gem" then
		pickups:gem(crate.x+crate.w/2, crate.y+crate.h/2)
	elseif crate.item == "life" then
		pickups:life(crate.x+crate.w/2, crate.y+crate.h/2)
	end
	--remove the destroyable
	table.remove(structures, i)
end


function structures:inview(structure) 
	if (structure.x < player.x + (love.graphics.getWidth()/2*camera.scaleX)) 
	and (structure.x+structure.w > player.x - (love.graphics.getWidth()/2*camera.scaleX))  then
		return true
	end
end

function structures:draw()
	world.structures = 0
	local count = 0
	
	local key, structure
	for key, structure in ipairs(structures) do
	 if self:inview(structure) then
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
		
		if structure.name == "crate" then
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(structure.gfx,structure.x, structure.y, 0, 1, 1)
		end
		
		
		if debug == 1 then
			self:drawDebug(structure)
		end
	end
	end
	world.structures = count
end


function structures:drawDebug(structure)
	-- debug mode drawing
	
	-- collision area
	if structure.name == "platform" then
		love.graphics.setColor(255,0,0,100)
		love.graphics.rectangle("line", structure.x, structure.y, structure.w, structure.h)
	end
	
	if structure.name == "crate" then
		love.graphics.setColor(0,255,255,100)
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
	
	util:drawCoordinates(structure)
	
end






