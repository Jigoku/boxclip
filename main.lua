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
--]]

require("util")
require("mapio")
require("sound")

require("binds")
require("input")

require("menus/title")
require("menus/transitions")

require("game/camera")
require("game/physics")
require("game/collision")
require("game/world")
require("game/player")
require("game/editor")

require("entities/decals")
require("entities/props")
require("entities/springs")
require("entities/crates")
require("entities/platforms")
require("entities/checkpoints")
require("entities/pickups")
require("entities/enemies")
require("entities/portals")
require("entities/bumpers")


function love.load()

	debug = false
	max_fps = 61

	min_dt = 1/max_fps
	next_time = love.timer.getTime()

	math.randomseed(os.time())
	runtime = os.time()
	
	--global window settings
	WIDTH = love.window.getWidth()
	HEIGHT = love.window.getHeight()
	icon = love.image.newImageData( "data/images/enemies/walker.png")
	love.window.setIcon( icon )
	love.mouse.setVisible( false )

	--store fonts here
	fonts = {
		default = love.graphics.newFont("data/fonts/Hanken/Hanken-Book.ttf",12),
		menu = love.graphics.newFont("data/fonts/Hanken/Hanken-Book.ttf",14),
		scoreboard = love.graphics.newFont("data/fonts/Hanken/Hanken-Book.ttf",16),
		large = love.graphics.newFont("data/fonts/Hanken/Hanken-Book.ttf",20),
		huge = love.graphics.newFont("data/fonts/Hanken/Hanken-Book.ttf",30),
	}



	title:init()
	
end



function love.update(dt)
	
	--[ frame rate cap
		-- fix for lag (ex; caused by dragging window)
		--   stops collision failures when dt drops below min_dt
		dt = math.min(dt, min_dt)

		-- caps fps for drawing
		next_time = next_time + min_dt
	--]
	
	transitions:run(dt)
	input:checkkeys(dt)

	--run the world
	if mode == "title" then	title:update(dt) else world:update(dt) end

end



function love.draw()

	--titlescreen
	if mode == "title" then 
		title:draw() 
	end
	
	--world
	if mode == "game" or mode =="editing" then
		world:draw(dt) 
	end
	
	--transition overlay
	transitions:draw()
	
	if console then util:drawConsole() end

	-- caps fps
	local cur_time = love.timer.getTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	love.timer.sleep(next_time - cur_time)
end

function love.resize(w,h)
	WIDTH = w
	HEIGHT = h
	util:dprint("resized window ("..w.."x"..h..")")
	
end



