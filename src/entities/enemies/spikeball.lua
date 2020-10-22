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
 
spikeball = {}
table.insert(enemies.list, "spikeball")
table.insert(editor.entities, {"spikeball", "enemy"})
enemies.textures["spikeball"] = { love.graphics.newImage( "data/images/enemies/spikeball.png"),}

function spikeball.worldInsert(x,y,movespeed,movedist,dir,name)
	table.insert(world.entities.enemy, {
		w = enemies.textures[name][1]:getWidth(),
		h = enemies.textures[name][1]:getHeight(),
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


function spikeball.checkCollision(enemy, dt)
	
	
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



function spikeball.draw(enemy)
	local texture = enemies.textures[enemy.type][1]
	love.graphics.setColor(1,1,1,1)
	chainlink:draw(enemy)
	
	--spin
	love.graphics.draw(texture, enemy.x, enemy.y, -enemy.angle*2,1,1,enemy.w/2,enemy.h/2)
	
	--no spin
	--love.graphics.draw(texture, enemy.x, enemy.y, 0,1,1,enemy.w/2,enemy.h/2)
end

