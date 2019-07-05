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

enemies = {}

-- TODO, split this up into seperate entities...
-- eg; floater.lua, walker.lua, etc

enemies.textures = {
	["walker" ] = textures:load("data/images/enemies/cube_monster/" ),
	["hopper" ] = textures:load("data/images/enemies/green_monster/"),
	["bee"    ] = textures:load("data/images/enemies/grumpy_bee/"   ),
	["bird"   ] = textures:load("data/images/enemies/bird/"    ),
	["blob"   ] = textures:load("data/images/enemies/blob/"    ),
	
	["spike"] = { 
		love.graphics.newImage( "data/images/enemies/spike.png"),
	},
	
	["spike_large"] = {
		love.graphics.newImage( "data/images/enemies/spike_large.png"),
	},
	
	["spike_timer"] = { 
		love.graphics.newImage( "data/images/enemies/spike.png"),
	},
	
	["icicle"] = { 
		love.graphics.newImage( "data/images/enemies/icicle.png"),
	},
	
	["icicle_d"] = { 
		love.graphics.newImage( "data/images/enemies/icicle_d.png"),
	},
	
	["spikeball"] = { 
		love.graphics.newImage( "data/images/enemies/spikeball.png"),
	}
}	


table.insert(editor.entities, {"spike", "enemy"})
table.insert(editor.entities, {"spike_large", "enemy"})
table.insert(editor.entities, {"spike_timer", "enemy"})
table.insert(editor.entities, {"icicle", "enemy"})
table.insert(editor.entities, {"walker", "enemy"})
table.insert(editor.entities, {"blob", "enemy"})
table.insert(editor.entities, {"hopper", "enemy"})
table.insert(editor.entities, {"bee",  "enemy"})
table.insert(editor.entities, {"bird",  "enemy"})
table.insert(editor.entities, {"spikeball", "enemy"})
	

