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


function physics:movey(object, dt)

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

function physics:world(dt)


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


function physics:crates(object,dt)
	if mode == "editing" then return end
	local i, crate
	for i, crate in ipairs(crates) do
		
		
		if collision:check(crate.x,crate.y,crate.w,crate.h,
			object.newX,object.newY,object.w,object.h) and not crate.destroyed then
				
			if object.jumping == 1 then 
				crate.destroyed = true
				sound:decide(crate)
			end
					
			if collision:right(object,crate) then
				if object.jumping == 1 then
					object.newX = crate.x+crate.w +1
					object.xvel = -object.mass
					self:destroy("x",object,crate,i)
				else
					object.newX = crate.x+crate.w +1 *dt
					object.xvel = 0
				end
			elseif collision:left(object,crate) then
				if object.jumping == 1 then
					object.newX = crate.x-object.w -1
					object.xvel = object.mass
					self:destroy("x",object,crate,i)
				else
					object.newX = crate.x-object.w -1 *dt
					object.xvel = 0
				end
			elseif collision:bottom(object,crate) then
				if object.jumping == 1 then
					object.newY = crate.y +crate.h +1
					object.yvel = object.mass
					self:destroy("y",object,crate,i)
				else
					object.newY = crate.y +crate.h  +1 *dt
					object.yvel = 0
				end
			elseif collision:top(object,crate) then
				if object.jumping == 1 then
					object.newY = crate.y - object.h -1
					object.yvel = -object.mass
					self:destroy("y",object,crate,i)
				else
					object.newY = crate.y - object.h 
					object.yvel = 0
				end
			end		
		end
	end	
end

function physics:platforms(object, dt)
	--loop solid platforms
	
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
							object.newX = platform.x+platform.w +1 *dt
						end
					end	
					
				-- left side
				elseif collision:left(object,platform) then
					
					if platform.name == "platform" then	
						if not (platform.movex == 1 or platform.movey == 1) then
							object.xvel = 0
							object.newX = platform.x-object.w -1 *dt
						end
					end
					
				-- bottom side	
				elseif collision:bottom(object,platform) then	
				
					if platform.name == "platform" then
						if not (platform.movey == 1 or platform.movex == 1) then 
							object.yvel = 0
							object.newY = platform.y +platform.h +1 *dt
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
							object.newY = platform.y - object.h +1 *dt
						end
					
						
						if platform.movex == 1 and object.yvel == 0 then
							-- move along x-axis with platform	
							object.newX = (object.newX + platform.movespeed *dt)
						end
							
						if platform.movey == 1 and object.yvel <= 0 then
							--stood on top platform here while going down
							if platform.movespeed < 0 then
								object.newY = (platform.y-object.h -platform.movespeed *dt)
							end
							if platform.movespeed > 0 then
								object.newY = (platform.y-object.h +platform.movespeed *dt)
							end
						else
						
						end		
					end

				else
					--object.jumping = 1
				end
						
			else
				--if we reach maximum velocity and no collision is present, invert by mass
				if object.yvel < -object.mass then
					object.yvel = -object.mass 
				end
			end
		end

	
end

function physics:pickups(dt)
	local i, pickup
		for i, pickup in ipairs(pickups) do
			self:applyGravity(pickup, dt)
			
			pickup.newX = (pickup.x + pickup.xvel *dt)
			pickup.newY = (pickup.y - pickup.yvel *dt)
			
			self:platforms(pickup, dt)
			self:crates(pickup, dt)
		
			--update new poisition
			pickup.x = pickup.newX
			pickup.y = pickup.newY
			
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
		crates:addpickup(crate, i)	
	end
end



function physics:enemies(dt)
	local i, enemy
	for i, enemy in ipairs(enemies) do
		if type(enemy) == "table" and enemy.alive then
		
			if enemy.name == "walker" then
				self:applyGravity(enemy, dt)
				self:movex(enemy, dt)
			end
			
			enemy.newX = (enemy.x + enemy.xvel *dt)
			enemy.newY = (enemy.y - enemy.yvel *dt)
			
			if enemy.name == "walker" then
				self:platforms(enemy, dt)
				self:crates(enemy, dt)
			end
		end

		enemy.x = enemy.newX
		enemy.y = enemy.newY
		
		if enemy.y +enemy.h > world.groundLevel  then
			--ai suicide	
			sound:play(sound.kill)
			table.remove(enemies, i)
		end
	end
end

function physics:player(dt)
	if editing then return end
		self:applyVelocity(player, dt)
		self:applyGravity(player, dt)
		
		player.newX = (player.x + player.xvel *dt)
		player.newY = (player.y - player.yvel *dt)
		
		self:crates(player,dt)
		self:platforms(player, dt)

		player.x = player.newX
		player.y = player.newY
	
		if player.y+player.h > world.groundLevel  then
			player:respawn()
		end
end
