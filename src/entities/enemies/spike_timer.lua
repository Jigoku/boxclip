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
 
spike_timer = {}
table.insert(enemies.list, "spike_timer")
table.insert(editor.entities, {"spike_timer", "enemy"})
enemies.textures["spike_timer"] = {love.graphics.newImage( "data/images/enemies/spike.png"),}

function spike_timer.worldInsert(x,y,movespeed,movedist,dir,name)
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
		timer = 1.25,
		timer_cycle = love.math.random(0,125)/100,
		movedist = 0,
		dir = dir,
		movespeed = 0,
		movedist = 0,
		editor_canrotate = false
	})
end


function spike_timer.checkCollision(enemy, dt)
	
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


function spike_timer.draw(enemy) 
	local texture = enemies.textures[enemy.type][1]
	love.graphics.setColor(1,1,1,1)
	local x,y = camera:toCameraCoords(enemy.xorigin, enemy.yorigin)
	love.graphics.setScissor( x,y,enemy.w*camera.scale,enemy.h*camera.scale)
	love.graphics.draw(texture, enemy.x, enemy.y, 0,1,1)
	love.graphics.setScissor()
end

