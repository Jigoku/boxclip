--[[
 * Copyright (C) 2015 - 2022 Ricky K. Thomson
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


function crusher:worldInsert(x,y,movespeed,movedist,dir,name)

	table.insert(world.entities.enemy, {
		movespeed = movespeed or 100,
		movedist = movedist or 400,
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


function crusher:checkCollision(object, dt)
	object.ticks = object.ticks +1
	self:update(object, dt)

	-- NOT ACTIVE WHILST EDITING
	if mode == "game" and player.alive and collision:check(player.newX,player.newY,player.w,player.h,
		object.x+5,object.y+5,object.w-10,object.h-10) then

		if(object.y < player.y and (player.x > object.x and (player.x + player.w) < (object.x + object.w))) then
			player:die(object.type)

		elseif (object.y < player.y and (player.x<=object.x or (player.x + player.w) >= (object.x + object.w))) then

			subtract = player.dir * player.speed * 1.3 * 0.005;
			player.xvel = 0
			player.x = player.x - subtract
			player.newX = player.x
		end
	end
end


function crusher:draw(enemy)
	local texture = enemies.textures[enemy.type][1]
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(texture, enemy.x, enemy.y, 0,1,1)
end


function crusher:update(object, dt)
	--traverse y-axis
	if editing and object.selected then
		object.newY = object.y
	else
		if object.y > object.yorigin + object.movedist then
			object.y = object.yorigin + object.movedist
			object.movespeed = -object.movespeed

			if world:inview(object) then
				for i, platform in ipairs(world.entities.platform) do
					if world:inview(platform) then
						if collision:top(object,platform) then
							sound:play(sound.effects["crush"])
						end
					end
				end
			end

		end
		if object.y < object.yorigin  then
			object.y = object.yorigin
			object.movespeed = -object.movespeed
		end

		if(object.movespeed>0) then
			mv_speed = object.movespeed *6
		else
			mv_speed = object.movespeed / 3
		end

		object.newY = object.y + mv_speed * dt
	end

	physics:update(object)

end


function crusher:drawdebug(enemy, i)

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
