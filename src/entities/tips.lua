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

tips = {}

table.insert(editor.entities, {"tip", "tip"})

function tips:add(x,y,text)

	local wrapw, t = fonts.tips:getWrap(text, love.math.random(100,300))
	local padding = 10

	local w = wrapw+padding*2
	local h = (fonts.tips:getHeight()+fonts.tips:getLineHeight())*(#t) + padding*2

	table.insert(world.entities.tip,{
		x = x ,
		y = y,
		xorigin = x,
		yorigin = y,

		w = w,
		h = h,

		padding = padding,
		text = text,
		time = love.math.random(100),
		yspeed = 1,
		xspeed = 2,
		group = "tip"
	})
end


function tips:update(dt)
	if paused then return end
	for _, tip in ipairs(world.entities.tip) do
		if world:inview(tip) then
			tip.x = tip.xorigin - math.sin(tip.time*tip.xspeed*math.pi) * 3
			tip.y = tip.yorigin - math.sin(tip.time*tip.yspeed*math.pi) * 3
			tip.time = tip.time + dt
		end
	end
end


function tips:draw()
	local count = 0

	local lw = love.graphics.getLineWidth()
	love.graphics.setLineWidth(2)

	for i, tip in ipairs(world.entities.tip) do
		if world:inview(tip) then
			count = count + 1

			local corners = 15

			--background
			love.graphics.setColor(1,1,1,0.78)
			love.graphics.rectangle("fill", tip.x, tip.y, tip.w, tip.h-tip.padding,corners)

			--frame
			love.graphics.setColor(0,0,0,1)
			love.graphics.rectangle("line", tip.x, tip.y, tip.w, tip.h-tip.padding,corners)

			--tip text
			love.graphics.setFont(fonts.tips)
			love.graphics.printf(tip.text, tip.x+tip.padding, tip.y+tip.padding, tip.w-tip.padding*2, "center")

			if debug or editing then
				self:drawdebug(tip, i)
			end
		end

	end
	world.tips = count

	love.graphics.setLineWidth(lw)
end

function tips:drawdebug(tip, i)
	love.graphics.setColor(0,1,1,0.39)
	love.graphics.rectangle("line", tip.xorigin, tip.yorigin, tip.w, tip.h)
end
