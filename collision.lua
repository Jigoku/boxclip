collision = {}

function collision:checkWorld(dt)
	self:bounds()
	self:pickups()
	self:enemies()
end

function collision:check(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
		 x2 < x1+w1 and
		 y1 < y2+h2 and
		 y2 < y1+h1
end

function collision:right(a,b)
	return a.newX <= b.x+b.w and 
					a.x > b.x+b.w
end

function collision:left(a,b)
	return a.newX+a.w >= b.x and 
					a.x+a.w < b.x
end

function collision:top(a,b)
	return a.newY+a.h >= b.y  and 
					a.y < b.y
end

function collision:bottom(a,b)
	return a.newY <= b.y+b.h and 
					a.y+a.h > b.y+b.h
end

function collision:bounds() 
	--if player.x < 0 then
	--	player.x = 0
	--	player.xvel = 0
	--end
end


function collision:pickups()
	if player.alive == 1 then
		local i, pickup
		for i, pickup in ipairs(pickups) do
			if collision:check(player.x,player.y,player.w,player.h,
				pickup.x-pickup.gfx:getWidth()/2, pickup.y-pickup.gfx:getHeight()/2,pickup.gfx:getWidth(),pickup.gfx:getHeight()) then
					table.remove(pickups, i)
					player:collect(pickup.name)
			end
		end
	end
end

function collision:enemies()
	if player.alive == 1 then
		local i, enemy
		for i, enemy in ipairs(enemies) do
			if collision:check(player.x,player.newY,player.w,player.h,
				enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then
			
				-- if we land on top, kill enemy
				if player.newY+player.h >= enemy.y+5 and player.jumping == 1 then	
					player.y = enemy.y - player.h -1
					player:attack(enemies, i)
				else
					-- otherwise we die
					
					player:respawn()
					util:dprint("killed by " .. enemy.name)		
				end
			end
		end
	end
end
