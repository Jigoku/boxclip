--[[
 * Copyright (C) 2015 Ricky K. Thomson
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
 
function materials:add(x,y,w,h,t)
	table.insert(self, {		
		--position
		x = x or 0,
		y = y or 0,
		w = w or 10,
		h = h or 10,
		
		--properties
		name = t,
	})
end



function materials:draw()
	if editing or debug then
	
		for i, mat in ipairs(self) do
			if world:inview(mat) then
				if mat.name == "death" then
				
					love.graphics.setColor(0,0,0,100)
					love.graphics.rectangle("fill",mat.x,mat.y,mat.w,mat.h)
					
					love.graphics.setColor(0,0,0,255)
					love.graphics.rectangle("line",mat.x,mat.y,mat.w,mat.h)
				end
			end
			util:drawid(mat,i)
			util:drawCoordinates(mat)
		end
				

	end
end



