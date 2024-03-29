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
 
icicle = {}
table.insert(enemies.list, "icicle")
table.insert(editor.entities, {"icicle", "enemy"})
enemies.textures["icicle"] = { love.graphics.newImage( "data/images/enemies/icicle.png"),}

function icicle:worldInsert(x,y,movespeed,movedist,dir,name)
	table.insert(world.entities.enemy, {		
		x = x or 0,
		y = y or 0,
		xorigin = x,
		yorigin = y,
		w = enemies.textures[name][1]:getWidth(),
		h = enemies.textures[name][1]:getHeight(),
		group = "enemy",
		type = name,
		alive = true,
		falling = false,
		yvel = 0,
		jumping = 0,
		movespeed = 0,
		movedist = 0,
		dir = 0,
	})
end


function icicle:checkCollision(enemy, dt)
	
	if enemy.falling then
					
		physics:applyGravity(enemy, dt)
		
		--kill enemies hit by icicle
		local i,e
		for i, e in ipairs(world.entities.enemy) do
			if e.alive and not (e.type == "icicle") then
				if collision:check(e.x,e.y,e.w,e.h,
				enemy.x,enemy.newY,enemy.w,enemy.h) then
					e.alive = false
					sound:play(sound.effects["kill"])
					console:print(e.type .. " killed by " .. enemy.type)
				end
			end
		end
		
		--stop falling when colliding with platform
		local i,platform
		for i,platform in ipairs(world.entities.platform) do
				if collision:check(platform.x,platform.y,platform.w,platform.h,
					enemy.x,enemy.newY,enemy.w,enemy.h) then
					
					if platform.clip and not platform.movex and not platform.movey then
						enemy.falling = false
						sound:play(sound.effects["slice"])
						enemy.type = "icicle_d"
						enemy.h = enemies.textures[enemy.type][1]:getHeight()
						enemy.newY = platform.y-enemy.h
						joystick:vibrate(0.35,0.35,0.5)
					end
				end
			
		end
		
		physics:update(enemy)

	else
		--make dropped spikes act like platforms???
	end
	
	-- NOT ACTIVE WHILST EDITING
	if mode == "game" and player.alive then
		if collision:check(player.newX,player.newY,player.w,player.h,
			enemy.x-50,enemy.y,enemy.w+50,enemy.h+200) and enemy.y == enemy.yorigin then
			enemy.falling = true
		end

		if collision:check(player.newX,player.newY,player.w,player.h,
			enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) and enemy.falling then
			if not player.invincible then
				player.yvel = -player.yvel
				player:die(enemy.type)
			end
		end
	end

end


function icicle:draw(enemy)
	local texture = enemies.textures[enemy.type][1]
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(texture, enemy.x, enemy.y, 0,1,1)
end

function icicle:drawdebug(enemy, i)
	--bounds
	love.graphics.setColor(1,0,0,1)
	love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
	--hitbox
	love.graphics.setColor(1,0.78,0.39,1)
	love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)
end
