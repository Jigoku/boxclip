input = {}

function input:checkkeys(dt)
	if not editing and player.alive == 1 then

		if love.keyboard.isDown("d") or love.keyboard.isDown("right")  then
			player:moveright()
	
		elseif love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			player:moveleft()
			
		else
			player.dir = "idle"
		end
	end
	
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
		--util:dprint("[KEY        ] '".. key .. "'")
		
		if mode == "title" then
			title:keypressed(key)
		end
	

		--quit
		if mode == "game" or mode == "editing" then
			if key == "escape" then
				title:init()
			end
		end
		
		if mode == "editing" then
			editor:keypressed(key)
		end
		
		--debug console
		if key == "`" then
			love.audio.play( sound.beep )
			console = not console
			debug = not debug
		end

		

		


		--toggle fullscreen
		if key == "f5" then
			util:togglefullscreen()
		end
		

		if not editing then
			if player.alive == 1 then
				--jump
				if key == " " then
					player:jump()
				end
			end
		end
end
