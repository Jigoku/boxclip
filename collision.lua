collision = {}

function collision:checkWorld(dt)
	self:bounds()
	self:pickups()
end

function collision:check(a,b)
	return b.x < a.x+a.w 
		and a.x < b.x+b.w 
		and b.y < a.y+a.h 
		and a.y < b.y+b.h
end

function collision:bounds() 
	if player.x < 0 then
		player.x = 0
		player.xvel = 0
	end
end

function collision:left(a,b)
	return a.newX+a.w >= b.x 
		and a.x+a.w < b.x
end

function collision:right(a,b)
	return a.newX <= b.x+b.w 
		and a.x > b.x+b.w
end

function collision:top(a,b)
	return a.newY+a.h >= b.y 
		and a.y < b.y
end

function collision:bottom(a,b)
	return a.newY <= b.y+b.h 
		and a.y+a.h > b.y+b.h
end

function collision:pickups()
	local i, pickup
		for i, pickup in ipairs(pickups) do
			if collision:check(player,pickup) then
					if pickup.name == "coin" then
						table.remove(pickups, i)
						player:collect()
					end
			end
		end
end
