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
 
 player = {}


function player:init() 
	--initialize the player defaults
	self.group = "players"
	self.w = 50
	self.h = 60
	self.spawnX = 0
	self.spawnY = 0 
	self.x = spawnX
	self.y = spawnY 

	self.speed = 470 --600
	self.friction = 300
	self.xvel = 0
	self.yvel = 0
	self.jumpheight = 780
	self.jumping = false
	self.dir = "idle"
	self.lastdir = "idle"
	self.score = 0
	self.alive = true
	self.lives = 3
	self.gems = 0
	self.angle = 0
	--self.candrop = false
	--self.canjump = true

	self.invincible = false
	self.invincibility_timer = 15
	
	console:print("initialized player")


	--particle setup
	-- horrible implementation... fix this
	self.particles_invincible = love.graphics.newParticleSystem(pickups.textures[5], 32)
	self.particles_invincible:setParticleLifetime(3, 4) -- Particles live at least 2s and at most 5s.
	self.particles_invincible:setEmissionRate(10)
	self.particles_invincible:setSizeVariation(1)
	self.particles_invincible:setLinearAcceleration(-200, -200, 200, 200) -- Random movement in all directions.
	self.particles_invincible:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.
	self.particles_invincible:setSpin( 1, 5 )
end

function player:cheats()
	--cheats enabled for entire game
	if cheats.magnet then self.hasmagnet = true else self.hasmagnet = false end
	if cheats.shield then self.hasshield = true else self.hasshield = false end
end

function player:draw()

	if not editing then
		love.graphics.push()
		
		--draw this powerup behind player
		if self.invincible then
			love.graphics.setColor(1,1,1,0.5)
			love.graphics.draw(self.particles_invincible, player.x+player.w/2,player.y+player.h/2, 0,0.25,0.25)
		end
		--rotating for jumping
		if self.jumping then
		
			love.graphics.translate(self.x+self.w/2,self.y+self.h/2)
			love.graphics.rotate(self.angle)
			love.graphics.translate(-self.x-self.w/2,-self.y-self.h/2)
	
			--player main (circle)
			love.graphics.setColor(0.4,0.7,0.6,1)
			love.graphics.circle("fill", self.x+self.w/2, self.y+self.h/2, self.w/1.5, self.h)
			love.graphics.setColor(0.4,0.4,0.4,1)
			love.graphics.circle("line", self.x+self.w/2, self.y+self.h/2, self.w/1.5, self.h)
				
		else
			--player main (square)
			local opacity = 1
			if not self.alive then  opacity = 0.5 end
			love.graphics.setColor(0.4,0.7,0.6,opacity)
			love.graphics.rectangle("fill", self.x, self.y, self.w, self.h,5,5,5)
			love.graphics.setColor(0.4,0.4,0.4,opacity)
			love.graphics.rectangle("line", self.x, self.y, self.w, self.h,5,5,5)
		end
	
		-- eyes
		love.graphics.setColor(0,0,0,1)
		if self.lastdir == "right" then
			love.graphics.rectangle("fill", self.x+self.w-10, self.y+10, 3, 4)
			love.graphics.rectangle("fill", self.x+self.w-20, self.y+10, 3, 4 )
		end
	
		if self.lastdir == "left" then
			love.graphics.rectangle("fill", self.x+10, self.y+10, 3, 4)
			love.graphics.rectangle("fill", self.x+20, self.y+10, 3, 4 )
		end
		love.graphics.pop()
	end
	
	--other powerups drawn in front
	if self.hasmagnet then
		--
	end
	if self.hasshield then
		love.graphics.setColor(0.4,1,1,0.4)
		love.graphics.circle("fill", self.x+self.w/2, self.y+self.h/2, self.w, self.h)
		love.graphics.setColor(0.1,0.3,0.3,0.4)
		love.graphics.circle("line", self.x+self.w/2, self.y+self.h/2, self.w, self.h)
	end
	
	
	if editing or debug then
		self:drawdebug()
	end

end

function player:drawdebug()

	love.graphics.setColor(1,0,0,0.6)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	
end




