springs = {}

spring = love.graphics.newImage("graphics/springs/spring.png")

function springs:add(x,y,dir,type)

	if dir == 0 or dir == 1 then
		width = 40
		height = 30
		end
	if dir == 2 or dir == 3 then
		width = 30
		height = 40
	end
		
	if type == "spring" then
		table.insert(springs, {
			--dimensions
			x = x or 0, 
			y = y or 0, 
			w = width,
			h = height,
			
			--properties
			name = "spring",
			gfx = spring,
			vel = 1500,
			dir = dir,
		})
		print("spring added @  X:"..x.." Y: "..y)
	end
	
end

function springs:draw()
	local count = 0
	
	for i, spring in ipairs(springs) do
		if world:inview(spring) then
			count = count +1
				

			love.graphics.setColor(255,255,255,255)
			if spring.dir == 0 then
				love.graphics.draw(spring.gfx, spring.x, spring.y, 0,1,1)
			elseif spring.dir == 1 then
				love.graphics.draw(spring.gfx, spring.x, spring.y, 0,1,-1,0,spring.h )
			elseif spring.dir == 2 then
				love.graphics.draw(spring.gfx, spring.x, spring.y, math.rad(90),1,1,0,spring.w )
			elseif spring.dir == 3 then
				love.graphics.draw(spring.gfx, spring.x, spring.y, math.rad(-90),-1,1 )
			end
			if editing then
				springs:drawDebug(spring, i)
			end

		end
	end

	world.springs = count
end

function springs:drawDebug(spring, i)
	
	if spring.name == "spring" then
		love.graphics.setColor(255,155,55,200)
		love.graphics.rectangle(
			"line", 
			spring.x, 
			spring.y, 
			spring.w, 
			spring.h
		)
	end
	
	util:drawid(spring, i)
	util:drawCoordinates(spring)
end
