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

	self.speed = 500
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
	self.camerashift = 50
	self.candrop = false

	
	console:print("initialized player")

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
		love.graphics.setColor(80,170,120,255)
		love.graphics.circle("fill", self.x+self.w/2, self.y+self.h/2, self.w/1.5, self.h)
		love.graphics.setColor(80,80,80,255)
		love.graphics.circle("line", self.x+self.w/2, self.y+self.h/2, self.w/1.5, self.h)
				
	else
	--player main (square)
		local opacity = 255
		if not self.alive then  opacity = 100 end
		
		love.graphics.setColor(80,170,120,opacity)
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
	
	if  debug then
		self:drawDebug()
	end

end

function player:drawDebug()
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	
	love.graphics.setColor(255,255,0,50)
	love.graphics.rectangle("line",camera.x - self.camerashift, camera.y - self.camerashift, self.camerashift*2, self.camerashift*2)
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




function player:setcamera(dt)


	--fixed camera
	if self.alive or editing then
		camera:setPosition(player.x+player.w/2, player.y+player.h/2)
		
	end
	
	
	--follow camera (could be used for levels where you are being chased)
	--  collide player with screen boundaries?
	--[[
	if self.alive then
		local camspeed = 200
		local angle = math.atan2(player.y+player.h/2 - camera.y, player.x+player.w/2 - camera.x)
		camera.x = camera.x + (math.cos(angle) *camspeed * dt)
		camera.y = camera.y + (math.sin(angle) *camspeed * dt)
	end
	--]]
	
	--float camera
	--
	-- port code from dungeon project (camera starts moving on box collision)
	-- seems incompatible though... find a different way.
end



function player:respawn()
	--if mode == "game" then
		sound:playbgm(world.mapmusic)
		sound:playambient(world.mapambient)	
	--end
	
	--remove active pickup attraction
	for i, pickup in ripairs(pickups) do
		if pickup.attract then
			table.remove(pickups, i)
		end
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
	self.candrop = false
	camera:setPosition(self.x+self.w/2, self.y+self.h/2)

	self:cheats()
	
	console:print("respawn player")
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
	
		console:print("player killed by " .. this)	
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

function player:drop()
	if not self.jumping then
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
		if love.keyboard.isDown(binds.right)  then
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
	
	if self.alive then
		--jump
		if key == binds.jump then
			if love.keyboard.isDown(binds.down) then
				self:drop()
			else
				self:jump()
			end
		end
	end

end
