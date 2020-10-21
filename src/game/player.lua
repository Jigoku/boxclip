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

player.sprite = {
	["idle" ] = textures:load("data/images/player/idle/" ),
	["jump" ] = textures:load("data/images/player/jump/" ),
	["fall" ] = textures:load("data/images/player/fall/" ),
	["run"  ] = textures:load("data/images/player/run/"  ),
	["dizzy"] = textures:load("data/images/player/dizzy/"),	 
	["faint"] = textures:load("data/images/player/faint/"),
	["slide"] = textures:load("data/images/player/sliding/"),
	
}


function player:init() 
	--initialize the player defaults
	self.group = "players"
	
	self.framedelay = 1
	self.framecycle = 0
	self.frame = 1
	self.state = "idle"
	self.texture = self.sprite[self.state][self.frame]
	
	self.w = player.texture:getWidth()
	self.h = player.texture:getHeight()
	
	self.spawnX = 0
	self.spawnY = 0 
	self.x = spawnX
	self.y = spawnY 
	self.xvel = 0
	self.yvel = 0
	
	self.speed = 500
	self.friction = 300
	self.jumpheight = 780
	self.jumping = false
	self.dir = 0
	self.sliding = false
	self.lastdir = 0
	self.score = 0
	self.alive = true
	self.lives = 3
	self.gems = 0
	self.angle = 0
	--self.candrop = false
	--self.canjump = true

	self.invincible = false
	self.invincible_timer = 15
	
	console:print("initialized player")

	--particle setup
	-- horrible implementation... fix this
	self.particles_invincible = love.graphics.newParticleSystem(pickups.textures[5], 32)
	self.particles_invincible:setParticleLifetime(2, 2) -- particle lifetime
	self.particles_invincible:setEmissionRate(10)
	self.particles_invincible:setSizeVariation(1)
	self.particles_invincible:setLinearAcceleration(-400, -400, 400, 400) -- Random movement in all directions.
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
			love.graphics.setColor(1,1,1,1)
			love.graphics.draw(self.particles_invincible, player.x+player.w/2,player.y+player.h/2, 0,0.25,0.25)
		end
		
		love.graphics.setColor(1,1,1,1)
		
		-- active player sprite
		love.graphics.draw(
			self.texture, 
			self.x,
			self.y,
			0, 
			(self.lastdir == -1 and -1 or 1),
			1,
			(self.lastdir == -1 and self.texture:getWidth() or 0), 
			0
		)
		
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
	
	if paused or editing or world.splash.active then return end
	
	-- player input / movement
	
	if self.alive and not console.active then

		if love.keyboard.isDown(binds.slide) and self.carried then
			self.sliding = true
		end

		if love.keyboard.isDown(binds.right) or joystick:isDown("dpright") then
			self:moveright()
			
		elseif love.keyboard.isDown(binds.left) or joystick:isDown("dpleft") then
			self:moveleft()

		else
			self.dir = 0
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
	
	-- player frame/sprite animation
	self.framecycle = math.max(0, self.framecycle - dt)
	
	if self.framecycle <= 0 then
		self.frame = self.frame + 1
		
		if self.frame > #self.sprite[self.state] then
			self.frame = 1
		end
		
		self.framecycle = self.framedelay
	end

	-- old/previous state
	local ostate = self.state

	if self.alive then
		if self.jumping then
			self.framedelay = 0
	
			if self.yvel < 0 then
				--falling animation
				self.state = "fall"
			else
				--jumping animation
				self.state = "jump"
			end
		
		else
			if self.xvel ~= 0 then
				--running animation
				self.framedelay = 0.1
				if self.sliding then 
					self.state = "slide"
				else 
					self.state = "run"
				end
			else
				--idle animation
				self.state = "idle"
				self.framedelay = 0.2
			end
		end
	else
		--death animation
		self.framedelay = 0.1
		self.state = "dizzy"
	end
	
	-- set the correct texture based on player state
	self.texture = self.sprite[self.state][math.min(self.frame, #self.sprite[self.state])]
	
	-- only do this if state has changed
	if ostate ~= self.state then
		--update player bounds
		self.w = self.texture:getWidth()
		self.h = self.texture:getHeight()
		
		-- reset frame counter if state changed
		self.frame = 1
		
		-- reposition player y position if state differs
		-- difference between oldstate/newstate :getHeight()
		-- this keeps the sprite in place relative to the characters head
		local oldtex = self.sprite[ostate][self.frame]:getHeight()
		local newtex = self.sprite[self.state][self.frame]:getHeight()
		
		if newtex > oldtex then
			self.y = self.y + (oldtex - newtex)
		end
	end
	
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
	if self.lives < 0 then
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
	
	if player.alive then
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
			world:initsplash()
		end		
	end
end


function player:respawn()
	-- restart bgm/ambient on respawn
	sound:playbgm(world.mapmusic)
	sound:playambient(world.mapambient)	

	-- load the previously stored state
	world:loadstate()
	
	-- set the spawn
	self.x = self.spawnX
	self.y = self.spawnY
	self.newX = self.spawnX
	self.newY = self.spawnY

	-- reset properties
	self.xvel = 0
	self.xvelboost = 0
	self.yvel = 0
	self.jumping = false
	self.dir = 0
	self.sliding = false
	self.lastdir = 0
	self.alive = true
	self.candrop = false
	self.invincible = false
	camera.x = player.spawnX
	camera.y = player.spawnY
	
	-- fade in camera
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
		
		camera:shake(8, 1, 60, 'XY')
		camera:fade(2, {0,0,0,1})
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
		self.sliding = false
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


function player:moveright()
	if not player.sliding then
		self.lastdir = self.dir
		self.dir = 1
		self.sliding = false
	end
end


function player:moveleft()
	if not player.sliding then
		self.lastdir = self.dir
		self.dir = -1
		self.sliding = false
	end
end


function player:keypressed(key)
	if paused or editing or world.splash.active then return end 
	--maybe remove this function, not needed?
	--if/when an "interact" key is implemented, this function could be used
	-- for example, press "E" to activate, etc. 
	-- one idea was to add levers of some kind, to trigger certain entities.
end
