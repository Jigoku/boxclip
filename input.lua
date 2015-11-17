input = {}

function input:checkkeys(dt)
	if mode == "game" or mode == "editing" then player:checkkeys(dt) end
	if editing then editor:checkkeys(dt) end
end

function love.mousemoved(x,y,dx,dy)
	mousePosX = math.round(camera.x-(WIDTH/2*camera.scaleX)+x*camera.scaleX,-1)
	mousePosY = math.round(camera.y-(HEIGHT/2*camera.scaleY)+y*camera.scaleX,-1)

	if editing then
		if love.mouse.isDown("l") then
			editor.drawsel = true
		else
			editor.drawsel = false
		end
	
	end
end

function love.mousepressed(x, y, button)
	pressedPosX = math.round(camera.x-(WIDTH/2*camera.scaleX)+x*camera.scaleX,-1)
	pressedPosY = math.round(camera.y-(HEIGHT/2*camera.scaleY)+y*camera.scaleX,-1)

	if editing then
		editor:mousepressed(x,y,button)
	end
end

function love.mousereleased(x, y, button)
	releasedPosX = math.round(camera.x-(WIDTH/2*camera.scaleX)+x*camera.scaleX,-1)
	releasedPosY = math.round(camera.y-(HEIGHT/2*camera.scaleY)+y*camera.scaleX,-1)
	
	if editing then
		editor.drawsel = false
		editor:mousereleased(x,y,button)
	end
   
end

function love.keypressed(key)
	
	if mode == "title" then title:keypressed(key) end
	if mode == "editing" then editor:keypressed(key) end
	
	if mode == "game" then
		if key == "p" then
			paused = not paused
			
			if not paused then
				love.audio.resume()
			else
				love.audio.pause()
			end
		end
	end
	
	--quit
	if mode == "game" or mode == "editing" then
		player:keypressed(key) 
		
		if key == "escape" then
			title:init()
		end
	end
	
	--debug mode console
	if key == "`" then
		love.audio.play( sound.beep )
		console = not console
		debug = not debug
	end

	--toggle fullscreen
	if key == "f5" then util:togglefullscreen() end
		


end
