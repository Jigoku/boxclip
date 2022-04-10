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

 input = {}


function input:checkkeys(dt)
	-- Check additional keys when in the editor
	if mode == "editing" then
		if editing then editor:checkkeys(dt) end
	end
end


function love.mousemoved(x,y,dx,dy)
	-- Mouse input is only used whilst in the editor
	if mode == "editing" then editor:mousemoved(x,y,dx,dy) end
end


function love.mousepressed(x, y, button)
	-- Mouse input is only used whilst in the editor
	if mode == "editing" then editor:mousepressed(x,y,button) end
end


function love.mousereleased(x, y, button)
	-- Mouse input is only used whilst in the editor
	if mode == "editing" then editor:mousereleased(x,y,button) end
end


function love.wheelmoved(x, y)
	-- Mouse input is only used whilst in the editor
	if mode == "editing" then editor:wheelmoved(x,y) end
end


function love.keypressed(key)

	--debug mode console
	if console.active then
		console:keypressed(key)
		return
	else
		if key == binds.console then
			console:toggle()
		end
	end

	if     mode == "title" then title:keypressed(key)
	elseif mode == "editing" then editor:keypressed(key)
	elseif mode == "gameover" then gameover:keypressed(key)
	elseif mode == "game" then
		if key == binds.pause then
			if paused then love.audio.play(sound.music[world.mapmusic]) else love.audio.pause(sound.music[world.mapmusic]) end
			paused = not paused
			sound:play(sound.effects["beep"])
		end
	end

	--quit
	if mode == "game" or mode == "editing" then
		player:keypressed(key)

		if key == binds.exit then
			love.audio.stop()
			title:init()
		end
	end

	--[[ take a screenshot and save to local game data folder
		   * Linux/*nix = ~/.local/share/love/boxclip/screenshots/
		   * Windows    = ????
	--]]
	if key == binds.screenshot then
		local file = "screenshots/" .. os.date("%Y-%m-%d_%H%M%S") .. ".png"
		love.graphics.captureScreenshot(file)
		console:print("screenshot: " .. mapio.path .. "/" .. file .. " saved")
	end

	--toggle fullscreen
	if key == binds.fullscreen then

		local fs, fstype = love.window.getFullscreen()

		if fs then

			local success = love.window.setMode( default_width,default_height, {resizable=true, vsync=false, minwidth=default_width, minheight=default_height})
			if mode == "game" or mode =="editing" then
				world:resetcamera()
			end
		else
			local success = love.window.setFullscreen( true, "desktop" )
		end


		if not success then
			console:print("Failed to toggle fullscreen mode!")
		end

	 end

	--toggle sound
	if key == binds.mute then
		sound.enabled = not sound.enabled
	end

	--[[ open local data folder with user set application
	     NOTE to change this:
	     $ xdg-mime default Thunar.desktop inode/directory
	--]]
	if key == binds.savefolder then
		love.system.openURL( "file://"..mapio.path )
	end

end
