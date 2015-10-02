function checkCollisions(dt)
	checkPlayerBounds()
	checkCollisionPickups()
end

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
		 x2 < x1+w1 and
		 y1 < y2+h2 and
		 y2 < y1+h1
end


function checkPlayerBounds() 
	if player.x < 0 then
		player.x = 0
		player.xvel = 0
	end
end


function checkCollisionPickups()
	local i, pickup
		for i, pickup in ipairs(pickups) do
			if checkCollision(player.x,player.y,player.w,player.h,
				pickup.x,pickup.y,pickup.w,pickup.h) then
					if pickup.name == "coin" then
						table.remove(pickups, i)
						playerCollectCoin()
					end
			end
		end
end
