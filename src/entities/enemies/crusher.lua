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
 
crusher = {}
table.insert(enemies.list, "crusher")
table.insert(editor.entities, {"crusher", "enemy"})
enemies.textures["crusher"] = {love.graphics.newImage("data/images/enemies/crusher.png"),}


function crusher.worldInsert(x,y,movespeed,movedist,dir,name)
	
	table.insert(world.entities.enemy, {
		movespeed = movespeed or 100,
		movedist = movedist or 300,
		movey = 1,
		ticks = love.math.random(100), 
		x = x or 0, 
		y = y or 0, 
		xorigin = x, 
		yorigin = y, 
		w = enemies.textures[name][1]:getWidth(),
		h = enemies.textures[name][1]:getHeight() ,
		group = "enemy",
		type = name,
		dir = 0,
		frame = 1,
		alive = true
	})
end


function crusher.checkCollision(crusher, dt)
	crusher.ticks = crusher.ticks +1
	physics:crusher_movey(crusher, dt)
	physics:update(crusher)
	
	-- NOT ACTIVE WHILST EDITING 
	if mode == "game" and player.alive and collision:check(player.newX,player.newY,player.w,player.h,
		crusher.x+5,crusher.y+5,crusher.w-10,crusher.h-10) then
		
		if(crusher.y < player.y and (player.x > crusher.x and (player.x + player.w) < (crusher.x + crusher.w))) then
			
			player:die(crusher.type)
		
		elseif (crusher.y < player.y and (player.x<=crusher.x or (player.x + player.w) >= (crusher.x + crusher.w))) then 
			
			subtract = player.dir * player.speed * 1.3 * 0.005;
			player.xvel = 0 
			player.x = player.x - subtract
			player.newX = player.x
			
		end
		
	end
	
end


function crusher.draw(enemy)
	local texture = enemies.textures[enemy.type][1]
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(texture, enemy.x, enemy.y, 0,1,1)
end


function crusher.drawdebug(enemy, i)
	
	--bounds
	love.graphics.setColor(1,0,0,1)
	love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
	
	--hitbox
	love.graphics.setColor(1,0.78,0.39,1)
	love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)
	
	local texture = enemies.textures[enemy.type]
	love.graphics.setColor(1,0,1,0.19)
	love.graphics.rectangle("fill", enemy.x, enemy.yorigin, texture[(enemy.frame or 1)]:getWidth(), enemy.movedist + texture[(enemy.frame or 1)]:getHeight())
	love.graphics.setColor(1,0,1,1)
	love.graphics.rectangle("line", enemy.x, enemy.yorigin, texture[(enemy.frame or 1)]:getWidth(), enemy.movedist + texture[(enemy.frame or 1)]:getHeight())
	
end