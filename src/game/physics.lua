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
	--allow extra movement whilst jumping
	local multiplier = 1.3
	

		-- x-axis friction
		if object.dir == "right" then
			--if we are not travelling at max speed
			if object.xvel < object.speed  then
				if object.jumping then
					object.xvel = (object.xvel + object.speed *multiplier *dt)
				else
					--if we were travelling left
					if object.xvel < 0 then object.xvel = (object.xvel + object.speed/multiplier *dt) end
					object.xvel = (object.xvel + object.speed *dt)
				end
			end
			
			
		end
		if object.dir == "left"  then
			--if we are not travelling at max speed
			if not (object.xvel < -object.speed)  then
				if object.jumping then
					object.xvel = (object.xvel - object.speed *multiplier *dt)
				else
					--if we were travelling right
					if object.xvel > 0 then object.xvel = (object.xvel - object.speed/ multiplier *dt) end
					object.xvel = (object.xvel - object.speed *dt)
				end
			end
		end
		
		-- increase friction when 'idle' until velocity is zero
		if object.dir == "idle" and not object.jumping  then
			if object.xvel > 0 then
				object.xvel = math.max(0,object.xvel - (object.friction *dt))
			elseif object.xvel < 0 then
				object.xvel = math.min(0,object.xvel + (object.friction *dt))
			end
		end
		
		-- velocity limits (breaks springs, find workaround)
		--object.xvel = math.min(object.speed,math.max(-object.speed,object.xvel))

		object.newX = object.x + (object.xvel *dt)

end


function physics:applyGravity(object, dt)
	--simulate gravity
	object.yvel = object.yvel - (world.gravity *dt)
	object.newY = object.y - (object.yvel *dt)
end


function physics:applyRotation(object,n,dt)
	if object.jumping then
		object.angle = object.angle + dt * n
		object.angle = object.angle % (2*math.pi)
	else
		object.angle = 0
	end
end

function physics:swing(object,dt)
	
	if not editing then 
	
		if object.reverse then
			object.angle = object.angle -(object.movespeed * dt)
		else
			object.angle = object.angle + (object.movespeed * dt)
		end

		if object.angle > math.pi then
			object.angle = math.pi
			object.reverse = true
		end

		if object.angle < 0 then
			object.angle = 0
			object.reverse = false
		end
		
	end
	
	object.x = object.radius * math.cos(object.angle) + object.xorigin 
	object.y = object.radius * math.sin(object.angle) + object.yorigin
			
end

function physics:movex(object, dt)
	-- traverse x-axis
	if object.x > object.xorigin + object.movedist then
		object.x = object.xorigin + object.movedist 
		object.movespeed = -object.movespeed
		object.dir = 0
	end	
	if object.x < object.xorigin then
		object.x = object.xorigin
		object.movespeed = -object.movespeed
		object.dir = 1
	end
	
	object.newX = object.x + object.movespeed *dt
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
	object.newY = object.y + object.movespeed *dt
end


function physics:world(dt)
	-- moving platforms etc
	
	for i, object in ipairs(world.entities.platform) do
		if object.movex then self:movex(object, dt) end
		if object.movey then self:movey(object, dt) end
		if object.swing then self:swing(object, dt) end
		
		--[[ platform texture scroll?  test this more, maybe move to platforms:update(dt)
		if object.verts then
			for _,v in ipairs(object.verts) do
				v[3] = v[3] - 4 *dt
			end
		end
		--]]
		self:update(object)
	end
	
	self:player(dt)
	self:pickups(dt)
	self:enemies(dt)		
	self:trapsworld(dt)
	self:springs(dt)
	self:checkpoints(dt)
	self:portals(dt)
	self:materials(dt)
	self:deadzone(dt)
end


function physics:deadzone(dt)
	for _,t in pairs(world.entities) do
		for n,e in ipairs(t) do
			if e.y+e.h > world.deadzone then
				e.yvel = 0
				e.xvel = 0
				e.y = world.deadzone - e.h +1 *dt
			--	console:print(e.group .. "("..n..") out of bounds (x:"..math.round(e.x).." y:"..math.round(e.y)..")")
			end
		end
	end
