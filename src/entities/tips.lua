--[[
 * Copyright (C) 2018 Ricky K. Thomson
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
 
tips = {}

function tips:add(x,y,text)

	local w, t = fonts.tips:getWrap(text, love.math.random(100,300))
	local padding = 5

	table.insert(world.entities.tip,{
		x = x,
		y = y,
		xorigin = x,
		yorigin = y,
		
		w = w+padding*2,
		h = (fonts.tips:getHeight()+fonts.tips:getLineHeight())*(#t) + padding,
		
		padding = padding,
		text = text,
		ticks = 0,
		yspeed = 0.05,
		xspeed = 0.025,
		group = "tip"
	})
end

function tips:update(dt)
	for _, tip in ipairs(world.entities.tip) do
		if world:inview(tip) then
			tip.x = tip.xorigin - (4*math.sin(tip.ticks*tip.xspeed*math.pi)) + 8
			tip.y = tip.yorigin - (5*math.sin(tip.ticks*tip.yspeed*math.pi)) + 10
			
			tip.ticks = tip.ticks + 1
		end
	end
end

function tips:draw()
	local count = 0

	local lw = love.graphics.getLineWidth()
	love.graphics.setLineWidth(2)
	
	local font = love.graphics.getFont()
	love.graphics.setFont(fonts.tips)
	
	for i, tip in ipairs(world.entities.tip) do
		if world:inview(tip) then
			count = count + 1
			
			local corners = 15
			
			--background
			love.graphics.setColor(255,255,255,255)
			love.graphics.rectangle("fill", tip.x, tip.y, tip.w, tip.h,corners)
			--frame
			love.graphics.setColor(0,0,0,255)
			love.graphics.rectangle("line", tip.x, tip.y, tip.w, tip.h,corners)
			--tip text
			love.graphics.printf(tip.text, tip.x+tip.padding, tip.y+tip.padding, tip.w-tip.padding*2, "center")
		end

	end

	love.graphics.setLineWidth(lw)
	love.graphics.setFont(font)
end
