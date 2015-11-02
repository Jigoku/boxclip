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
 
 title = {}

function title:init()
	titlebg = love.graphics.newImage("graphics/tiles/checked.png")
	titlebg:setWrap("repeat", "repeat")
	titlebg_quad = love.graphics.newQuad( 0,0, love.window.getWidth(), love.window.getHeight(), titlebg:getDimensions() )
	titlebg_scroll = 0
	titlebg_scrollspeed = 20
	sound:playbgm(1)
end

function title:draw()
	---background
	love.graphics.setBackgroundColor(0,0,0,255)
	love.graphics.setColor(210,150,100,255)		
	titlebg_quad:setViewport(titlebg_scroll,-titlebg_scroll,love.window.getWidth(), love.window.getHeight() )
	love.graphics.draw(titlebg, titlebg_quad, 0,0)
		
	--frame
	love.graphics.setColor(10,10,10,200)
	love.graphics.rectangle("fill", love.window.getWidth()/4-50, love.window.getHeight()/4-50, love.window.getWidth()/2+100,love.window.getHeight()/2+100)
	
	love.graphics.setColor(100,100,100,100)
	love.graphics.rectangle("fill", love.window.getWidth()/4-100, love.window.getHeight()/4-100, love.window.getWidth()/2+200,love.window.getHeight()/2+200)
	--title	
	love.graphics.setFont(fonts.huge)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("Boxclip " ..version .." (alpha)",love.window.getWidth()/4,love.window.getHeight()/4,love.window.getWidth()/2,"center")
	
	--options
	love.graphics.setFont(fonts.menu)

		--game mode
		love.graphics.setColor(100,150,160,255)
		love.graphics.printf("[1] for mode 'game'",love.window.getWidth()/4,love.window.getHeight()/4+100,love.window.getWidth()/3,"left")
		love.graphics.setColor(100,140,60,155)
		love.graphics.printf("(maps/test.map)",love.window.getWidth()/4,love.window.getHeight()/4+100,love.window.getWidth()/2,"right")
	
		--editing mode
		love.graphics.setColor(100,150,160,255)
		love.graphics.printf("[2] for mode 'editing'",love.window.getWidth()/4,love.window.getHeight()/4+140,love.window.getWidth()/3,"left")
		love.graphics.setColor(100,140,60,155)
		love.graphics.printf("(maps/test.map)",love.window.getWidth()/4,love.window.getHeight()/4+140,love.window.getWidth()/2,"right")
	
	love.graphics.setFont(fonts.default)

end



function title:run(dt)
	titlebg_scroll = titlebg_scroll + titlebg_scrollspeed * dt
	if titlebg_scroll > titlebg:getHeight()then
		titlebg_scroll = titlebg_scroll - titlebg:getHeight()
	end
end