end

function physics:bounce(object,dt)
	object.yvel = -object.yvel/1.5
end

function physics:crates(object,dt)
	for i, crate in ipairs(world.entities.crate) do
			if collision:check(crate.x,crate.y,crate.w,crate.h,
				object.newX,object.newY,object.w,object.h) and not crate.destroyed then
				object.candrop = false
				object.carried = false
				
				if object.jumping and mode == "game" then 
					console:print("crate(" .. i..") destroyed, item ="..crate.type)
					popups:add(crate.x+crate.w/2,crate.y+crate.h/2,"+"..crate.score)
					crate.destroyed = true
					player.score = player.score+crate.score
					joystick:vibrate(0.5,0.5,0.25)
					sound:play(sound.effects["crate"])
					pickups:add(
						--TODO fix texture assignment
						crate.x+crate.w/2-pickups.textures[1]:getWidth()/2, 
						crate.y+crate.h/2-pickups.textures[1]:getHeight()/2, 
						crate.type
					)
				end
				
				if collision:top(object,crate) then
					object.carried = true
					object.newY = crate.y - object.h -1 *dt
					
					if object.jumping then
						object.yvel = player.jumpheight
					elseif object.bounce then
						self:bounce(object)
					else
						object.yvel = 0
					end
					
				--extra cheecks to stop falling underneath
				elseif collision:bottom(object,crate) and not collision:left(object,crate) and not collision:right(object,crate) then
					object.newY = crate.y +crate.h  +1 *dt

					if object.jumping then
						object.yvel = -player.jumpheight
					else
						object.yvel = 0
					end
					
				elseif collision:right(object,crate) then
					object.newX = crate.x+crate.w +1 *dt
					object.xvelboost = 0
					
					if object.jumping then
						object.xvel = player.jumpheight
					else
						object.xvel = 0
					end
					
				elseif collision:left(object,crate) then
					object.newX = crate.x-object.w -1 *dt
					object.xvelboost = 0
					
					if object.jumping then
						object.xvel = -player.jumpheight
					else
						object.xvel = 0
					end
					

				end		
			end
		end
end



function physics:materials()
	if mode == "editing" then return end
	for i, mat in ipairs(world.entities.material) do
		if world:inview(mat) then
			if collision:check(player.x,player.y,player.w,player.h,mat.x,mat.y,mat.w,mat.h) then
				if mat.type == "death" then
					player.y = mat.y-player.h
					player:die("death material @ x:".. math.floor(player.x) .. " y:"..math.floor(player.y))
				end
			end
		end
		
	end
end


function physics:bumpers(object,dt)
	for i, bumper in ipairs(world.entities.bumper) do
		if collision:check(bumper.x,bumper.y,bumper.w,bumper.h,
				object.newX,object.newY,object.w,object.h) then
			
			object.jumping = true
			bumper.scale = bumpers.maxscale
			joystick:vibrate(1,1,0.25)				
			sound:play(sound.effects["bumper"])
				
			if bumper.totalscore > 0 then
				player.score = player.score + bumper.score
				bumper.totalscore = bumper.totalscore - bumper.score
				popups:add(bumper.x+bumper.w/2,bumper.y+bumper.h/2,"+"..bumper.score)
			end

		if collision:right(object,bumper) and not collision:top(object,bumper) then
			object.newX = bumper.x+bumper.w +1 *dt
			object.xvel = bumper.force
					
			elseif collision:left(object,bumper) and not collision:top(object,bumper) then
				object.newX = bumper.x-object.w -1 *dt
				object.xvel = -bumper.force

			elseif collision:bottom(object,bumper) then
				object.newY = bumper.y +bumper.h +1 *dt
				object.yvel = -bumper.force
			
			elseif collision:top(object,bumper) then
				object.newY = bumper.y - object.h -1 *dt
				object.yvel = bumper.force
			end		
			
		end
	end
