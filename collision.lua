collision = {}

function collision:checkWorld(dt)
	self:bounds()
	self:pickups()
end

function collision:check(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
		 x2 < x1+w1 and
		 y1 < y2+h2 and
		 y2 < y1+h1
end


function collision:bounds() 
	if player.x < 0 then
		player.x = 0
		player.xvel = 0
	end
end


function collision:pickups()
	local i, pickup
		for i, pickup in ipairs(pickups) do
			if collision:check(player.x,player.y,player.w,player.h,
				pickup.x-pickup.gfx:getWidth()/2, pickup.y-pickup.gfx:getHeight()/2,pickup.gfx:getWidth(),pickup.gfx:getHeight()) then
						table.remove(pickups, i)
						player:collect(pickup.name)
			end
		end
end
