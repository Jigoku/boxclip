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

	self.speed = 500 --600
	self.friction = 300
	self.xvel = 0
	self.yvel = 0
	self.jumpheight = 800
	self.jumping = false
	self.dir = "idle"
	self.lastdir = "idle"
	self.score = 0
	self.alive = true
	self.lives = 3
	self.gems = 0
	self.angle = 0
	self.camerashift = 50
	self.candrop = false

	self.invincible = false
	self.invincibility_timer = 15
	
	console:print("initialized player")


	--particle setup
	-- horrible implementation... fix this
	self.particles_invincible = love.graphics.newParticleSystem(pickups.textures["star"], 32)
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
			love.graphics.setColor(255,255,255,100)
			love.graphics.draw(self.particles_invincible, player.x+player.w/2,player.y+player.h/2, 0,0.25,0.25)
		end
		--rotating for jumping
		if self.jumping then
		
			love.graphics.translate(self.x+self.w/2,self.y+self.h/2)
			love.graphics.rotate(self.angle)
			love.graphics.translate(-self.x-self.w/2,-self.y-self.h/2)
	
			--player main (circle)
			love.graphics.setColor(80,170,120,255)
			love.graphics.circle("fill", self.x+self.w/2, self.y+self.h/2, self.w/1.5, self.h)
			love.graphics.setColor(80,80,80,255)
			love.graphics.circle("line", self.x+self.w/2, self.y+self.h/2, self.w/1.5, self.h)
				
		else
			--player main (square)
			local opacity = 255
			if not self.alive then  opacity = 100 end
		
			love.graphics.setColor(80,170,120,opacity)
			love.graphics.rectangle("fill", self.x, self.y, self.w, self.h,5,5,5)
			love.graphics.setColor(80,80,80,opacity)
			love.graphics.rectangle("line", self.x, self.y, self.w, self.h,5,5,5)
		end
	
		-- eyes
		love.graphics.setColor(0,0,0,255)
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
		love.graphics.setColor(105,255,255,100)
		love.graphics.circle("fill", self.x+self.w/2, self.y+self.h/2, self.w, self.h)
		love.graphics.setColor(25,55,55,100)
		love.graphics.circle("line", self.x+self.w/2, self.y+self.h/2, self.w, self.h)
	end
	
	
	if editing or debug then
		self:drawdebug()
	end

end

function player:drawdebug()

	love.graphics.setColor(255,0,0,155)
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
	if self.alive and not self.jumping or cheats.jetpack then
		sound:play(sound.effects["jump"])
		self.jumping = true
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


function player:checkkeys(dt)
	if paused or editing or world.splash.active then return end
	
	if self.alive then
		if love.keyboard.isDown(binds.right) then
			self:moveright()
		elseif love.keyboard.isDown(binds.left) then
			self:moveleft()
		else
			self.dir = "idle"
		end
	
	end
end


function player:keypressed(key)
	if paused or editing or world.splash.active then return end 
	
	if key == binds.jump then
		if love.keyboard.isDown(binds.down) then
			self:drop()
		else
			self:jump()
		end
	end
end
