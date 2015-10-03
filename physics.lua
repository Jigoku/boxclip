physics = {}

function physics:kill(object,dt)
	-- move the dead character off screen (like sonic 1, down and off camera)
	love.audio.play( sound.die )
end


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


function physics:movex(structure, dt)
	-- traverse x-axis
	if structure.x > structure.xorigin + structure.movedist then
		structure.x = structure.xorigin + structure.movedist
		structure.movespeed = -structure.movespeed
	end	
	if structure.x < structure.xorigin then
		structure.x = structure.xorigin
		structure.movespeed = -structure.movespeed
	end
	structure.x = (structure.x + structure.movespeed *dt)
end


function physics:movey(structure, dt)
	--traverse y-axis
	if structure.y > structure.yorigin + structure.movedist then
		structure.y = structure.yorigin + structure.movedist
		structure.movespeed = -structure.movespeed
	end
	if structure.y < structure.yorigin  then
		structure.y = structure.yorigin
		structure.movespeed = -structure.movespeed
	end
	structure.y = (structure.y + structure.movespeed *dt)
end

function physics:moveStructures(dt)
	-- moving platforms etc
	local i, structure
	for i, structure in ipairs(structures) do
		if structure.movex == 1 then physics:movex(structure, dt) end
		if structure.movey == 1 then physics:movey(structure, dt) end
	end
end


function physics:player(object, dt)

	self:applyVelocity(object, dt)
	self:applyGravity(object, dt)

	--new position, friction/velocity multipier
	object.newX = (object.x + object.xvel *dt)
	object.newY = (object.y - object.yvel *dt)
	
	--loop solid structures
	local i, structure
	for i, structure in ipairs(structures) do
		--move the platforms! 
		-- structure.newX == physics:movex(structure,dt)  <--- (ret val)???

		
		if object.alive == 1 then
				
			if collision:check(structure.x,structure.y,structure.w,structure.h,
					object.newX,object.newY,object.w,object.h) then
					
				--sounds on collision
				if object.jumping == 1 then 
					sound:decide(structure)
				end
	
					
				-- if anything collides, check which sides did
				-- adjust position/velocity if neccesary
					
				-- right side
				if object.newX <= structure.x+structure.w and 
					(object.x > (structure.x+structure.w) )  then
					
					if structure.name == "platform" then
						if structure.movex == 1 then
							object.xvel = -object.xvel
						else
							object.xvel = 0
							object.newX = structure.x+structure.w +1
						end
					end	

					if structure.name == "crate" then
						object.newX = structure.x+structure.w +1
						self:crateReboundX(object,structure,i)
					end
					
				-- left side
				elseif object.newX+object.w >= structure.x and 
					(object.x+object.w < structure.x)  then
					
					if structure.name == "platform" then	
						if structure.movex == 1 then
							object.xvel = -object.xvel
						else
							object.xvel = 0
							object.newX = structure.x-object.w -1
						end
					end
							
					if structure.name == "crate"  then
						object.newX = structure.x-object.w -1
								
						self:crateReboundX(object,structure,i)
					end
					
				-- bottom side	
				elseif object.newY <= structure.y+structure.h and 
					(object.y+object.h > (structure.y+structure.h)) then	
				
					if structure.name == "platform" then
						object.yvel = 0
						if structure.movey == 1 and structure.movespeed > 0 then
							object.newY = structure.y +structure.h +10 -- improve this...
						else 
							object.newY = structure.y +structure.h +1
						end				
					end
							
					if structure.name == "crate" then
						object.newY = structure.y +structure.h +1
						self:crateReboundY(object,structure,i)
					end
					
				-- top side
				elseif object.newY+object.h >= structure.y  and 
					(object.y < structure.y ) then
					
					if structure.name == "platform" then
						object.yvel = 0
						object.jumping = 0
						object.newY = structure.y - object.h +1
						if structure.movex == 1 then
							-- move along x-axis with platform	
							object.newX = (object.newX + structure.movespeed *dt)
						end
							
						if structure.movey == 1 and structure.movespeed >= 0  then
							--stood on top platform here while going down
							object.newY = (structure.y-object.h  +structure.movespeed *dt)
						end		
					end
							
					if structure.name == "crate"  then
						object.newY = structure.y - object.h +1
						self:crateReboundY(object,structure,i)
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
			
		else
			physics:kill(object, dt)
		end
	end

	-- update new poisition
	object.x = object.newX
	object.y = object.newY
	
	if object.alive == 1 then
		-- stop increasing velocity if we hit ground
		if object.y > world.groundLevel  then
			object.yvel = 0
			object.jumping = 0
			object.y = world.groundLevel
		end
	end

end


function physics:pickups(dt)
	local i, pickup
		for i, pickup in ipairs(pickups) do
			pickup.y = pickup.y + world.gravity *dt
			
			local n, structure
			for n, structure in ipairs(structures) do
				
				if collision:check(structure.x,structure.y,structure.w,structure.h,
					pickup.x-pickup.gfx:getWidth()/2,pickup.y-pickup.gfx:getHeight()/2,pickup.gfx:getWidth(),pickup.gfx:getHeight()) then
						
						pickup.y = structure.y - pickup.gfx:getHeight()/2 +1
						
						if structure.movex == 1 then
							-- move along x-axis with platform	
							pickup.x = (pickup.x + structure.movespeed *dt)
						end
				end
				if pickup.y > world.groundLevel  then
					pickup.y = world.groundLevel + pickup.gfx:getHeight()/2 +1
				end
			end
		end
end


function physics:crateReboundY(object,structure,i)
	if object.jumping == 1 then
		object.yvel = -object.yvel
		structures:destroy(structure, i)	
	end
end


function physics:crateReboundX(object,structure,i)
	if object.jumping == 1 then
		object.xvel = -object.xvel
		structures:destroy(structure, i)	
	end
end
