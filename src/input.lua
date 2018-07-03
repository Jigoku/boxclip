input = {}

function input:checkkeys(dt)

	
	if mode == "editing" then
		if editing then editor:checkkeys(dt) end
	end
end

function love.mousemoved(x,y,dx,dy)
	if mode == "editing" then editor:mousemoved(x,y,dx,dy) end
end

function love.mousepressed(x, y, button)
	if mode == "editing" then editor:mousepressed(x,y,button) end
end

function love.mousereleased(x, y, button)
	if mode == "editing" then editor:mousereleased(x,y,button) end
end


function love.wheelmoved(x, y)
	if mode == "editing" then editor:wheelmoved(x,y) end
end

function love.keypressed(key)
	
	if     mode == "title" then title:keypressed(key)
	elseif mode == "editing" then editor:keypressed(key)
	elseif mode == "gameover" then gameover:keypressed(key)
	elseif mode == "game" then
		if key == binds.pause then
				
			-- broken? does not resume.
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
	
	--debug mode console
	if key == binds.debug then
		console:toggle()
	end

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

	if key == binds.savefolder then
		love.system.openURL( "file://"..mapio.path )
	end

end
