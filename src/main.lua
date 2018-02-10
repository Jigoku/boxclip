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
function love.load(args)
	
	debug = false
	
	require("tools")
	require("console")
	require("mapio")
	require("sound")
	require("binds")
	require("input")
	require("fonts")
	require("textures")
	
	require("menus/main")
	require("entities/main")
	require("game/main")



	game = {}
		game.w, game.h, game.flags = love.window.getMode()
		game.max_fps = game.flags.refreshrate
		game.min_dt = 1/game.max_fps
		game.next_time = love.timer.getTime()
		game.icon = love.image.newImageData("data/images/icon.png")
		game.runtime = os.time()
		game.ticks = 0
	
	local options = {
		{
			pattern = "^[-]-c$",
			description = "enable the console", 
			exec = function() console:toggle() end
		},
		{ 
			pattern = "^[-]-f$", 
			description = "enable fullscreen", 
			exec = function() love.window.setFullscreen( true, "exclusive" ) end
		},
		{ 
			pattern = "^[-]-m$", 
			description = "mute audio", 
			exec = function() sound:toggle() end
		}
	}
	
	for _,arg in ipairs(args) do 
		for n, o in ipairs(options) do
			if string.match(arg, o.pattern) then o.exec() end
		end
	end


	love.window.setIcon(game.icon)
	love.mouse.setVisible(false)
	love.mouse.setGrabbed(true)
	
	

	sound:init()
	title:init()

end



function love.update(dt)
	game.ticks = game.ticks +1
	
	--[ frame rate cap
		-- fix for lag (ex; caused by dragging window)
		--   stops collision failures when dt drops below min_dt
		dt = math.min(dt, game.min_dt)

		-- caps fps for drawing
		game.next_time = game.next_time + game.min_dt
	--]
	
	transitions:run(dt)
	input:checkkeys(dt)

	--run the world
	if mode == "title" then	
		title:update(dt) 
	end
	
	if mode == "game" then 
		world:update(dt) 
	end
	
	if mode == "editing" then	
		world:update(dt) 
		editor:update(dt) 
	end

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
	
	if console.show then console:draw() end

	-- caps fps
	local cur_time = love.timer.getTime()
	if game.next_time <= cur_time then
		game.next_time = cur_time
		return
	end
	love.timer.sleep(game.next_time - cur_time)
	

end

function love.resize(w,h)

	console:print("resized window ("..w.."x"..h..")")

	if mode == "game" or mode =="editing" then
		--reset camera
		world:resetcamera()
	end
end



