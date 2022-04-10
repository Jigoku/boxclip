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


--[[
	Boxclip 2d engine by ricky thomson
--]]

function love.load(args)

	debug = false

	require("joystick")
	require("tools")
	require("console")
	require("mapio")
	require("sound")
	require("binds")
	require("input")
	require("fonts")
	require("textures")

	require("menus")
	require("game")
	require("editor")
	require("entities")

	--set argument flags
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

	--parse / execute arguments
	for _,arg in ipairs(args) do
		for n, o in ipairs(options) do
			if string.match(arg, o.pattern) then
				o.exec()
			end
		end
	end

	--initialise everything
	love.window.setIcon(game.icon)
	love.mouse.setVisible(false)
	--love.mouse.setGrabbed(true)

	console:init()
	sound:init()
	title:init()
end


function love.update(dt)

	--collectgarbage()

	game.ticks = game.ticks +1
	game.utick_start = love.timer.getTime()*1000

	--[ frame rate cap
		-- fix for lag (ex; caused by dragging window)
		--   stops collision failures when dt drops below min_dt
		dt = math.min(dt, game.min_dt)

		-- caps fps for drawing
		game.next_time = game.next_time + game.min_dt
	--]

	transitions:run(dt)
	input:checkkeys(dt)
	console:update(dt)

	--run the world
	if mode == "title" then
		title:update(dt)

	end

	if mode == "game" then
		world:update(dt)
	end

	if mode == "editing" then
		editor:update(dt)
	end

	game.utick_time = love.timer.getTime( )*1000 - game.utick_start

end



function love.draw()
	game.dtick_start = love.timer.getTime()*1000

	if mode == "title" then
		title:draw()

	elseif mode == "game" or mode =="editing" then
		world:draw()
	elseif mode == "gameover" then
		gameover:draw()
	end

	--transition overlay
	transitions:draw()

	--draw the console
	console:draw()

	if fps then
		--fps info etc
		love.graphics.setFont(fonts.fps)
		love.graphics.setColor(0,0,0,0.7)
		love.graphics.rectangle("fill",love.graphics.getWidth()-160, 5,150,105,10)

		love.graphics.setColor(0.5,1,1,1)
		love.graphics.print(
			"fps  : " .. love.timer.getFPS() .. "\n" ..
			"ram  : " .. math.round(collectgarbage('count')) .."kB\n"..
			"vram : " .. string.format("%.2fMB", love.graphics.getStats().texturememory / 1024 / 1024) .. "\n" ..
			"tick : " .. game.ticks .. "\n" ..
			"utime: " .. math.round(game.utick_time,1) .. "ms\n" ..
			"dtime: " .. math.round(game.dtick_time,1) .. "ms",
			love.graphics.getWidth()-155, 10
		)

	end


	game.dtick_time = love.timer.getTime( )*1000 - game.dtick_start

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


function love.textinput(t)
	console:textinput(t)
end

