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
	})
end


function enemies:draw()
	local i, enemy
	for i, enemy in ipairs(enemies) do
		if type(enemy) == "table" then
			
			if enemy.name == "walker" then
				love.graphics.setColor(200,200,200,100)
				love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.w, enemy.h)
			end
			
			if debug == 1 then
				enemies:drawDebug(enemy)
			end
			
		end
	end
end


function enemies:drawDebug(enemy)
	--bounds
	love.graphics.setColor(255,200,200,255)
	love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
	--hitbox
	love.graphics.setColor(255,200,100,255)
	love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)
	util:drawCoordinates(enemy)
end




