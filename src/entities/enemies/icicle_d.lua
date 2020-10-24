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
 
icicle_d = {}
table.insert(enemies.list, "icicle_d")
table.insert(editor.entities, {"icicle_d", "enemy"})
enemies.textures["icicle_d"] = { love.graphics.newImage( "data/images/enemies/icicle_d.png"),}


function icicle_d.worldInsert(x,y,movespeed,movedist,dir,name)
end


function icicle_d.checkCollision(enemy, dt)
end

function icicle_d.draw(enemy)
	local texture = enemies.textures[enemy.type][1]
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(texture, enemy.x, enemy.y, 0,1,1)
end

function icicle_d.drawdebug(enemy, i)
	--bounds
	love.graphics.setColor(1,0,0,1)
	love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
	--hitbox
	love.graphics.setColor(1,0.78,0.39,1)
	love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)
end