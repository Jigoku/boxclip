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
 
spike_large = {}
table.insert(enemies.list, "spike_large")
table.insert(editor.entities, {"spike_large", "enemy"})
enemies.textures["spike_large"] = {love.graphics.newImage( "data/images/enemies/spike_large.png"),}

function spike_large.worldInsert(x,y,movespeed,movedist,dir,name)
	if dir == 0 or dir == 2 then
		width = self.textures[name][1]:getWidth()
		height = self.textures[name][1]:getHeight()
	end
	if dir == 3 or dir == 1 then
		width = self.textures[name][1]:getHeight()
		height = self.textures[name][1]:getWidth()
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
		movespeed = 0,
		dir = dir,
		
		editor_canrotate = true
	})
end


function spike_large.checkCollision(enemy, dt)
	
	-- NOT ACTIVE WHILST EDITING
	if mode == "game" and player.alive and collision:check(player.newX,player.newY,player.w,player.h,
		enemy.x+5,enemy.y+5,enemy.w-10,enemy.h-10) then
		player.yvel = -player.yvel
		player:die(enemy.group)
	end

end