function enemies:add(x,y,movespeed,movedist,dir,name)

	if name == "walker" then
	
		local texture = self.textures[name][1]
		table.insert(world.entities.enemy, {
			movespeed = movespeed or 100,
			movedist = movedist or 200,
			movex = 1,
			dir = 0,
			xorigin = x,
			yorigin = y,
			x = love.math.random(x,x+movedist) or 0,
			y = y or 0,
			texture = texture,
			w = texture:getWidth(),
			h = texture:getHeight(),
			framecycle = 0,
			frame = 1,
			framedelay = 0.001,
			group = "enemy",
			type = name,
			xvel = 0,
			yvel = 0,
			dir = 0,
			alive = true,
			score = 100
		})
		
	elseif name == "blob" then
	
		local texture = self.textures[name][1]
		table.insert(world.entities.enemy, {
			movespeed = movespeed or 300,
			movedist = movedist or 200,
			movex = 1,
			dir = 0,
			xorigin = x,
			yorigin = y,
			x = love.math.random(x,x+movedist) or 0,
			y = y or 0,
			texture = texture,
			w = texture:getWidth(),
			h = texture:getHeight(),
			framecycle = 0,
			frame = 1,
			framedelay = 0.025,
			group = "enemy",
			type = name,
			xvel = 0,
			yvel = 0,
			dir = 0,
			alive = true,
			score = 100
		})
			
	
	elseif name == "hopper" then
		local texture = self.textures["hopper"][1]
		table.insert(world.entities.enemy, {
			movespeed = movespeed or 100,
			movedist = movedist or 200,
			movex = 1,
			dir = 0,
			xorigin = x,
			yorigin = y,
			x = love.math.random(x,x+movedist) or 0,
			y = y or 0,
			texture = texture,
			w = texture:getWidth(),
			h = texture:getHeight(),
			framecycle = 0,
			frame = 1,
			framedelay = 0.025,
			group = "enemy",
			type = name,
			xvel = 0,
			yvel = 0,
			dir = 0,
			alive = true,
			score = 100
		})

	elseif name == "spike" then
		if dir == 0 or dir == 2 then
			width = self.textures[name][1]:getWidth()
			height = self.textures[name][1]:getHeight()
		end
		if dir == 3 or dir == 1 then
			width = self.textures[name][1]:getHeight()
			height = self.textures[name][1]:getWidth()
		end
		table.insert(world.entities.enemy, {		
			x = x or 0,
			y = y or 0,
			xorigin = x,
			yorigin = y,
			w = width,
			h = height,
			group = "enemy",
			type = name,
			alive = true,
			movedist = 0,
			dir = dir,
			movespeed = 0,
			movedist = 0,
			editor_canrotate = true
		})

	elseif name == "spike_large" then
		if dir == 0 or dir == 2 then
			width = self.textures[name][1]:getWidth()
			height = self.textures[name][1]:getHeight()
		end
		if dir == 3 or dir == 1 then
			width = self.textures[name][1]:getHeight()
			height = self.textures[name][1]:getWidth()
		end
		table.insert(world.entities.enemy, {		
			x = x or 0,
			y = y or 0,
			xorigin = x,
			yorigin = y,
			w = width,
			h = height,
			group = "enemy",
			type = name,
			alive = true,
			movedist = 0,
			movespeed = 0,
			dir = dir,
			
			editor_canrotate = true
		})

	elseif name == "spike_timer" then
	
		if dir == 0 or dir == 2 then
			width = self.textures[name][1]:getWidth()
			height = self.textures[name][1]:getHeight()
		end
		if dir == 3 or dir == 1 then
			width = self.textures[name][1]:getHeight()
			height = self.textures[name][1]:getWidth()
		end
	
		table.insert(world.entities.enemy, {		
			x = x or 0,
			y = y or 0,
			xorigin = x,
			yorigin = y,
			w = width,
			h = height,
			group = "enemy",
			type = name,
			alive = true,
			timer = 1.25,
			timer_cycle = love.math.random(0,125)/100,
			movedist = 0,
			dir = dir,
			movespeed = 0,
			movedist = 0,
			editor_canrotate = false
		})

	elseif name == "icicle" then
		table.insert(world.entities.enemy, {		
			x = x or 0,
			y = y or 0,
			xorigin = x,
			yorigin = y,
			w = self.textures[name][1]:getWidth(),
			h = self.textures[name][1]:getHeight(),
			group = "enemy",
			type = name,
			alive = true,
			falling = false,
			yvel = 0,
			jumping = 0,
			movespeed = 0,
			movedist = 0,
			dir = 0,
		})

	elseif name == "bee" or name == "bird" then
		local texture = self.textures[name][1]
		table.insert(world.entities.enemy, {
			movespeed = movespeed or 100,
			movedist = movedist or 400,
			movex = 1,
			xorigin = x,
			yorigin = y,
			ticks = love.math.random(100),
			yspeed = 0.01,
			x = love.math.random(x,x+movedist) or 0,
			y = y or 0,
			texture = texture,
			w = texture:getWidth(),
			h = texture:getHeight(),
			framecycle = 0,
			frame = 1,
			framedelay = 0.05,
			group = "enemy",
			type = name,
			xvel = 0,
			yvel = 0,
			dir = 0,
			alive = true,
			score = 150,
		})
	
	elseif name == "spikeball" then
		table.insert(world.entities.enemy, {
			w = self.textures[name][1]:getWidth(),
			h = self.textures[name][1]:getHeight(),
			xorigin = x,
			yorigin = y,
			x = x or 0,
			y = y or 0,
			group = "enemy",
			type = name,
			speed = 3,
			alive = true,
			swing = 1,
			angle = 0, --should restore set angleorigin here TODO
			radius = 200,
			movespeed = 0,
			movedist = 0,
			dir = 0,
		})
	end
	print( name .. " added @  X:"..x.." Y: "..y)
end


