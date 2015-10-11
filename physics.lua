physics = {}




function physics:applyVelocity(object, dt) 
	if object.alive == 1 then
		-- x-axis friction
		if object.dir == "right" then
			if object.xvel < object.speed then
				object.xvel = (object.xvel + ((world.gravity+object.speed) *dt))
			end
		end
		if object.dir == "left"  then
			if not (object.xvel < -object.speed)  then
				object.xvel = (object.xvel - ((world.gravity+object.speed) *dt))
			end
		end
		
		-- increase friction when 'idle' under velocity is nullified
		if object.dir == "idle" and object.xvel ~= 0 then
			if object.xvel > 0 then
				object.xvel = (object.xvel - ((world.gravity+object.mass)/4 *dt))
				if object.xvel < 0 then object.xvel = 0 end
			elseif object.xvel < 0 then
				object.xvel = (object.xvel + ((world.gravity+object.mass)/4 *dt))
				if object.xvel > 0 then object.xvel = 0 end
			end
		end
		
		-- velocity limits
		if object.xvel > object.speed then object.xvel = object.speed end
		if object.xvel < -object.speed then object.xvel = -object.speed end
	end
end


function physics:applyGravity(object, dt)
	--simulate gravity
	object.yvel = util:round((object.yvel - ((world.gravity+object.mass*2) *dt)),0)
end


function physics:movex(object, dt)
	if not editing then
		-- traverse x-axis
		if object.x > object.xorigin + object.movedist then
			object.x = object.xorigin + object.movedist
			object.movespeed = -object.movespeed
			object.dir = "left"
		end	
		if object.x < object.xorigin then
			object.x = object.xorigin
			object.movespeed = -object.movespeed
			object.dir = "right"
		end
		object.x = (object.x + object.movespeed *dt)
	end
end


function physics:movey(object, dt)
	if not editing then
		--traverse y-axis
		if object.y > object.yorigin + object.movedist then
			object.y = object.yorigin + object.movedist
			object.movespeed = -object.movespeed	
		end
		if object.y < object.yorigin  then
			object.y = object.yorigin
			object.movespeed = -object.movespeed
		end
		object.y = (object.y + object.movespeed *dt)
	end
end

function physics:world(dt)
	if not editing then
		self:applyVelocity(player, dt)
		self:applyGravity(player, dt)
	
		--new position, friction/velocity multipier
		player.newX = (player.x + player.xvel *dt)
		player.newY = (player.y - player.yvel *dt)
	
		-- moving platforms etc
		local i, object
		for i, object in ipairs(platforms) do
			if object.movex == 1 then self:movex(object, dt) end
			if object.movey == 1 then self:movey(object, dt) end
		end
		--enemies
		for i, object in ipairs(enemies) do
			if object.movex == 1 then self:movex(object, dt) end
			if object.movey == 1 then self:movey(object, dt) end
		end
	end
end


function physics:crates(object,dt)
	if editing then
		return
	end
	
	if object.alive == 1 then
		local i, crate
		for i, crate in ipairs(crates) do
		
			if collision:check(crate.x,crate.y,crate.w,crate.h,
					object.newX,object.newY,object.w,object.h) then
					
					if object.jumping == 1 then 
						sound:decide(crate)
					end
					
					if collision:right(object,crate) then
						if object.jumping == 1 then
							object.newX = crate.x+crate.w +1
							object.xvel = -object.mass
							self:destroy("x",object,crate,i)
						else
							object.newX = crate.x+crate.w +1
							object.xvel = 0
						end
					elseif collision:left(object,crate) then
						if object.jumping == 1 then
							object.newX = crate.x-object.w -1
							object.xvel = object.mass
							self:destroy("x",object,crate,i)
						else
							object.newX = crate.x-object.w -1
							object.xvel = 0
						end
					elseif collision:bottom(object,crate) then
						if object.jumping == 1 then
							object.newY = crate.y +crate.h +1
							object.yvel = object.mass
							self:destroy("y",object,crate,i)
						else
							object.newY = crate.y +crate.h +1
							object.yvel = 0
						end
					elseif collision:top(object,crate) then
						if object.jumping == 1 then
							object.newY = crate.y - object.h -1
							object.yvel = -object.mass
							self:destroy("y",object,crate,i)
						else
							object.newY = crate.y - object.h -1
							object.yvel = 0
						end
					end
					
					
			end
		end	

	end
end

