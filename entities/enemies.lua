enemies = {}

walker = love.graphics.newImage( "graphics/enemies/walker.png")
spike = love.graphics.newImage( "graphics/enemies/spike.png")
function enemies:walker(x,y,movespeed,movedist)
	table.insert(enemies, {
		--movement
		movespeed = movespeed or 100,
		movedist = movedist or 200,
		
		--origin
		xorigin = x,
		yorigin = y,
		
		--position
		x = math.random(x,x+movedist) or 0,
		y = y or 0,
		
		--dimension
		w = 30,
		h = 30,
		
		--properties
		name = "walker",
		mass = 800,
		xvel = 0,
		yvel = 0,
		dir = "right",
		alive = true,
		
		newY = y,
		
		gfx = walker,
		
	})
	print( "walker added @  X:"..x.." Y: "..y)
end


function enemies:spike(x,y)
	table.insert(enemies, {

		--position
		x = x or 0,
		y = y or 0,
		xorigin = x,
		yorigin = y,
		
		--dimension
		w = 80,
		h = 30,
		
		--properties
		name = "spike",
		alive = true,
		movedist = 0,
		gfx = spike,
		
	})
	print( "spike added @  X:"..x.." Y: "..y)
end


function enemies:draw()
	local count = 0
	
	local i, enemy
	

	
	for i, enemy in ipairs(enemies) do
		if type(enemy) == "table" and enemy.alive and world:inview(enemy) then
			count = count + 1
				
			if enemy.name == "walker" then
				love.graphics.setColor(255,255,255,255)
				--love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.w, enemy.h)
				if enemy.dir == "left" then
					love.graphics.draw(enemy.gfx, enemy.x, enemy.y, 0, 1, 1)
				elseif enemy.dir == "right" then
					love.graphics.draw(enemy.gfx, enemy.x+enemy.gfx:getWidth(), enemy.y, 0, -1, 1)
				end
			end
			
			love.graphics.setColor(255,255,255,255)
			if enemy.name == "spike" then
				love.graphics.draw(enemy.gfx, enemy.x, enemy.y)
			end
			
			if editing then
				enemies:drawDebug(enemy, i)
			end
		end
	end
	world.enemies = count
end


function enemies:drawDebug(enemy, i)
	--bounds
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
	--hitbox
	love.graphics.setColor(255,200,100,255)
	love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)
	
	if enemy.name == "walker" then
		--waypoint
		love.graphics.setColor(255,0,255,100)
		love.graphics.rectangle("line", enemy.xorigin, enemy.y, enemy.movedist+enemy.w, enemy.h)
	end
	
	util:drawid(enemy,i)
	util:drawCoordinates(enemy)
end




