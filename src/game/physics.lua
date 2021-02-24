--[[
 * Copyright (C) 2015 - 2018 Ricky K. Thomson
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

	if not object.sliding then
		-- x-axis friction
		if object.dir == 1 then
			--if we are not travelling at max speed
			if object.xvel < object.speed then
				if object.jumping then
					object.xvel = (object.xvel + object.speed *multiplier *dt)
				else
					--if we were travelling left
					if object.xvel < 0 then object.xvel = (object.xvel + object.speed/multiplier *dt) end
					object.xvel = (object.xvel + object.speed *dt)
				end
			end

		end
		if object.dir == -1 then
			--if we are not travelling at max speed
			if not (object.xvel < -object.speed) then
				if object.jumping then
					object.xvel = (object.xvel - object.speed *multiplier *dt)
				else
					--if we were travelling right
					if object.xvel > 0 then object.xvel = (object.xvel - object.speed/ multiplier *dt) end
					object.xvel = (object.xvel - object.speed *dt)
				end
			end
		end
	else
		if object.xvel == 0 then
			object.sliding = false
		end
	end

	-- increase friction when 'idle' until velocity is zero
	if (object.dir == 0 or object.sliding) and not object.jumping then
		object.dir = object.lastdir
		if object.xvel > 0 then
			object.xvel = math.max(0,object.xvel - ((object.sliding and object.friction/2 or object.friction) *dt))
		elseif object.xvel < 0 then
			object.xvel = math.min(0,object.xvel + ((object.sliding and object.friction/2 or object.friction) *dt))
		end
	end

	-- velocity limits (breaks springs, find workaround)
	--object.xvel = math.min(object.speed,math.max(-object.speed,object.xvel))
	object.newX = object.x + (object.xvel *dt)
end


function physics:applyGravity(object, dt)
	--simulate gravity
	if editing and object.selected then
		object.newY = object.y
	else
		object.yvel = object.yvel - (world.gravity *dt)
		object.newY = object.y - (object.yvel *dt)
	end
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
		elseif object.angle < 0 then
			object.angle = 0
			object.reverse = false
		end
	end
	object.x_old = object.x 
	object.x = object.radius * math.cos(object.angle) + object.xorigin - object.w/2
	object.x_dist =  object.x - object.x_old
	
	object.y_old = object.y 
	object.y = object.radius * math.sin(object.angle) + object.yorigin
	object.y_dist =  object.y - object.y_old
end


function physics:movex(object, dt)

	if editing and object.selected then
		-- traverse x-axis
		object.newX = object.x
	else

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
end


function physics:movey(object, dt)
	--traverse y-axis
	if editing and object.selected then
		object.newY = object.y
	else
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
end


function physics:world(dt)
	self:trapsworld(dt)
	self:deadzone(dt)
end


function physics:deadzone(dt)
	for _,t in pairs(world.entities) do
		for n,e in ipairs(t) do
			if e.y+e.h > world.deadzone then
				e.yvel = 0
				e.xvel = 0
				e.y = world.deadzone - e.h +1 *dt

				if not e.out_of_bounds then
					console:print(e.group .. "("..n..") out of bounds (x:"..math.round(e.x).." y:"..math.round(e.y)..")")
					e.out_of_bounds = true
				end
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

			if (object.jumping or object.sliding) and mode == "game" then
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

			if not object.sliding then
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

				--extra checks to stop falling underneath
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
end


function physics:bumpers(object,dt)
	for i, bumper in ipairs(world.entities.bumper) do
		if collision:check(bumper.x,bumper.y,bumper.w,bumper.h,
				object.newX,object.newY,object.w,object.h) then

			object.jumping = true
			object.sliding = false

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
					object.newY = platform.y + platform.h +1 *dt
					-- bottom side
				end
			end

			-- top side
			platform.carrying = false

			if collision:top(object,platform) then
				object.carried = true
				platform.carrying = true

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

				if object.xvel ~= 0 and object.sliding then
					sound:play(sound.effects["slide"])
				else
					object.sliding = false
				end

				if platform.movex then
					-- move along x-axis with platform
					object.newX = object.newX + platform.movespeed *dt

					--[[
					if platform.carrying then
						platform.y = math.min(platform.yorigin+10, platform.y+200*dt)

					else
						-- this doesn't work?
						platform.y = math.max(platform.yorigin, platform.y-200*dt)
					end
					--]]
				end

				if platform.swing then
					-- object.newX =  platform.radius * math.cos(platform.angle) + platform.xorigin +platform.w/2 - object.w/2
					object.newX =  object.newX + platform.x_dist
					object.newY = platform.y - object.h+1 *dt
					object.yvel = -player.jumpheight
					-- object.xvel = 0
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
	if object.newY then object.y = object.newY end
	if object.newX then object.x = object.newX end
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

						if not (object.group == "pickup") then
							object.yvel = 0
						end

						-- only player can make logs fall
						if object.group == "players" then
							if mode == "game" then
								trap.falling = true
								joystick:vibrate(0.25,0.25,0.5)
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
								if object.xvel ~= 0 and object.sliding then
									sound:play(sound.effects["slide"])
								else
									object.sliding = false
								end

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
