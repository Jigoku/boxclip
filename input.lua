input = {}

function input:checkkeys(dt)
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
	end
	
	if editing then editor:checkkeys(dt) end
end

function love.mousemoved(x,y,dx,dy)
	mousePosX = math.round(camera.x+x*camera.scaleX,-1)
	mousePosY = math.round(camera.y+y*camera.scaleY,-1)

	if editing then
		if love.mouse.isDown("l") then
			editor.drawsel = true
		else
			editor.drawsel = false
		end
	
	end
end

function love.mousepressed(x, y, button)
	pressedPosX = math.round(camera.x+x*camera.scaleX,-1)
	pressedPosY = math.round(camera.y+y*camera.scaleY,-1)

	if editing then
		editor:mousepressed(x,y,button)
	end
end

function love.mousereleased(x, y, button)
	releasedPosX = math.round(camera.x+x*camera.scaleX,-1)
	releasedPosY = math.round(camera.y+y*camera.scaleY,-1)
	
	if editing then
		editor.drawsel = false
		editor:mousereleased(x,y,button)
	end
   
end

function love.keypressed(key)
		--util:dprint("[KEY        ] '".. key .. "'")
		
		if mode == "title" then
			if key == "1" then
				mode = "game"
					world:init()
					player:init()
					world:loadMap(world.map)
					player:respawn()
			end
			if key == "2" then
				mode = "editing"
					world:init()
					player:init()
					world:loadMap(world.map)
					player:respawn()
					
			end
		end
	
	
	
		--quit
		if key == "escape" then 
			if mode == "title" then
				love.event.quit() 
			end
			if mode == "game" or mode == "editing" then
				mode = "title"
			end
		end
		
		if mode == "editing" then
			--free roaming
			if key == "f1" then 
				editing = not editing
				player.xvel = 0
				player.yvel = 0
			end
			--zoom
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
			
		end
		
		--debug console
		if key == "`" then
			love.audio.play( sound.beep )
			console = not console
		end

		if editing then editor:keypressed(key) end

		


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
			end
		end
end
