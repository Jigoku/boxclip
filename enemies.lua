enemies = {}

function enemies:walker(x,y,movespeed,movedist)
	table.insert(enemies, {
		--dimensions
		x = x or 0,
		y = y or 0,
		w = 30,
		h = 30,
		
		--properties
		name = "walker",
		mass = 800,
		--movement
		movespeed = movespeed or 100,
		movedist = movedist or 100,
		xorigin = x,
		yorigin = y,
		xvel = 0,
		yvel = 0,
		dir = "right",
		newY = y,
		gfx = love.graphics.newImage( "graphics/enemies/walker.png"),
	})
end


function enemies:draw()
	local i, enemy
	for i, enemy in ipairs(enemies) do
		if type(enemy) == "table" then
			
			if enemy.name == "walker" then
				love.graphics.setColor(255,255,255,255)
				--love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.w, enemy.h)
				if enemy.dir == "left" then
					love.graphics.draw(enemy.gfx, enemy.x, enemy.y, 0, 1, 1)
				elseif enemy.dir == "right" then
					love.graphics.draw(enemy.gfx, enemy.x+enemy.gfx:getWidth(), enemy.y, 0, -1, 1)
				end
			end
			
			if debug == 1 then
				enemies:drawDebug(enemy, i)
			end
			
		end
	end
end


function enemies:drawDebug(enemy, i)
	--bounds
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
	--hitbox
	love.graphics.setColor(255,200,100,255)
	love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)
	--waypoint
	love.graphics.setColor(255,0,255,100)
	love.graphics.rectangle("line", enemy.xorigin, enemy.y, enemy.movedist+enemy.w, enemy.h)
	
	util:drawid(enemy,i)
	util:drawCoordinates(enemy)
end




