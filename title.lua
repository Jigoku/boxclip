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
	titlebg_quad = love.graphics.newQuad( 0,0, WIDTH, HEIGHT, titlebg:getDimensions() )
	titlebg_scroll = 0
	titlebg_scrollspeed = 20
	sound:playbgm(6)
	titlesel = 0
	util:dprint("initialized title")
end

function title:select(cmd)
	if cmd == "up" then
		titlesel = titlesel -1
		if titlesel < 0 then titlesel = 0 end
	end
	if cmd == "down" then
		titlesel = titlesel +1
		if titlesel > 2 then titlesel = 2 end
	end
	if cmd == "go" then
		if titlesel == 0 then world:init("game") end
		if titlesel == 1 then world:init("editing") end
		if titlesel == 2 then love.event.quit() end
	end
end


function title:keypressed(key)
	if key == "escape" then love.event.quit() end
	if key == "up"     then title:select("up") end
	if key == "down"   then title:select("down") end
	if key == "return"   then title:select("go") end
end

function title:draw()
	
	---background
	love.graphics.setBackgroundColor(0,0,0,255)
	love.graphics.setColor(210,150,100,255)		
	titlebg_quad:setViewport(titlebg_scroll,-titlebg_scroll,WIDTH, HEIGHT )
	love.graphics.draw(titlebg, titlebg_quad, 0,0)
		
	--frame
	love.graphics.setColor(10,10,10,200)
	love.graphics.rectangle("fill", WIDTH/4-50, HEIGHT/4-50, WIDTH/2+100,HEIGHT/2+100)
	
	love.graphics.setColor(40,40,40,100)
	love.graphics.rectangle("fill", WIDTH/4-100, HEIGHT/4-100, WIDTH/2+200,HEIGHT/2+200)
	--title	
	love.graphics.setFont(fonts.huge)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("Boxclip " ..version .." (alpha)",WIDTH/4,HEIGHT/4,WIDTH/2,"center")
	
	--options
	love.graphics.setFont(fonts.menu)

		--play 
		if titlesel == 0 then
			love.graphics.setColor(50,50,50,255)
			love.graphics.rectangle("fill", WIDTH/4-10,HEIGHT/4+90,WIDTH/2+20,40)
		end
		
		love.graphics.setColor(100,150,160,255)
		love.graphics.printf("Play",WIDTH/4,HEIGHT/4+100,WIDTH/3,"left")
		love.graphics.setColor(100,140,60,155)
		love.graphics.printf("(maps/test.map)",WIDTH/4,HEIGHT/4+100,WIDTH/2,"right")
	
		--editing 
		
		if titlesel == 1 then
			love.graphics.setColor(50,50,50,255)
			love.graphics.rectangle("fill", WIDTH/4-10,HEIGHT/4+130,WIDTH/2+20,40)
		end
		
		love.graphics.setColor(100,150,160,255)
		love.graphics.printf("Map Editor",WIDTH/4,HEIGHT/4+140,WIDTH/3,"left")
		love.graphics.setColor(100,140,60,155)
		love.graphics.printf("(maps/test.map)",WIDTH/4,HEIGHT/4+140,WIDTH/2,"right")
	
		if titlesel == 2 then
			love.graphics.setColor(50,50,50,255)
			love.graphics.rectangle("fill", WIDTH/4-10,HEIGHT/4+210,WIDTH/2+20,40)
		end
	
		love.graphics.setColor(100,150,160,255)
		love.graphics.printf("Quit",WIDTH/4,HEIGHT/4+220,WIDTH/3,"left")
		--quit
		
	love.graphics.setFont(fonts.default)

end



function title:run(dt)
	titlebg_scroll = titlebg_scroll + titlebg_scrollspeed * dt
	if titlebg_scroll > titlebg:getHeight()then
		titlebg_scroll = titlebg_scroll - titlebg:getHeight()
	end
end
