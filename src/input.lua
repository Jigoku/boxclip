input = {}

function input:checkkeys(dt)
	if mode == "game" then player:checkkeys(dt) end
	
	if mode == "editing" then
		player:checkkeys(dt)
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
	
	if mode == "title" then title:keypressed(key) end
	if mode == "editing" then editor:keypressed(key) end
	
	if mode == "game" then
		if key == binds.pause then
				paused = not paused
			
				if not paused then 
					love.audio.resume()
				else 
					love.audio.pause()
				end
					
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
		local screenshot = love.graphics.newScreenshot();
		local file = "screenshots/" .. os.date("%Y-%m-%d_%H%M%S") .. ".png"
		screenshot:encode("png", file);
		console:print("screenshot: " .. mapio.path .. "/" .. file .. " saved")
	end

	--toggle fullscreen
	if key == binds.fullscreen then 
	
		
		local fs, fstype = love.window.getFullscreen()
	
		if fs then

			local success = love.window.setMode( default_width,default_height)
			if mode == "game" or mode =="editing" then
				world:resetCamera()
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
