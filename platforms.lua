structures = {}

function createStructure(x,y,w,h,r,g,b,o,movex,movey,movespeed,movedist)
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

function createCrate(x,y,w,h)
		table.insert(structures, {
				x =x or 0,
				y =y or 0,
				w =w or 0,
				h =h or 0,
				name = "crate",
				
				item = "life"
		})
end

function destroyCrate(i)
	table.remove(structures, i)
end

function drawStructures()
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
			drawStructureBounds(structure)
		end
	end
end


function drawStructureBounds(structure)
	-- debug mode drawing
	
	-- collision area
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("line", structure.x, structure.y, structure.w, structure.h)
	
	drawCoordinates(structure)
	
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


function structureMoveX(structure, dt)
	-- traverse x-axis
	if structure.x > structure.xorigin + structure.movedist then
		structure.x = structure.xorigin + structure.movedist
		structure.movespeed = -structure.movespeed
	end	
	if structure.x < structure.xorigin then
		structure.x = structure.xorigin
		structure.movespeed = -structure.movespeed
	end
	structure.x = (structure.x + structure.movespeed *dt)
end

function structureMoveY(structure, dt)
	--traverse y-axis
	if structure.y > structure.yorigin + structure.movedist then
		structure.y = structure.yorigin + structure.movedist
		structure.movespeed = -structure.movespeed
	end
	if structure.y < structure.yorigin  then
		structure.y = structure.yorigin
		structure.movespeed = -structure.movespeed
	end
	structure.y = (structure.y + structure.movespeed *dt)
end
