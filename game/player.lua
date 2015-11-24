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
	self.name = "player"
	self.w = 50
	self.h = 60
	self.spawnX = 0
	self.spawnY = 0 
	self.x = spawnX
	self.y = spawnY 

	self.speed = 600
	self.mass = 800
	self.xvel = 0
	self.yvel = 0
	self.xvelboost = 0
	self.jumpheight = 800
	self.jumping = false
	self.dir = "idle"
	self.lastdir = "idle"
	self.score = 0
	self.alive = true
	self.lives = 3	
	self.gems = 0
	self.angle = 0
	
	if cheats.catlife then self.lives = 9 end
	if cheats.millionare then self.score = "1000000" end
	
	util:dprint("initialized player")

end

function player:cheats()
	--cheats enabled for entire game
	if cheats.magnet then self.hasmagnet = true else self.hasmagnet = false end
	if cheats.shield then self.hasshield = true else self.hasshield = false end
end

function player:draw()

	if not editing then
	love.graphics.push()
	--rotating for jumping
	if self.jumping then
		
		love.graphics.translate(self.x+self.w/2,self.y+self.h/2)
		love.graphics.rotate(self.angle)
		love.graphics.translate(-self.x-self.w/2,-self.y-self.h/2)

		--player main (circle)
		love.graphics.setColor(80,220,160,255)
		love.graphics.circle("fill", self.x+self.w/2, self.y+self.h/2, self.w/1.5, self.h)
		love.graphics.setColor(80,80,80,255)
		love.graphics.circle("line", self.x+self.w/2, self.y+self.h/2, self.w/1.5, self.h)
				
	else
	--player main (square)
		local opacity = 255
		if not self.alive then  opacity = 100 end
		
		love.graphics.setColor(80,220,160,opacity)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
		love.graphics.setColor(80,80,80,opacity)
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
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
	
	self:drawpowerups()
	
	if editing then
		self:drawDebug()
	end

end

function player:drawDebug()
	love.graphics.setColor(255,0,0,50)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end





function player:drawpowerups()
	if self.hasmagnet then
		--
	end
	if self.hasshield then
		love.graphics.setColor(105,255,255,100)
		love.graphics.circle("fill", self.x+self.w/2, self.y+self.h/2, self.w, self.h)
		love.graphics.setColor(25,55,55,100)
		love.graphics.circle("line", self.x+self.w/2, self.y+self.h/2, self.w, self.h)
	end
end

function player:follow(dt)
	if self.alive or editing then
	-- follow player

		--camera.x = (player.x -(love.graphics.getWidth()/2*camera.scaleX)+ player.w/2) 
		--camera.y = (player.y -(love.graphics.getHeight()/2*camera.scaleY) + player.h/2) 
		
		camera.x = (self.x+self.w/2)
		camera.y = (self.y +self.h/2)

	end
end

function player:respawn()
	if mode == "game" then
		sound:playbgm(world.mapmusic)
		sound:playambient(world.mapambient)
	end
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
	self:follow(1)
	self:cheats()
	
	util:dprint("respawn player")
end

function player:die(this)
	if mode == "game" then
	
		if self.hasshield then
			self.xvel = -self.xvel
			self:jump()
			sound:play(sound.shield)
			self.hasshield = false
			return
		end
	
		if self.hasmagnet then
			self.hasmagnet = false
		end
	
		util:dprint("player killed by " .. this)	
		sound:play(sound.die)
		self.alive = false
		--player.dir = "idle" (change "dir" to state, left,right,idle,dead,jumping, etc)
		self.angle = 0
		self.jumping = false
	end
	

end




function player:collect(item)
	--increase score when pickups are collected
	
	if item.name == "gem" then
		sound:play(sound.gem)
		self.score = self.score + item.score
		self.gems = self.gems +1
	elseif item.name == "life" then
		sound:play(sound.lifeup)
		self.score = self.score + item.score
		self.lives = self.lives +1
	elseif item.name == "magnet" then
		sound:play(sound.magnet)
		self.hasmagnet = true
	elseif item.name == "shield" then
		sound:play(sound.shield)
		self.hasshield = true
	end
end


function player:attack(enemy)
	-- increase score when attacking an enemy
	self.score = self.score + enemy.score
	enemies:die(enemy)
end

function player:jump()
	if not self.jumping or cheats.jetpack then
		sound:play(sound.jump)
		self.jumping = true
		self.yvel = self.jumpheight					
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
	if paused or editing then return end
	
	if self.alive then
		if love.keyboard.isDown("d") or love.keyboard.isDown("right")  then
			self:moveright()
	
		elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			self:moveleft()
			
		else
			self.dir = "idle"
		end
	end
end

function player:keypressed(key)
	if paused or editing then return end
	
	if self.alive then
		--jump
		if key == " " then
			self:jump()
		end
	end

end
