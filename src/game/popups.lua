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

popups = {}

function popups:add(x,y,text,entity)
	table.insert(popups, {
		xorigin = x,
		yorigin = y,
		x = x,
		y = y,
		speed = 150,
		fadespeed = 2,
		text = text,
		o = 1
	})
end


function popups:draw()
	local oldfont = love.graphics.getFont()
	love.graphics.setFont(fonts.popups)
	for _,p in ipairs(popups) do
		--shadow
		love.graphics.setColor(0,0,0,p.o)
		love.graphics.printf(p.text, p.x-fonts.popups:getWidth(p.text)/2+1,p.y+1,fonts.popups:getWidth(p.text),"center")

		-- text
		love.graphics.setColor(1,1,0,p.o)
		love.graphics.printf(p.text, p.x-fonts.popups:getWidth(p.text)/2,p.y,fonts.popups:getWidth(p.text),"center")
	end
	love.graphics.setFont(oldfont)
end


function popups:update(dt)
	for i,p in ipairs(popups) do
		p.y = p.y - p.speed *dt
		 if p.y < p.yorigin - 50 then
			p.o = p.o - p.fadespeed *dt
			if p.o <= 0 then
				table.remove(popups,i)
			end
		 end
	end
end
