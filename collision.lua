collision = {}

function collision:checkWorld(dt)
	if not editing and player.alive == 1 then
		self:bounds()
		self:pickups(dt)
		self:enemies(dt)
		self:checkpoints(dt)
		self:portals(dt)
	end
end

function collision:check(x1,y1,w1,h1, x2,y2,w2,h2)
	world.collision = world.collision +1
	return x1 < x2+w2 and
		 x2 < x1+w1 and
		 y1 < y2+h2 and
		 y2 < y1+h1
end

function collision:right(a,b)
	world.collision = world.collision +1
	return a.newX < b.x+b.w and 
					a.x > b.x+b.w
end

function collision:left(a,b)
	world.collision = world.collision +1
	return a.newX+a.w > b.x and 
					a.x+a.w < b.x
end

function collision:top(a,b)
	world.collision = world.collision +1
	--also allows edge stepping
	return a.newY+a.h > b.y  and 
					a.y+a.h-(a.h/4) < b.y
end

function collision:bottom(a,b)
	world.collision = world.collision +1
	return a.newY < b.y+b.h and 
					a.y+a.h > b.y+b.h
end

function collision:above(a,b)
	world.collision = world.collision +1
	return a.newY+a.h > b.y  and 
					a.y < b.y
end

function collision:bounds() 
	--if player.x < 0 then
	--	player.x = 0
	--	player.xvel = 0
	--end
end


function collision:pickups(dt)
	if mode == "editing" then return end

	if player.alive == 1 then
		local i, pickup
		for i, pickup in ipairs(pickups) do
			if world:inview(pickup) and not pickup.collected then
				if collision:check(player.x,player.y,player.w,player.h,
					pickup.x, pickup.y,pickup.gfx:getWidth(),pickup.gfx:getHeight()) then
						table.remove(pickups,i)
						pickup.collected = true
						player:collect(pickup)
				end
			end
		end
	end
end




function collision:enemies(dt)
	if mode == "editing" then return end
	local i, enemy
	for i, enemy in ipairs(enemies) do
		if world:inview(enemy) and enemy.alive then
			if enemy.name == "walker" then
				if collision:check(player.x,player.newY,player.w,player.h,
					enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then
					-- if we land on top, kill enemy
					if collision:above(player,enemy) and player.jumping == 1 then	
						player.y = enemy.y - player.h -1 *dt
						enemy.alive = false
						player:attack(enemy)
						return true
					else
						-- otherwise we die			
						player:die()
						util:dprint("killed by " .. enemy.name)		
					end
				end
			end
			
			if enemy.name == "spike" or enemy.name == "icicle" then
				if collision:check(player.x,player.newY,player.w,player.h,
					enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then
					player:die()
					util:dprint("killed by " .. enemy.name)	
				end
			end
			
		end
	end
end

function collision:checkpoints(dt)
	if mode == "editing" then return end
	
	local i, checkpoint
	for i, checkpoint in ipairs(checkpoints) do
		if world:inview(checkpoint) then
			if collision:check(player.x,player.y,player.w,player.h,
				checkpoint.x, checkpoint.y,checkpoint.w,checkpoint.h) then
				if not checkpoint.activated then
					sound:play(sound.checkpoint)
					checkpoint.activated = true
					player.spawnX = checkpoint.x
					player.spawnY = checkpoint.y					
				end
			end
		end
	end
end

function collision:portals(dt)
	if mode == "editing" then return end
	
	local i, portal
	for i, portal in ipairs(portals) do
		if world:inview(portal) then
			if collision:check(player.x,player.y,player.w,player.h,
				portal.x, portal.y,portal.w,portal.h) then
				
					if portal.name == "goal" then
						if not portal.activated then
							--add paramater for "next map"?
							portal.activated = true
							sound:play(sound.goal)
							print("Reached goal")
						end
					end
			end
		end
	end
end
