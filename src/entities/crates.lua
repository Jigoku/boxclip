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

crates = {}

crates.textures = textures:load("data/images/crates/")


table.insert(editor.entities, {"crate", "crate"})


function crates:add(x,y,type)
	table.insert(world.entities.crate, {
		x = x or 0,
		y = y or 0,
		w = self.textures[1]:getWidth(),
		h = self.textures[1]:getHeight(),
		texture = self.textures[love.math.random(#self.textures)],
		group = "crate",
		type = type,
		destroyed = false,
		score = 50,
		yvel = 0,
	})
	print( "crate added @  X:"..x.." Y: "..y)
end




function crates:draw()
	local count = 0

	local i, crate
	for i, crate in ipairs(world.entities.crate) do
		if world:inview(crate) and not crate.destroyed then
			count = count + 1

			love.graphics.setColor(crate_r,crate_g,crate_b,1)
			love.graphics.draw(crate.texture,crate.x, crate.y, 0, 1, 1)

			if editing or debug then
				self:drawdebug(crate, i)
			end
		end
	end
	world.crates = count
end

function crates:drawdebug(crate, i)
	love.graphics.setColor(0,1,1,0.39)
	love.graphics.rectangle("line", crate.x, crate.y, crate.w, crate.h)
end
