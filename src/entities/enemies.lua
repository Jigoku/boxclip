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



enemies = {}


-- List of enemies
enemies.list = {}
enemies.textures = {}


function enemies:add(x,y,movespeed,movedist,dir,name)
	_G[name]:worldInsert(x,y,movespeed,movedist,dir,name)
	print( name .. " added @  X:"..x.." Y: "..y)
end


function enemies:update(dt)
	for i, enemy in ipairs(world.entities.enemy) do

		--animate frames if given
		if #self.textures[enemy.type] > 1 then
			enemy.framecycle = math.max(0, enemy.framecycle - dt)

			if enemy.framecycle <= 0 then
				enemy.frame = enemy.frame + 1

				if enemy.frame > #self.textures[enemy.type] then
					enemy.frame = 1
				end

				enemy.framecycle = enemy.framedelay
			end

			enemy.texture = self.textures[enemy.type][math.min(enemy.frame, #self.textures[enemy.type])]

			--update bounds
			enemy.w = enemy.texture:getWidth()
			enemy.h = enemy.texture:getHeight()

		end

		if enemy.alive then
			enemy.carried = false
			_G[enemy.type]:checkCollision(enemy, dt)
		end
	end
end


function enemies:draw()
	local count = 0

	for i, enemy in ipairs(world.entities.enemy) do
		if world:inview(enemy) then

			count = count + 1
			if enemy.alive then
				_G[enemy.type]:draw(enemy)
			end

			if editing or debug then
				_G[enemy.type]:drawdebug(enemy, i)
			end
		end
	end
	world.enemies = count
end








