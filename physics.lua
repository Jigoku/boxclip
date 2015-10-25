--[[
 * Copyright (C) 2015 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 --]]

physics = {}

function physics:applyVelocity(object, dt) 
	if object.alive == 1 then
		-- x-axis friction
		if object.dir == "right" then
			if object.xvel < object.speed then
				if object.jumping == 1 then
					object.xvel = (object.xvel + ((world.gravity+object.speed)/1.5 *dt))
				else
					object.xvel = (object.xvel + ((world.gravity+object.speed) *dt))
				end
			end
		end
		if object.dir == "left"  then
			if not (object.xvel < -object.speed)  then
				if object.jumping == 1 then
					object.xvel = (object.xvel - ((world.gravity+object.speed)/1.5 *dt))
				else
					object.xvel = (object.xvel - ((world.gravity+object.speed) *dt))
				end
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
				
		--boost (spring forces etc)
		if object.xvelboost > 0 then
			object.xvelboost = (object.xvelboost - ((world.gravity+object.mass) *dt))
			if object.xvelboost < 0 then object.xvelboost = 0 end
		elseif object.xvelboost < 0 then
			object.xvelboost = (object.xvelboost + ((world.gravity+object.mass) *dt))
			if object.xvelboost > 0 then object.xvelboost = 0 end
		end

		object.newX = (object.x + (object.xvel+object.xvelboost)  *dt)
		
	end
end


function physics:applyGravity(object, dt)
	--simulate gravity
	object.yvel = math.round((object.yvel - ((world.gravity+object.mass*2) *dt)),0)
	
	--stop increasing velocity if we hit this limit
	if object.yvel < -world.gravity*4 then 
		object.yvel = -world.gravity*4 
	end
	
	object.newY = (object.y - object.yvel *dt)
end


function physics:applyRotation(object,n,dt)
	if object.jumping == 1 then
		object.angle = object.angle + dt * n
		object.angle = object.angle % (2*math.pi)
	else
		object.angle = 0
	end
end


function physics:movex(object, dt)
	-- traverse x-axis
	if object.x >= object.xorigin + object.movedist then
		object.x = object.xorigin + object.movedist
		object.movespeed = -object.movespeed
		object.dir = "left"
	end	
	if object.x <= object.xorigin then
		object.x = object.xorigin
		object.movespeed = -object.movespeed
		object.dir = "right"
	end
	object.x = (object.x + object.movespeed *dt)
end


function physics:movey(object, dt)
	--traverse y-axis
	if object.y >= object.yorigin + object.movedist then
		object.y = object.yorigin + object.movedist
		object.movespeed = -object.movespeed 
	end
	if object.y <= object.yorigin  then
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

end


function physics:crates(object,dt)
	if mode == "editing" then return end
	local i, crate
	for i, crate in ipairs(crates) do
			if collision:check(crate.x,crate.y,crate.w,crate.h,
				object.newX,object.newY,object.w,object.h) and not crate.destroyed then
				
				if object.jumping == 1 then 
					util:dprint("crate(" .. i..") destroyed, item ="..crate.item)
					crate.destroyed = true
					player.score = player.score+crate.score
					sound:play(sound.crate)
					crates:addpickup(crate, i,true)	
				end
					
				if collision:right(object,crate) then
					if object.jumping == 1 then
						object.newX = crate.x+crate.w +1
						object.xvel = object.mass
					else
						object.newX = crate.x+crate.w +1 *dt
						object.xvel = 0
					end
				elseif collision:left(object,crate) then
					if object.jumping == 1 then
						object.newX = crate.x-object.w -1
						object.xvel = -object.mass
					else
						object.newX = crate.x-object.w -1 *dt
						object.xvel = 0
					end
				elseif collision:bottom(object,crate) then
					if object.jumping == 1 then
						object.newY = crate.y +crate.h +1
						object.yvel = -object.mass
					else
						object.newY = crate.y +crate.h  +1 *dt
						object.yvel = 0
					end
				elseif collision:top(object,crate) then
					if object.jumping == 1 then
						object.newY = crate.y - object.h -1
						object.yvel = object.mass
						
					else
						object.newY = crate.y - object.h -1 *dt
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
		
			if collision:check(platform.x,platform.y,platform.w,platform.h,
					object.newX,object.newY,object.w,object.h) then
					
				-- if anything collides, check which sides did
				-- adjust position/velocity if neccesary
				
				-- only check these when clip is true
				if platform.clip == 1 then
					-- right side
					if collision:right(object,platform) and not collision:top(object,platform) then
	
						object.xvel = 0
						object.newX = platform.x+platform.w +1 *dt

					
					-- left side
					elseif collision:left(object,platform) and not collision:top(object,platform) then
						object.xvel = 0
						object.newX = platform.x-object.w -1 *dt
						
					-- bottom side	
					elseif collision:bottom(object,platform) then	
						object.yvel = 0
						object.newY = platform.y +platform.h +1 *dt
					end
				end
				
				-- top side
				if collision:top(object,platform)  then
					
					if platform.name == "platform" then
						--sounds on collision
						if object.jumping == 1 and (object.yvel < 0) then 
							sound:play(sound.hit)
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
							--going up
							if platform.movespeed < 0 then
								object.newY = (platform.y-object.h -platform.movespeed *dt)
							end
							--going down
							if platform.movespeed > 0 then
								object.newY = (platform.y-object.h +platform.movespeed *dt)
							end
						else
						
						end		
					end
				end
			end
	end
end

function physics:pickups(dt)
	local i, pickup
		for i, pickup in ipairs(pickups) do
			self:applyGravity(pickup, dt)
			pickup.newX = (pickup.x + pickup.xvel *dt)
			
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



function physics:enemies(dt)
	local i, enemy
	for i, enemy in ipairs(enemies) do
		if type(enemy) == "table" and enemy.alive then
		
			if enemy.name == "walker" then
				self:applyGravity(enemy, dt)
				self:movex(enemy, dt)
				enemy.newX = (enemy.x + enemy.xvel *dt)

				self:platforms(enemy, dt)
				self:crates(enemy, dt)
				enemy.x = enemy.newX
				enemy.y = enemy.newY
				
				if enemy.y +enemy.h > world.groundLevel  then
					--ai suicide	
					util:dprint(enemy.name .. "("..i..") suicided")
					sound:play(sound.kill)
					table.remove(enemies, i)
					
				end
			end	
			
			if enemy.name == "floater" then
				self:movex(enemy, dt)
			end
		end
	end
end


function physics:player(dt)
	if editing then return end
		self:applyVelocity(player, dt)
		self:applyGravity(player, dt)
		self:applyRotation(player,math.pi*8,dt)
		
		self:crates(player,dt)
		self:platforms(player, dt)

		player.x = player.newX
		player.y = player.newY
	
		if not (mode == "editing") and player.y+player.h > world.groundLevel  then
			player:die("out of bounds")
		end
end