function physics:platforms(object, dt)
	if editing then
		return
	end

	--loop solid platforms
	if object.alive == 1 then
		local i, platform
		for i, platform in ipairs(platforms) do
		--move the platforms! 
		-- platform.newX == physics:movex(platform,dt)  <--- (ret val)???
				
			if collision:check(platform.x,platform.y,platform.w,platform.h,
					object.newX,object.newY,object.w,object.h) then
					
				-- if anything collides, check which sides did
				-- adjust position/velocity if neccesary
					
				-- right side
				if collision:right(object,platform) then
					
					if platform.name == "platform" then
						if not (platform.movex == 1 or platform.movey == 1) then
							object.xvel = 0
							object.newX = platform.x+platform.w +1
						end
					end	
					
				-- left side
				elseif collision:left(object,platform) then
					
					if platform.name == "platform" then	
						if not (platform.movex == 1 or platform.movey == 1) then
							object.xvel = 0
							object.newX = platform.x-object.w -1
						end
					end
					
				-- bottom side	
				elseif collision:bottom(object,platform) then	
				
					if platform.name == "platform" then
						if not (platform.movey == 1 or platform.movex == 1) then 
							object.yvel = 0
							object.newY = platform.y +platform.h +1
						end				
					end
					
				-- top side
				elseif collision:top(object,platform) then
					
					if platform.name == "platform" then
						--sounds on collision
						if object.jumping == 1 then 
							sound:decide(platform)
						end
						
						--if we are jumping upwards go through the platform
						--only  'fix' to surface if we are going down
						if not (object.yvel > 0 and object.jumping == 1) then
							object.yvel = 0
							object.jumping = 0
							object.newY = platform.y - object.h +1
						end
					
						
						if platform.movex == 1 and object.yvel == 0 then
							-- move along x-axis with platform	
							object.newX = (object.newX + platform.movespeed *dt)
						end
							
						if platform.movey == 1 and object.yvel <= 0 then
							--stood on top platform here while going down
							if platform.movespeed < 0 then
								object.newY = (platform.y-object.h  -platform.movespeed *dt)
							end
							if platform.movespeed > 0 then
								object.newY = (platform.y-object.h  +platform.movespeed *dt)
							end
						else
						
						end		
					end

				else
					object.jumping = 1
				end
						
			else
				--if we reach maximum velocity and no collision is present, invert by mass
				if object.yvel < -object.mass then
					object.yvel = -object.mass 
				end
			end
		end

	end
end

function physics:pickups(dt)
	local i, pickup
		for i, pickup in ipairs(pickups) do
			pickup.y = pickup.y + world.gravity *dt

			
			local n, platform
			for n, platform in ipairs(platforms) do
				
				if collision:check(platform.x,platform.y,platform.w,platform.h,
					pickup.x,pickup.y,pickup.gfx:getWidth(),pickup.gfx:getHeight()) then
						
						pickup.y = platform.y - pickup.gfx:getHeight() +1
						
						if platform.movex == 1 then
							-- move along x-axis with platform	
							pickup.x = (pickup.x + platform.movespeed *dt)
						end
				end
			end
			-- if pickup goes outside of world, remove it
			if pickup.y+pickup.h > world.groundLevel  then
				pickups:destroy(pickups,i)
			end
		end
end


function physics:destroy(axis,object,crate,i)
	--axis is used to determine which direction the colliding object
	--will rebound from
	if object.jumping == 1 then
		if axis == "y" then
			object.yvel = -object.yvel
		elseif axis == "x" then
			object.xvel = -object.xvel
		end
		crates:destroy(crate, i)	
	end
end



function physics:enemies(dt)
	local i, enemy
	for i, enemy in ipairs(enemies) do
		if type(enemy) == "table" then
		
			if enemy.name == "walker" then
				self:applyGravity(enemy, dt)
				self:movex(enemy, dt)
				--collide with platforms
				local n, platform
				for n, platform in ipairs(platforms) do
					if collision:check(platform.x,platform.y,platform.w,platform.h,
						enemy.x,enemy.y,enemy.w,enemy.h) then
						
						if collision:top(enemy,platform) then
							enemy.yvel = 0
							enemy.jumping = 0
							enemy.y = platform.y - enemy.h +1
						end
					end
				end
				--collide with crates
				local i,crate
				for i, crate in ipairs(crates) do
					if collision:check(crate.x,crate.y,crate.w,crate.h,
						enemy.x,enemy.y,enemy.w,enemy.h) then
						
						if collision:top(enemy,crate) then
							enemy.yvel = 0
							enemy.jumping = 0
							enemy.y = crate.y - enemy.h +1
						end
					end
				end
			
				enemy.newX = (enemy.x + enemy.xvel *dt)
				enemy.newY = (enemy.y - enemy.yvel *dt)
			end
		end
		--update new poisition
		enemy.x = enemy.newX
		enemy.y = enemy.newY
		if enemy.y +enemy.h > world.groundLevel  then
			--ai suicide	
			sound:play(sound.kill)
			table.remove(enemies, i)
		end
	end
end
