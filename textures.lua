--[[
 * Copyright (C) 2016 Ricky K. Thomson
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

textures = {}

function textures:load(path)
	--returns table of loaded images from 'path' directory
	local t = {}
	local i = 1

	local supported = { ".png", ".bmp", ".jpg", ".tga" }

	for _,file in ipairs(love.filesystem.getDirectoryItems(path)) do
		for _,ext in ipairs(supported) do
			if file:find(ext) then
				t[i] = love.graphics.newImage(path..file)
				i = i +1
			end
		end
	end
	return t
end