end



function physics:platforms(object, dt)
	for i, platform in ipairs(world.entities.platform) do	
			if collision:check(platform.x,platform.y,platform.w,platform.h,
					object.newX,object.newY,object.w,object.h) then
					
				-- if anything collides, check which sides did
				-- adjust position/velocity if neccesary
				
				-- only check these when clip is true
				if platform.clip then
					
					-- right side
					if collision:right(object,platform) 
					and not collision:top(object,platform) 
					and not collision:left(object,platform) then
						object.xvel = 0
						object.xvelboost = 0
						object.newX = platform.x+platform.w +1 *dt
						
					-- left side
					elseif collision:left(object,platform) 
					and not collision:top(object,platform) 
					and not collision:right(object,platform) then
						object.xvel = 0
						object.xvelboost = 0
						object.newX = platform.x-object.w -1 *dt
						
					-- bottom side	
					elseif collision:bottom(object,platform) 
					and not collision:right(object,platform) 
					and not collision:left(object,platform) then	
						object.yvel = 0		
						object.newY = platform.y +platform.h +1 *dt
			
					end
				end

				-- top side
				platform.carrying = false
				
				if collision:top(object,platform) then
					object.carried = true
					
					if platform.clip then
						object.candrop = false
					else
						object.candrop = true
					end

						
					if object.yvel < 0 then
						if object.bounce then
							self:bounce(object)
						elseif object.jumping then
							sound:play(sound.effects["hit"])
							object.jumping = false
							object.yvel = 0
						else
							object.yvel = 0
						end
							
						object.newY = platform.y - object.h +1 *dt
					end
						

					if platform.movex then
						-- move along x-axis with platform	
						object.newX = object.newX + platform.movespeed *dt
					end

					if platform.swing then	
						object.newX =  platform.radius * math.cos(platform.angle) + platform.xorigin +platform.w/2 - object.w/2
						object.newY = platform.y - object.h+1 *dt
						object.yvel = -player.jumpheight
					end

					if platform.movey and not object.jumping then
						--object.yvel = -platform.movespeed *dt
						
						if platform.movespeed <= 0 then
							--going up
							object.newY = platform.y - object.h +1 - (platform.movespeed *dt)
						else
							--going down	
							object.newY = platform.y - object.h +1 + (platform.movespeed *dt)
						end
						
					end		
						
					
					
				end

			end
		
	end
	
end

function physics:update(object)
	if object.newY then object.y = object.newY,2 end
	if object.newX then object.x = object.newX,2 end
end

function physics:pickups(dt)
	for i, pickup in ipairs(world.entities.pickup) do			
		if not pickup.collected then
			--pulls all gems to player when attract = true
			if pickup.attract then
				pickup.speed = pickup.speed + (pickups.magnet_power*2) *dt
				if player.alive then
					local angle = math.atan2(player.y+player.h/2 - pickup.h/2 - pickup.y, player.x+player.w/2 - pickup.w/2 - pickup.x)
					pickup.newX = pickup.x + (math.cos(angle) * pickup.speed * dt)
					pickup.newY = pickup.y + (math.sin(angle) * pickup.speed * dt)
				
				end
			else
				pickup.speed = 100
				self:applyGravity(pickup, dt)
				self:applyVelocity(pickup,dt)
				self:traps(pickup,dt)
				self:platforms(pickup, dt)
				self:crates(pickup, dt)			
			end
			
			self:update(pickup)
			
			if mode == "game" and not pickup.collected then	
				if player.hasmagnet then
					if collision:check(player.x-pickups.magnet_power,player.y-pickups.magnet_power,
						player.w+(pickups.magnet_power*2),player.h+(pickups.magnet_power*2),
						pickup.x, pickup.y,pickup.w,pickup.h) then

						if not pickup.attract then
							pickup.attract = true
						end
					end
				end
			
				if player.alive and collision:check(player.x,player.y,player.w,player.h,
					pickup.x, pickup.y,pickup.w,pickup.h) then
						popups:add(pickup.x+pickup.w/2,pickup.y+pickup.h/2,"+"..pickup.score)
						console:print(pickup.group.."("..i..") collected")	
						player:collect(pickup)
						pickup.collected = true

				end
			end	
		end
	end