function enemies:update(dt)
	for i, enemy in ipairs(world.entities.enemy) do
	
		--animate frames if given
		if #self.textures[enemy.type] > 1 then
			enemy.framecycle = math.max(0, enemy.framecycle - dt)
			
			if enemy.framecycle <= 0 then
				enemy.frame = enemy.frame + 1
				
				if enemy.frame > #self.textures[enemy.type] then
					enemy.frame = 1
				end
			
				enemy.framecycle = enemy.framedelay
			end
			
			enemy.texture = self.textures[enemy.type][math.min(enemy.frame, #self.textures[enemy.type])]

			--update bounds
			enemy.w = enemy.texture:getWidth()
			enemy.h = enemy.texture:getHeight()

		end
		
		if enemy.alive then
			enemy.carried = false
		
			if enemy.type == "walker" or enemy.type == "blob" then
			
				physics:applyGravity(enemy, dt)
				--enemy.yorigin = enemy.newY

				physics:movex(enemy, dt)	
				physics:crates(enemy,dt)
				physics:traps(enemy, dt)
				physics:platforms(enemy, dt)
			
				physics:update(enemy)
				
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
			

			if enemy.type == "hopper" then
			
				physics:applyGravity(enemy, dt)
				--enemy.yorigin = enemy.newY

				physics:movex(enemy, dt)	
				physics:crates(enemy,dt)
				physics:traps(enemy, dt)
				physics:platforms(enemy, dt)
				
				if enemy.carried then
					if enemy.x <= enemy.xorigin or enemy.x >= enemy.xorigin + enemy.movedist then
						enemy.yvel=600
					end
				end
				
				physics:update(enemy)
				
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
			
			if enemy.type == "bee" or enemy.type == "bird" then
				enemy.y = enemy.yorigin - (10*math.sin(enemy.ticks*enemy.yspeed*math.pi)) + 20
				enemy.ticks = enemy.ticks +1
				physics:movex(enemy, dt)
				physics:update(enemy)
				
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
			
			if enemy.type == "spike" or enemy.type == "spike_large" and enemy.alive then
				-- NOT ACTIVE WHILST EDITING
				if mode == "game" and player.alive and collision:check(player.newX,player.newY,player.w,player.h,
					enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then
					player.yvel = -player.yvel
					player:die(enemy.group)
				end
			end
			
			if enemy.type == "spike_timer" then
					
				enemy.timer_cycle = math.max(0, enemy.timer_cycle - dt)
				if enemy.timer_cycle <= 0 then

					if world:inview(enemy) then
						sound:play(sound.effects["slice"])
					end
					
					enemy.switch = not enemy.switch
					enemy.timer_cycle = enemy.timer
					
				end
				
				if enemy.switch then
					enemy.y = math.max(enemy.yorigin,enemy.y - 400 *dt)
				else
					enemy.y = math.min(enemy.yorigin+enemy.h,enemy.y + 400 *dt)
				end
				
				-- NOT ACTIVE WHILST EDITING
				if mode == "game" and player.alive and collision:check(player.newX,player.newY,player.w,player.h,
					enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then
					
					if enemy.y ~= enemy.yorigin+enemy.h then
						-- only die when entity is active
						player.yvel = -player.yvel
						player:die(enemy.group)
					end
				end
			end
			
			if enemy.type == "icicle" then
				if enemy.falling then
					
					physics:applyGravity(enemy, dt)
					
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
									enemy.h = self.textures[enemy.type][1]:getHeight()
									enemy.newY = platform.y-enemy.h
									joystick:vibrate(0.35,0.35,0.5)
								end
							end
						
					end
					
					physics:update(enemy)

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
					
				physics:update(enemy)
				
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


function enemies:draw()
	local count = 0

	for i, enemy in ipairs(world.entities.enemy) do
		if world:inview(enemy) then
		
			count = count + 1
			if enemy.alive then
			
				local texture = self.textures[enemy.type][1]
				
				if enemy.type == "bee" or enemy.type == "bird" or enemy.type == "walker" or enemy.type =="hopper" or enemy.type == "blob" then
					love.graphics.setColor(1,1,1,1)
					if enemy.movespeed < 0 then
						love.graphics.draw(enemy.texture, enemy.x, enemy.y, 0, 1, 1)
					elseif enemy.movespeed > 0 then
						love.graphics.draw(enemy.texture, enemy.x+enemy.w, enemy.y, 0, -1, 1)
					end
				end
				
					
				if enemy.type == "spike" or enemy.type == "spike_large" and enemy.alive then
					love.graphics.setColor(1,1,1,1)
					if enemy.dir == 1 then
						love.graphics.draw(texture, enemy.x, enemy.y, math.rad(90),1,(enemy.flip and -1 or 1),0,(enemy.flip and 0 or enemy.w))
					elseif enemy.dir == 2 then
						love.graphics.draw(texture, enemy.x, enemy.y, 0,(enemy.flip and 1 or -1),-1,(enemy.flip and 0 or enemy.w),enemy.h)	
					elseif enemy.dir == 3 then
						love.graphics.draw(texture, enemy.x, enemy.y, math.rad(-90),1,(enemy.flip and -1 or 1),enemy.h,(enemy.flip and enemy.w or 0))
					else
						love.graphics.draw(texture, enemy.x, enemy.y, 0,(enemy.flip and -1 or 1),1,(enemy.flip and enemy.w or 0),0,0)
					end
				end
			
				if enemy.type == "spike_timer" then
					love.graphics.setColor(1,1,1,1)
					local x,y = camera:toCameraCoords(enemy.xorigin, enemy.yorigin)
					love.graphics.setScissor( x,y,enemy.w*camera.scale,enemy.h*camera.scale)
					love.graphics.draw(texture, enemy.x, enemy.y, 0,1,1)
					love.graphics.setScissor()
				end
			
				if enemy.type == "icicle" or enemy.type == "icicle_d" then
					love.graphics.setColor(1,1,1,1)
					love.graphics.draw(texture, enemy.x, enemy.y, 0,1,1)
				end
			
			
				if enemy.type == "spikeball" then
					love.graphics.setColor(1,1,1,1)
					chainlink:draw(enemy)
					
					--spin
					love.graphics.draw(texture, enemy.x, enemy.y, -enemy.angle*2,1,1,enemy.w/2,enemy.h/2)
					
					--no spin
					--love.graphics.draw(texture, enemy.x, enemy.y, 0,1,1,enemy.w/2,enemy.h/2)
				end
			
			end
			
			if editing or debug then
				enemies:drawdebug(enemy, i)
			end
		end
	end
	world.enemies = count
end


function enemies:drawdebug(enemy, i)
	local texture = self.textures[enemy.type]

	if enemy.type == "spikeball" then
		--bounds
		love.graphics.setColor(1,0,0,1)
		love.graphics.rectangle("line", enemy.x-texture[(enemy.frame or 1)]:getWidth()/2+5, enemy.y-texture[(enemy.frame or 1)]:getHeight()/2+5, texture[(enemy.frame or 1)]:getWidth()-10, texture[(enemy.frame or 1)]:getHeight()-10)
		--hitbox
		love.graphics.setColor(1,0.78,0.39,1)
		love.graphics.rectangle("line", enemy.x-texture[(enemy.frame or 1)]:getWidth()/2, enemy.y-texture[(enemy.frame or 1)]:getHeight()/2, texture[(enemy.frame or 1)]:getWidth(), texture[(enemy.frame or 1)]:getHeight())

		--waypoint
		love.graphics.setColor(1,0,1,0.39)
		love.graphics.line(enemy.xorigin,enemy.yorigin,enemy.x,enemy.y)	
		love.graphics.circle("line", enemy.xorigin,enemy.yorigin, enemy.radius,enemy.radius)	
		
		--selectable area in editor
		love.graphics.setColor(1,0,0,0.39)
		love.graphics.rectangle("line", 
			enemy.xorigin-chainlink.textures["origin"]:getWidth()/2,enemy.yorigin-chainlink.textures["origin"]:getHeight()/2,
			chainlink.textures["origin"]:getWidth(),chainlink.textures["origin"]:getHeight()
		)

	elseif enemy.type == "spike_timer" then
		--bounds
		love.graphics.setColor(1,0,0,1)
		love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
		--hitbox
		love.graphics.setColor(1,0.78,0.39,1)
		love.graphics.rectangle("line", enemy.xorigin, enemy.yorigin, enemy.w, enemy.h*2)
	
	else
	--all other enemies
		--bounds
		love.graphics.setColor(1,0,0,1)
		love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
		--hitbox
		love.graphics.setColor(1,0.78,0.39,1)
		love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)
	end

	--waypoint	
	if enemy.type == "walker" or enemy.type == "bee" or enemy.type == "bird" or enemy.type == "hopper" or enemy.type == "blob" then
		
		love.graphics.setColor(1,0,1,0.19)
		love.graphics.rectangle("fill", enemy.xorigin, enemy.y, enemy.movedist+texture[(enemy.frame or 1)]:getWidth(), texture[(enemy.frame or 1)]:getHeight())
		love.graphics.setColor(1,0,1,1)
		love.graphics.rectangle("line", enemy.xorigin, enemy.y, enemy.movedist+texture[(enemy.frame or 1)]:getWidth(), texture[(enemy.frame or 1)]:getHeight())
	end

end






