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
	player.w = 40
	player.h = 50
	player.x = 0
	player.y = 0 
	player.spawnX = 0
	player.spawnY = 0 
	player.speed = 500
	player.mass = 800
	player.xvel = 0
	player.yvel = 0
	player.jumpheight = 800
	player.jumping = 0
	player.dir = "idle"
	player.lastdir = "idle"
	player.score = 0
	player.alive = 1
	player.lives = 3	
	player.gems = 0
	player.angle = 0
end



function player:draw()
	
	--rotating for jumping
	if player.jumping == 1 then
		love.graphics.translate(player.x+player.w/2,player.y+player.h/2)
		love.graphics.rotate(player.angle)
		love.graphics.translate(-player.x-player.w/2,-player.y-player.h/2)
	end
	
	--body trails		
	if not editing then
	
	
	--player main	
	love.graphics.setColor(40,180,120,255)
	love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
	love.graphics.setColor(80,80,80,255)
	love.graphics.rectangle("line", player.x, player.y, player.w, player.h)
	
	--eyes
	love.graphics.setColor(0,0,0,255)
	if player.lastdir == "right" then
		love.graphics.rectangle("fill", player.x+player.w-10, player.y+10, 3, 4)
		love.graphics.rectangle("fill", player.x+player.w-20, player.y+10, 3, 4 )
	end
	
	if player.lastdir == "left" then
		love.graphics.rectangle("fill", player.x+10, player.y+10, 3, 4)
		love.graphics.rectangle("fill", player.x+20, player.y+10, 3, 4 )
	end
	
	end
	
	if editing then
		player:drawDebug()
	end
end

function player:drawDebug()
	love.graphics.setColor(255,0,0,50)
	love.graphics.rectangle("line", player.x, player.y, player.w, player.h)
end



function player:follow()
	if player.alive == 1 or editing then
	-- follow player
		if camera.scaleX == 1 and camera.scaleY == 1 then
			camera:setPosition(
				player.x - (love.graphics.getWidth()/2-player.w/2) ,
				player.y - (love.graphics.getHeight()/2-player.h/2) 
			)
		elseif camera.scaleX == 2 and camera.scaleY == 2 then
			camera:setPosition(
				player.x - love.graphics.getWidth(),
				player.y - love.graphics.getHeight()
			)
		end
	end
end

function player:respawn()
	sound:playbgm(world.mapmusic)
	player.x = player.spawnX
	player.y = player.spawnY
	player.xvel = 0
	player.yvel = 0
	player.jumping = 0
	player.dir = "idle"
	player.lastdir = "idle"
	player.alive = 1
	player:follow(1)
end

function player:die()
	sound:play(sound.die)
	player.lives = player.lives -1
	player:respawn()
end

function player:collect(item)
	--increase score when pickups are collected
	util:dprint("[PICKUP     ] item")
	
	if item.name == "gem" then
		sound:play(sound.gem)
		player.score = player.score + item.score
		player.gems = player.gems +1
	elseif item.name == "life" then
		sound:play(sound.lifeup)
		player.score = player.score + item.score
		player.lives = player.lives +1
	end
end


function player:attack(enemy)
	-- increase score when attacking an enemy
	player.score = player.score + enemy.score
	sound:play(sound.kill)
end


function player:moveleft()
	player.lastdir = player.dir
	player.dir = "left"
end

function player:moveright()
	player.lastdir = player.dir
	player.dir = "right"	
end
