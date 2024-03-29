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

materials = {}
materials.death = love.graphics.newImage("data/images/materials/death.png")
materials.death:setWrap("repeat","repeat")


table.insert(editor.entities, {"death", "material"})

function materials:add(x,y,w,h,t)
	table.insert(world.entities.material, {
		--position
		x = x or 0,
		y = y or 0,
		w = w or 10,
		h = h or 10,
		quad = love.graphics.newQuad( 0,0, w,h, materials.death:getDimensions() ),
		--properties
		group = "material",
		type = t
	})
end


function materials:update(dt)
	if mode == "editing" then return end
	for _, mat in ipairs(world.entities.material) do
		if world:inview(mat) then
			if collision:check(player.x,player.y,player.w,player.h,mat.x,mat.y,mat.w,mat.h) then
				if mat.type == "death" then
					player.y = mat.y-player.h
					player:die("death material @ x:".. math.floor(player.x) .. " y:"..math.floor(player.y))
				end
			end
		end
	end
end


function materials:draw()
	if editing or debug then

		for i, mat in ipairs(world.entities.material) do
			if world:inview(mat) then
				if mat.type == "death" then

					love.graphics.setColor(0,0,0,0.39)
					love.graphics.rectangle("fill",mat.x,mat.y,mat.w,mat.h)
					love.graphics.setColor(0,0,0,1)
					love.graphics.rectangle("line",mat.x,mat.y,mat.w,mat.h)
					love.graphics.setColor(1,1,1,0.39)
					love.graphics.draw(self.death, mat.quad, mat.x,mat.y)
				end

			end
		end


	end
end



