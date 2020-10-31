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

walker = {}
table.insert(enemies.list, "walker")
table.insert(editor.entities, {"walker", "enemy"})

walker.sprite = love.graphics.newImage("data/images/enemies/walker/walker.png")
walker.size = 50   -- size of each frame
walker.frames = 62 -- total number of frames
enemies.textures["walker"] = textures:loadsprite(walker.sprite, walker.size, walker.frames)

function walker:worldInsert(x,y,movespeed,movedist,dir,name)
	table.insert(world.entities.enemy, {
		movespeed = movespeed or 100,
		movedist = movedist or 200,
		movex = 1,
		dir = 0,
		xorigin = x,
		yorigin = y,
		x = love.math.random(x,x+movedist) or 0,
		y = y or 0,
		texture = enemies.textures[name][1],
		w = self.size,
		h = self.size,
		framecycle = 0,
		frame = 1,
		framedelay = 0.001,
		group = "enemy",
		type = name,
		xvel = 0,
		yvel = 0,
		dir = 0,
		alive = true,
		score = 100
	})
end


function walker:checkCollision(enemy, dt)
	physics:applyGravity(enemy, dt)
	physics:movex(enemy, dt)
	physics:crates(enemy,dt)
	physics:traps(enemy, dt)
	physics:platforms(enemy, dt)
	physics:update(enemy)

	-- NOT ACTIVE WHILST EDITING
	if mode == "game" and player.alive and collision:check(player.newX,player.newY,player.w,player.h,
		enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then
		-- if we land on top, kill enemy
		if collision:above(player,enemy) then
			if player.jumping or player.invincible or player.sliding then

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
				return true

			else
				player:die(enemy.type)
			end
		end
	end
end


function walker:draw(enemy)
	love.graphics.setColor(1,1,1,1)
	if enemy.movespeed < 0 then
		love.graphics.draw(self.sprite, enemy.texture, enemy.x, enemy.y, 0, 1, 1)
	elseif enemy.movespeed > 0 then
		love.graphics.draw(self.sprite, enemy.texture , enemy.x+enemy.w, enemy.y, 0, -1, 1)
	end
end


function walker:drawdebug(enemy, i)
	--bounds
	love.graphics.setColor(1,0,0,1)
	love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)

	--hitbox
	love.graphics.setColor(1,0.78,0.39,1)
	love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)

	--movement area
	love.graphics.setColor(1,0,1,0.19)
	love.graphics.rectangle("fill", enemy.xorigin, enemy.y, enemy.movedist+self.size, self.size)
	love.graphics.setColor(1,0,1,1)
	love.graphics.rectangle("line", enemy.xorigin, enemy.y, enemy.movedist+self.size, self.size)
end

