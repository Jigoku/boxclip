input = {}

function input:check(dt)
	if not editing then
		if love.keyboard.isDown("d") or love.keyboard.isDown("right") 
			and player.alive == 1 then
			player.lastdir = player.dir
			player.dir = "right"	
	
		elseif love.keyboard.isDown("a") or love.keyboard.isDown("left")
			and player.alive == 1 then
			player.lastdir = player.dir
			player.dir = "left"
			
		else
			player.dir = "idle"

		end
	else
		--edit mode
		if love.keyboard.isDown("d") or love.keyboard.isDown("right")  then
			player.x = player.x + 1000 *dt
		end
		if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			player.x = player.x - 1000 *dt
		end
		if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			player.y = player.y - 1000 *dt
		end
		if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
			player.y = player.y + 1000 *dt
		end
	end
end

function love.mousemoved(x,y,dx,dy)
	mousePosX = util:round(camera.x+x*camera.scaleX)
	mousePosY = util:round(camera.y+y*camera.scaleY)

	if editing then
		if love.mouse.isDown("l") then
			editor.drawsel = true
		else
			editor.drawsel = false
		end
	
	end
end

function love.mousepressed(x, y, button)
	pressedPosX = util:round(camera.x+x*camera.scaleX)
	pressedPosY = util:round(camera.y+y*camera.scaleY)

	if editing then
		editor:mousepressed(x,y,button)
	end
end

function love.mousereleased(x, y, button)
	releasedPosX = util:round(camera.x+x*camera.scaleX)
	releasedPosY = util:round(camera.y+y*camera.scaleY)
	
	if editing then
		editor.drawsel = false
		editor:mousereleased(x,y,button)
	end
   
end

function love.keypressed(key)
		util:dprint("[KEY        ] '".. key .. "'")
	
		--quit
		if key == "escape" then
				love.event.quit()
		end

		if key == "f1" then
			editing = not editing
		end

		--debug console
		if key == "`" then
			love.audio.play( sound.beep )
			console = not console
		end

		if editing then
			editor:keypressed(key)
		end

		
		--debug console
		if key == "z" then
			love.audio.play( sound.beep )
			if camera.scaleX == 1 and camera.scaleY == 1 then
				camera.scaleX = 2
				camera.scaleY = 2
			else
				camera.scaleX = 1
				camera.scaleY = 1 
			end
			
		end

		--toggle fullscreen
		if key == "f5" then
			local fullscreen, fstype = love.window.getFullscreen()
			if fullscreen then
				local success = love.window.setFullscreen( false )
			else
				local success = love.window.setFullscreen( true, "desktop" )
			end
			
			if not success then
				util:dprint("Failed to toggle fullscreen mode!")
			end
		end
		

		if not editing then
			if player.alive == 1 then
				--jump
				if key == " " then
					if player.jumping == 0 then
						sound:play(sound.jump)
						player.jumping = 1
						player.yvel = player.jumpheight
						
					end
				end
	
				--suicide
				if key == "b" then
					player:respawn()
				end
			end
		end
end
