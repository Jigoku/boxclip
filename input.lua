input = {}

function input:check(dt)
	if mode == 1 then
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
end

function love.mousepressed(x, y, button)
	--temporary test
	if debug == 1 then
		if button == 'l' then
			structures:crate(util:round(camera.x+x*camera.scaleX),util:round(camera.y+y*camera.scaleY),"gem")
			print( "crate added @  X:"..util:round(camera.x+x).." Y: "..util:round(camera.y+y))
		end
	end
end

function love.keypressed(key)
		util:dprint("[KEY        ] '".. key .. "'")
	
		--quit
		if key == "escape" then
				love.event.quit()
		end

		--debug console
		if key == "`" then
			love.audio.play( sound.beep )
			if debug == 1 then
				debug = 0
			elseif debug == 0 then
				debug =1
			end
			
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
		

		if mode == 1 then
			if player.alive == 1 then
				--jump
				if key == " " and mode == 1 then
					if player.jumping == 0 then
						sound:play(sound.jump)
						player.jumping = 1
						player.yvel = player.jumpheight
						
					end
				end
	
				--suicide
				if key == "b" then
					physics:kill(player)
				end
			end
		end
end