end

	

function physics:enemies(dt)
	for i, enemy in ipairs(world.entities.enemy) do
		if enemy.alive then
			enemy.carried = false
		
			if enemy.type == "walker" then
			
				self:applyGravity(enemy, dt)
				--enemy.yorigin = enemy.newY

				self:movex(enemy, dt)	
				self:crates(enemy,dt)
				self:traps(enemy, dt)
				self:platforms(enemy, dt)
				
				--test
				--hopper enemy, move this statement to a new entity TODO
				--this is broken, enemy.carried when true for traps, gets reset to false for platforms.
				if enemy.carried then
					if enemy.x <= enemy.xorigin or enemy.x >= enemy.xorigin + enemy.movedist then
						enemy.yvel=500	
					end
				end
				
				self:update(enemy)
				
				-- NOT ACTIVE WHILST EDITING
				if mode == "game" and player.alive and collision:check(player.newX,player.newY,player.w,player.h,
					enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then
					-- if we land on top, kill enemy
					if collision:above(player,enemy) then	
						if player.jumping or player.invincible then
							
							if player.y > enemy.y then
								player.yvel = -player.jumpheight
							elseif player.y < enemy.y then
								player.yvel = player.jumpheight
							end
							popups:add(enemy.x+enemy.w/2,enemy.y+enemy.h/2,"+"..enemy.score)
							player.score = player.score + enemy.score
							enemy.alive = false
							sound:play(sound.effects["kill"])
							console:print(enemy.group .." killed")
							joystick:vibrate(0.5,0.5,0.5)
							return true
							
						else
							player:die(enemy.group)
						end
					end
				end
				
			end	
			
			if enemy.type == "floater" then
				enemy.y = enemy.yorigin - (10*math.sin(enemy.ticks*enemy.yspeed*math.pi)) + 20
				enemy.ticks = enemy.ticks +1
				self:movex(enemy, dt)
				self:update(enemy)
				
				-- NOT ACTIVE WHILST EDITING
				if mode == "game" and player.alive and collision:check(player.newX,player.newY,player.w,player.h,
					enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then

					if player.jumping or player.invincible then			
						if player.y > enemy.y then
							player.yvel = -player.jumpheight
						elseif player.y < enemy.y then
							player.yvel = player.jumpheight
						end

						popups:add(enemy.x+enemy.w/2,enemy.y+enemy.h/2,"+"..enemy.score)
						player.score = player.score + enemy.score
						enemy.alive = false
						sound:play(sound.effects["kill"])
						console:print(enemy.group .." killed")
						joystick:vibrate(0.5,0.5,0.5)
					else			
						-- otherwise we die			
						player:die(enemy.group)
					end
				end
			
			end
			
			if enemy.type == "spike" or enemy.type == "spike_large" then
				-- NOT ACTIVE WHILST EDITING
				if mode == "game" and player.alive and  collision:check(player.newX,player.newY,player.w,player.h,
					enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then
					player.yvel = -player.yvel
					player:die(enemy.group)
				end
			end
			
			
			if enemy.type == "icicle" then
				if enemy.falling then
					
					self:applyGravity(enemy, dt)
					
					--kill enemies hit by icicle
					local i,e
					for i, e in ipairs(world.entities.enemy) do
						if e.alive and not (e.type == "icicle") then
							if collision:check(e.x,e.y,e.w,e.h,
							enemy.x,enemy.newY,enemy.w,enemy.h) then
								e.alive = false
								sound:play(sound.effects["kill"])
								console:print(e.group .. " killed by " .. enemy.group)
							end
						end
					end
					
					--stop falling when colliding with platform
					local i,platform
					for i,platform in ipairs(world.entities.platform) do
							if collision:check(platform.x,platform.y,platform.w,platform.h,
								enemy.x,enemy.newY,enemy.w,enemy.h) then
								
								if platform.clip and not platform.movex and not platform.movey then
									enemy.falling = false
									sound:play(sound.effects["slice"])
									enemy.type = "icicle_d"
									enemy.h = enemies.textures[enemy.type]:getHeight()
									enemy.newY = platform.y-enemy.h
									joystick:vibrate(0.35,0.35,0.5)
								end
							end
						
					end
					
					self:update(enemy)

				else
					--make dropped spikes act like platforms???
				end
				
				-- NOT ACTIVE WHILST EDITING
				if mode == "game" and player.alive then
					if collision:check(player.newX,player.newY,player.w,player.h,
						enemy.x-50,enemy.y,enemy.w+50,enemy.h+200) and enemy.y == enemy.yorigin then
						enemy.falling = true
					end
			
					if collision:check(player.newX,player.newY,player.w,player.h,
						enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) and enemy.falling then
						if not player.invincible then
							player.yvel = -player.yvel
							player:die(enemy.group)
						end
					end
				end
			end
			
			if enemy.type == "spikeball" then
				enemy.angle = enemy.angle - (enemy.speed * dt)
				
				if enemy.angle > math.pi*2 then enemy.angle = 0 end
		
				enemy.newX = enemy.radius * math.cos(enemy.angle) + enemy.xorigin
				enemy.newY = enemy.radius * math.sin(enemy.angle) + enemy.yorigin
					
				self:update(enemy)
				
				-- NOT ACTIVE WHILST EDITING
				if mode == "game" and player.alive and collision:check(player.newX,player.newY,player.w,player.h,
					enemy.x-enemy.w/2+5,enemy.y-enemy.h/2+5,enemy.w-10,enemy.h-10)  then
					
					if not player.invincible then
						player.yvel = -player.yvel
						player:die(enemy.group)
					end
				end
			end
	
		end
	end	
end




function physics:player(dt)
	if editing then return end
	if player.alive  then
		player.carried = false
		self:applyVelocity(player, dt)
		self:applyGravity(player, dt)
		self:applyRotation(player,math.pi*8,dt)
	
		self:traps(player,dt)
		self:crates(player,dt)
		self:bumpers(player,dt)
		self:platforms(player, dt)
		self:update(player)
			
	else
		--death physics (float up)
		player.y = player.y - (250 * dt)
		if player.y < player.newY-600 then
			player.lives = player.lives -1
			player:respawn()
		end		
	end
end

function physics:trapsworld(dt)
	for i, trap in ipairs(world.entities.trap) do
		if trap.falling and trap.active then
			trap.timer = math.max(0, trap.timer - dt)

			if trap.timer <= 0 then

				if trap.type == "brick" then
					trap.segments[1].x = trap.segments[1].x - trap.xvel *dt
					trap.segments[2].x = trap.segments[2].x + trap.xvel *dt
					trap.segments[3].x = trap.segments[3].x - trap.xvel*0.5 *dt
					trap.segments[4].x = trap.segments[4].x + trap.xvel*0.5 *dt
				end
			
				physics:applyGravity(trap, dt)
				physics:update(trap)
				if not world:inview(trap) then
					trap.active = false
				end

			end
		end	
	end
end

function physics:checkpoints(dt)
	if mode == "editing" then return end
	for i, checkpoint in ipairs(world.entities.checkpoint) do
		if world:inview(checkpoint) then
			if collision:check(player.x,player.y,player.w,player.h,
				checkpoint.x, checkpoint.y,checkpoint.w,checkpoint.h) then
				if not checkpoint.activated then
					popups:add(checkpoint.x+checkpoint.w/2,checkpoint.y+checkpoint.h/2,"CHECKPOINT")
					console:print("checkpoint activated")	
					world:savestate()
					sound:play(sound.effects["checkpoint"])
					checkpoint.activated = true
					player.spawnX = checkpoint.x+(checkpoint.w/2)-player.w/2
					player.spawnY = checkpoint.y+checkpoint.h-player.h	
				end
			end
		end
	end
end


function physics:traps(object, dt)
	for i, trap in ipairs(world.entities.trap) do
		if trap.active then
			if collision:check(object.newX,object.newY,object.w,object.h, trap.x,trap.y,trap.w,trap.h) then
				if trap.type == "log" or trap.type == "bridge" then
					if collision:top(object,trap) and object.yvel < 0 then
						object.newY = trap.y - object.h -1 *dt
						object.carried = true
						
						if object.jumping then
							object.jumping = false
						elseif object.bounce then
							self:bounce(object)
						end
						
						object.yvel = 0			
						
						-- only player can make logs fall
						if object.group == "players" then
							if mode == "game" then
								trap.falling = true
								joystick:vibrate(0.35,0.35,0.5)
								sound:play(sound.effects["creek"])
							end
						end
					end		
				end	
				
				if trap.type == "brick" then
					if not trap.falling then
						if collision:right(object,trap) and not collision:top(object,trap) then
							object.newX = trap.x+trap.w +1 *dt
							object.xvel = 0
					
						elseif collision:left(object,trap) and not collision:top(object,trap) then
							object.newX = trap.x-object.w -1 *dt
							object.xvel = 0

						elseif collision:bottom(object,trap) then
							object.newY = trap.y +trap.h +1 *dt
							object.yvel = 0
			
						elseif collision:top(object,trap) then
							object.carried = true
							
							
							
							if object.jumping then
								object.newY = trap.y - object.h -1 *dt
								object.yvel = math.max(-object.yvel/1.5,player.jumpheight/2)
									if mode == "game" and object.group == "players" then
										popups:add(trap.x+trap.w/2,trap.y+trap.h/2,"+"..trap.score)
										player.score = player.score +trap.score
										world:sendtofront(world.entities.trap,i)
										trap.yvel = 500							
										trap.falling = true
										sound:play(sound.effects["brick"])
										joystick:vibrate(0.4,0.4,0.5)
										camera:shake(8, 1, 30, 'XY')
									end
							else
								object.newY = trap.y - object.h -1 *dt
								object.yvel = 0
							end
							
							
						end	
					end	
				end	
			end
		end
	end
end

function physics:portals(dt)
	if mode == "editing" then return end
	for i, portal in ipairs(world.entities.portal) do
		if world:inview(portal) then
			if collision:check(player.x,player.y,player.w,player.h,
				portal.x, portal.y,portal.w,portal.h) then
					
					if portal.type == "goal" then
						if not portal.activated then
							--add paramater for "next map"?
							portal.activated = true
							portal.gfx = portals.textures["goal_activated"]
							popups:add(portal.x+portal.w/2,portal.y+portal.h/2,"LEVEL COMPLETE")
							sound:play(sound.effects["goal"])
							sound:playbgm(10)
							console:print("goal reached")	
							world:endoflevel()
						end
					end
			end
		end
	end
end

function physics:springs(dt)
	if editing then return end
	for i, spring in ipairs(world.entities.spring) do
		if world:inview(spring) then
			if collision:check(player.x,player.y,player.w,player.h,
				spring.x, spring.y,spring.w,spring.h) then
				player.jumping = true
				joystick:vibrate(1,1,0.25)
				sound:play(sound.effects["spring"])
				if spring.dir == 0 then
					player.y = spring.y-player.h -1 *dt
					player.yvel =  spring.vel
				elseif spring.dir == 2 then
					player.y = spring.y +spring.h +1 *dt
					player.yvel = -spring.vel
				elseif spring.dir == 1 then
					player.x = spring.x +spring.w +1 *dt
					player.xvel = spring.vel
				elseif spring.dir == 3 then
					player.x = spring.x -player.w -1 *dt
					player.xvel = -spring.vel
				end
			end
		end
	end
end













