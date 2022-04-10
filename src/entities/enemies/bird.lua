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

bird = {}
table.insert(enemies.list, "bird")
table.insert(editor.entities, {"bird", "enemy"})
enemies.textures["bird"] = textures:load("data/images/enemies/bird/")

function bird:worldInsert(x,y,movespeed,movedist,dir,name)

	local texture = enemies.textures[name][1]
	table.insert(world.entities.enemy, {
		movespeed = movespeed or 100,
		movedist = movedist or 400,
		movex = 1,
		xorigin = x,
		yorigin = y,
		ticks = love.math.random(100),
		yspeed = 0.01,
		x = love.math.random(x,x+movedist) or 0,
		y = y or 0,
		texture = texture,
		w = texture:getWidth(),
		h = texture:getHeight(),
		framecycle = 0,
		frame = 1,
		framedelay = 0.05,
		group = "enemy",
		type = name,
		xvel = 0,
		yvel = 0,
		dir = 0,
		alive = true,
		score = 150,
	})
end


function bird:checkCollision(enemy, dt)
	enemy.y = enemy.yorigin - (10*math.sin(enemy.ticks*enemy.yspeed*math.pi)) + 20
	enemy.ticks = enemy.ticks +1
	physics:movex(enemy, dt)
	physics:update(enemy)

	-- NOT ACTIVE WHILST EDITING
	if mode == "game" and player.alive and collision:check(player.newX,player.newY,player.w,player.h,
		enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then

		if player.jumping or player.invincible then
			if player.y > enemy.y then
				player.yvel = -player.jumpheight
			elseif player.y < enemy.y then
				player.yvel = player.jumpheight
			end

			popups:add(enemy.x+enemy.w/2,enemy.y+enemy.h/2,"+"..enemy.score)
			player.score = player.score + enemy.score
			enemy.alive = false
			sound:play(sound.effects["kill"])
			console:print(enemy.type .." killed")
			joystick:vibrate(0.5,0.5,0.5)
		else
			-- otherwise we die
			player:die(enemy.type)
		end
	end


end


function bird:draw(enemy)
	love.graphics.setColor(1,1,1,1)
	if enemy.movespeed < 0 then
		love.graphics.draw(enemy.texture, enemy.x, enemy.y, 0, 1, 1)
	elseif enemy.movespeed > 0 then
		love.graphics.draw(enemy.texture, enemy.x+enemy.w, enemy.y, 0, -1, 1)
	end
end


function bird:drawdebug(enemy, i)
	--bounds
	love.graphics.setColor(1,0,0,1)
	love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
	--hitbox
	love.graphics.setColor(1,0.78,0.39,1)
	love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)

	local texture = enemies.textures[enemy.type]
	love.graphics.setColor(1,0,1,0.19)
	love.graphics.rectangle("fill", enemy.xorigin, enemy.y, enemy.movedist+texture[(enemy.frame or 1)]:getWidth(), texture[(enemy.frame or 1)]:getHeight())
	love.graphics.setColor(1,0,1,1)
	love.graphics.rectangle("line", enemy.xorigin, enemy.y, enemy.movedist+texture[(enemy.frame or 1)]:getWidth(), texture[(enemy.frame or 1)]:getHeight())
end

