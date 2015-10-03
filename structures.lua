structures = {}

function structures:platform(x,y,w,h,r,g,b,o,movex,movey,movespeed,movedist)
	table.insert(structures, {
		--dimensions
		x = x or 0, -- xco-ord
		y = y or 0, -- yco-ord
		w = w or 0, -- width
		h = h or 0, -- height
		--colour
		r = r or 255, -- red
		g = g or 0, -- green
		b = b or 0, -- blue
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
	})
end

function structures:crate(x,y,item)
	table.insert(structures, {
		x = x or 0,
		y = y or 0,
		w = 50,
		h = 50,
		name = "crate",
		item = item or nil
	})
end

function structures:destroy(crate, i)
	if crate.item == "gem" then
		pickups:gem(crate.x+crate.w/2, crate.y+crate.h/2)
	elseif crate.item == "life" then
		pickups:life(crate.x+crate.w/2, crate.y+crate.h/2)
	end
	table.remove(structures, i)
end


function structures:draw()
	local key, structure
	for key, structure in ipairs(structures) do
	
	 if structure.name == "platform" then
			love.graphics.setColor(structure.r,structure.g,structure.b,structure.o)
			love.graphics.rectangle("fill", structure.x, structure.y, structure.w, structure.h)
			

			--right
			love.graphics.setColor(structure.r-10,structure.g-10,structure.b-10,structure.o)
			love.graphics.rectangle("fill", structure.x+structure.w-4, structure.y, 4, structure.h)
			--bottom
			love.graphics.rectangle("fill", structure.x, structure.y+structure.h-4, structure.w, 4)
			
			--left
			love.graphics.setColor(structure.r-20,structure.g-20,structure.b-20,structure.o)
			love.graphics.rectangle("fill", structure.x, structure.y, 4, structure.h)
			
			--top
			love.graphics.setColor(structure.r+50,structure.g+100,structure.b+60,structure.o)
			love.graphics.rectangle("fill", structure.x, structure.y, structure.w, 4)
			
		end
		
		if structure.name == "crate" then
			love.graphics.setColor(60,30,10,255)
			love.graphics.rectangle("fill", structure.x, structure.y, structure.w, structure.h)
			love.graphics.setColor(80,40,10,255)
			love.graphics.rectangle("line", structure.x, structure.y, structure.w, structure.h)
		end
		
		if debug == 1 then
			self:drawDebug(structure)
		end
	end
end


function structures:drawDebug(structure)
	-- debug mode drawing
	
	-- collision area
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("line", structure.x, structure.y, structure.w, structure.h)
	
	util:drawCoordinates(structure)
	
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
end