function player:update(dt)

	-- invincibility check
	if self.invincible then
		self.particles_invincible:update(dt)
		self.invincible_timer = math.max(0, self.invincible_timer - dt)
		
		if self.invincible_timer <= 0 then
			sound:playbgm(world.mapmusic)
			self.invincible = false
			self.particles_invincible:stop()
			console:print("invincibility ended")
		end
	end

	-- end game if no lives left
	if player.lives < 0 then
		console:print("game over")
		--add game over transition screen
		--should fade in, press button to exit to title
		gameover:init()
	end
		
	-- give a life at 100 gems
	--[[
	if player.gems >= 100 then
		player.gems = 0
		player.lives = player.lives +1
		sound:play(sound.effects["lifeup"])
	end
	--]]
	
	
	if paused or editing or world.splash.active then return end
	
	if self.alive then
		if love.keyboard.isDown(binds.right) 
			or joystick:isDown("dpright") then
			self:moveright()
		elseif love.keyboard.isDown(binds.left)
			or joystick:isDown("dpleft") then
			self:moveleft()
		else
			self.dir = "idle"
		end
	
	
		if love.keyboard.isDown(binds.jump) or joystick:isDown("a") then
			if love.keyboard.isDown(binds.down) or joystick:isDown("dpdown") then
				self:drop()
			else
				self:jump()
			end
		else
			self.canjump = true
		end
	
	end
	
	
	if editing then return end
	if player.alive  then
		player.carried = false
		physics:applyVelocity(player, dt)
		physics:applyGravity(player, dt)
		physics:applyRotation(player,math.pi*8,dt)
	
		physics:traps(player,dt)
		physics:crates(player,dt)
		physics:bumpers(player,dt)
		physics:platforms(player, dt)
		physics:update(player)
			
	else
		--death physics (float up)
		player.y = player.y - (250 * dt)
		if player.y < player.newY-600 then
			player.lives = player.lives -1
			player:respawn()
		end		
	end
end



function player:respawn()
	--if mode == "game" then
	sound:playbgm(world.mapmusic)
	sound:playambient(world.mapambient)	
	--end

	world:loadstate()
	self.x = self.spawnX
	self.y = self.spawnY
	self.newX = self.spawnX
	self.newY = self.spawnY
	self.xvel = 0
	self.xvelboost = 0
	self.yvel = 0
	self.jumping = false
	self.dir = "idle"
	self.lastdir = "idle"
	self.alive = true
	self.candrop = false
	self.invincible = false
	camera.x = player.spawnX
	camera.y = player.spawnY
	camera:fade(1, {0,0,0,0})
	self:cheats()
	
	console:print("respawn player")
end

function player:die(this)
	if mode == "game" then
	
		if self.hasshield then
			self:jump()
			sound:play(sound.effects["shield"])
			self.hasshield = false
			return
		end
	
		if self.hasmagnet then
			self.hasmagnet = false
			for _,pickup in ipairs(world.entities.pickup) do
				pickup.attract = false
			end
		end
		camera:fade(2, {0,0,0,255})
		camera:shake(8, 1, 60, 'XY')
		
		joystick:vibrate(2,2,1)
		
		console:print("player killed by " .. this)	
		sound:play(sound.effects["die"])
		self.alive = false
		--player.dir = "idle" (change "dir" to state, left,right,idle,dead,jumping, etc)
		self.angle = 0
		self.xvel = 0
		self.yvel = 0
		self.jumping = false
	end
	

end




function player:collect(pickup)
	--increase score when pickups are collected
	
	if pickup.type == "gem" then
		sound:play(sound.effects["gem"])
		self.score = self.score + pickup.score
		self.gems = self.gems +1
	elseif pickup.type == "life" then
		sound:play(sound.effects["lifeup"])
		self.score = self.score + pickup.score
		self.lives = self.lives +1
	elseif pickup.type == "magnet" then
		sound:play(sound.effects["magnet"])
		self.score = self.score + pickup.score
		self.hasmagnet = true
	elseif pickup.type == "shield" then
		sound:play(sound.effects["shield"])
		self.score = self.score + pickup.score
		self.hasshield = true
	elseif pickup.type == "star" then
		sound:play(sound.effects["lifeup"])
		self.score = self.score + pickup.score
		player:invincibility()
	end
end

function player:invincibility() 
	if not self.invincible then
		sound:playbgm(9)
		self.invincible = true
		self.particles_invincible:start()
	end

	self.invincible_timer = 15
	console:print("invincibility started")
end

function player:attack(enemy)
	-- increase score when attacking an enemy
	self.score = self.score + enemy.score
end

function player:jump()
	if self.alive and self.canjump and not self.jumping or cheats.jetpack then
		sound:play(sound.effects["jump"])
		self.jumping = true
		self.canjump = false
		self.yvel = self.jumpheight	
	end
end

function player:drop()
	if self.alive and not self.jumping then
	
		if self.candrop then
			self.jumping = true

			--fix this value to stop twitching
			player.y = player.y + player.h/3
			self.yvel = -20
		end
	end
end

function player:moveleft()
	self.lastdir = self.dir
	self.dir = "left"
end

function player:moveright()
	self.lastdir = self.dir
	self.dir = "right"	
end



function player:keypressed(key)
	if paused or editing or world.splash.active then return end 
	
	--maybe remove this function, not needed?
end
