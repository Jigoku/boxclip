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

require("title")
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
	runtime = os.time()
	
	cwd = love.filesystem.getWorkingDirectory( )
	
	--windwo settings
	
	WIDTH = love.window.getWidth()
	HEIGHT = love.window.getHeight()
	
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


	title:init()
	
end




function love.draw()

	if mode == "title" then title:draw() else world:draw() end
	if console then util:drawConsole() end
	
end

function love.resize(w,h)
	WIDTH = w
	HEIGHT = h
	util:dprint("resized window ("..w.."x"..h..")")
	
end



function love.update(dt)
	-- process keyboard events
	input:checkkeys(dt)

	--run the world
	if mode == "title" then	title:run(dt) else world:run(dt) end

end

