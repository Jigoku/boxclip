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
 
--[[
	Boxclip 2d engine by ricky thomson

	CONTROLS
	left         : a / leftarrow
	right        : d / rightarrow
	jump         : space
	suicide      : b
	
	fullscreen   : F5
	editor mode  : F1
	console      : `
	quit         : esc
	camera scale : z
--]]

require("mapio")
require("camera")
require("sound")
require("physics")
require("collision")
require("world")
require("util")
require("player")
require("input")
require("editor")
require("entities/props")
require("entities/springs")
require("entities/crates")
require("entities/platforms")
require("entities/checkpoints")
require("entities/pickups")
require("entities/enemies")
require("entities/portals")


--mode = "game"
--mode = "editing"
mode = "title"

function love.load()
	math.randomseed(os.time())
	cwd = love.filesystem.getWorkingDirectory( )
	
	--windwo settings
	icon = love.image.newImageData( "graphics/enemies/walker.png")
	love.window.setIcon( icon )
	love.mouse.setVisible( false )
	
	--store fonts here
	fonts = {
		default = love.graphics.newFont(12),
		menu = love.graphics.newFont(14),
		scoreboard = love.graphics.newFont(16),
		large = love.graphics.newFont(20),
		huge = love.graphics.newFont(30),
	}

	-- title background
	titlebg = love.graphics.newImage("graphics/tiles/checked.png")
	titlebg:setWrap("repeat", "repeat")
	titlebg_quad = love.graphics.newQuad( 0,0, love.window.getWidth(), love.window.getHeight(), titlebg:getDimensions() )
	titlebg_scroll = 0
	titlebg_scrollspeed = 50
	
	
end





function love.draw()

	--draw the titlescreen
	if mode == "title" then
		love.graphics.setBackgroundColor(0,0,0,255)
		
		love.graphics.setColor(50,50,50,255)		
		titlebg_quad:setViewport(titlebg_scroll,-titlebg_scroll,love.window.getWidth(), love.window.getHeight() )
		love.graphics.draw(titlebg, titlebg_quad, 0,0)
		
		love.graphics.setColor(10,10,10,200)
		love.graphics.rectangle("fill", 80, 80, 600,300)
		
		love.graphics.setFont(fonts.huge)
		love.graphics.setColor(255,255,255,155)
		love.graphics.print("Boxclip",100,100)
		love.graphics.setFont(fonts.menu)
		love.graphics.setColor(155,55,55,255)
		love.graphics.print("Press 1 for mode 'game'",100,150)
		love.graphics.setColor(155,55,55,155)
		love.graphics.print("(everything triggers on collision)",140,180)
		love.graphics.setColor(155,55,55,255)
		love.graphics.print("Press 2 for mode 'editing'",100,220)
		love.graphics.setColor(155,55,55,155)
		love.graphics.print("(some entites will not trigger on collision for editing purposes)",140,250)
		love.graphics.setFont(fonts.default)
		
	else
		world:draw()
	end


	if console then
		-- debug info
		util:drawConsole()
	end
	
end

function love.update(dt)
	-- process keyboard events
	input:checkkeys(dt)

	if mode == "title" then
		titlebg_scroll = titlebg_scroll + titlebg_scrollspeed * dt
		if titlebg_scroll > titlebg:getHeight()then
			titlebg_scroll = titlebg_scroll - titlebg:getHeight()
		end
	end

	--run the world
	if not (mode == "title") then
		world:timer()
		physics:world(dt)
		physics:player(dt)
		physics:pickups(dt)
		physics:enemies(dt)
				
		collision:checkWorld(dt)
		player:follow()
		world:run(dt)
	else
		love.audio.stop()
	end

end

