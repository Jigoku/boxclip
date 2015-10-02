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
			object.xvel = (object.xvel - ((world.gravity+object.speed)/4 *dt))
			if object.xvel < 0 then object.xvel = 0 end
		elseif object.xvel < 0 then
			object.xvel = (object.xvel + ((world.gravity+object.speed)/4 *dt))
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
	object.yvel = util:round((object.yvel - ((world.gravity+object.mass) *dt)),0)
end

function physics:apply(object, dt)


	physics:applyVelocity(object, dt)
	physics:applyGravity(object, dt)

	
	--new position, friction/velocity multipier
	object.newX = (object.x + object.xvel *dt)
	object.newY = (object.y - object.yvel *dt)
	

		

	--loop solid structures
	local i, structure
		for i, structure in ipairs(structures) do
		
		--move the platforms! 
		if structure.movex == 1 then structures:movex(structure, dt) end
		if structure.movey == 1 then structures:movey(structure, dt) end
		
		if object.alive == 1 then
				
			if collision:check(object,structure) then
					
					--sounds on collision
					if object.jumping == 1 and structure.name == "platform" then
						--sound:play(sound.hit)
					end
					
					if object.jumping == 1 and structure.name == "crate" then
						sound:play(sound.crate)
					end
					
					-- if anything collides, check which sides did
					-- adjust position/velocity if neccesary
					
					
					if collision:right(object,structure)  then
								-- this seems to work
							if structure.name == "platform" then
								if structure.movex == 1 then
									if structure.movespeed > -1 then
										object.newX = object.x + structure.movespeed *dt
									elseif structure.movespeed < -1 then
										object.newX = object.x - structure.movespeed *dt
									end
								else
									object.xvel = 0
									object.newX = structure.x+structure.w +1 --push away from right side
								end
							end	
							
							if structure.name == "crate" then
								object.xvel = -object.xvel
								object.newX = structure.x+structure.w +1
								structures:destroy(structure, i)
							end
	
						elseif collision:left(object,structure)  then
							-- this seems to work
							if structure.name == "platform" then	
								if structure.movex == 1 then
									if structure.movespeed > 0 then
										object.newX = object.x + structure.movespeed *dt
									elseif structure.movespeed < 0 then
										object.newX = object.x - structure.movespeed *dt
									end
								else
									object.xvel = 0
									object.newX = structure.x-object.w -1 --push away from left side
								end
							end
							
							if structure.name == "crate"  then
								object.xvel = -object.xvel
								object.newX = structure.x-object.w -1
								structures:destroy(structure, i)
							end
							
						elseif collision:bottom(object,structure) then	
							if structure.name == "platform" then
								object.yvel = 0
								 --push away from bottom
								if structure.movey == 1 and structure.movespeed > 0 then
									object.newY = structure.y +structure.h +10 -- seems okay with +10 here too?
								else 
									object.newY = structure.y +structure.h +1
								end				
							end
							
							if structure.name == "crate" then
								object.yvel = -object.yvel
								object.newY = structure.y +structure.h +1
								structures:destroy(structure, i)
							end
							
						elseif collision:top(object,structure) then
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
										-- bug here, bounces alot	
								end		
							end
							
							if structure.name == "crate"  then
								object.newY = structure.y - object.h +1
								object.yvel = -object.yvel
								structures:destroy(structure, i)
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
		if object.y >= world.groundLevel  then
			object.yvel = 0
			object.jumping = 0
			object.y = world.groundLevel
		end
	end
	


end
 
