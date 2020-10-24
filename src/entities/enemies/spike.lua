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
 
spike = {}
table.insert(enemies.list, "spike")
table.insert(editor.entities, {"spike", "enemy"})
enemies.textures["spike"] = { love.graphics.newImage( "data/images/enemies/spike.png"),}

function spike.worldInsert(x,y,movespeed,movedist,dir,name)
	if dir == 0 or dir == 2 then
		width = enemies.textures[name][1]:getWidth()
		height = enemies.textures[name][1]:getHeight()
	end
	if dir == 3 or dir == 1 then
		width = enemies.textures[name][1]:getHeight()
		height = enemies.textures[name][1]:getWidth()
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
end


function spike.checkCollision(enemy, dt)
	
	-- NOT ACTIVE WHILST EDITING
	if mode == "game" and player.alive and collision:check(player.newX,player.newY,player.w,player.h,
		enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then
		player.yvel = -player.yvel
		player:die(enemy.type)
	end
	
end

function spike.draw(enemy) 
	local texture = enemies.textures[enemy.type][1]
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

function spike.drawdebug(enemy, i)
	--bounds
	love.graphics.setColor(1,0,0,1)
	love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
	--hitbox
	love.graphics.setColor(1,0.78,0.39,1)
	love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)
end


