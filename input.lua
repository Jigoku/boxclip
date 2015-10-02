function checkInput(dt)
	
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

function love.keypressed(key)
	print("[KEY        ] '".. key .. "'")
		if key == "escape" then
				love.event.quit()
		end

		if key == "`" then
			if debug == 1 then
				debug = 0
			elseif debug == 0 then
				debug =1
			end
			
		end

		if key == " " then
			if player.jumping == 0 then
				player.jumping = 1
				player.yvel = player.jumpheight
				
			end
		end
		
		if key == "b" then
				player.alive=0
				player.jumping = 1 -- stupid if we can jump while dead...?
		end
end
