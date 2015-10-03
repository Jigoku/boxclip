player = {}

function player:init() 
	player.w = 40
	player.h = 40
	player.x = world.cameraOffset
	player.y = world.groundLevel

	player.speed = 400
	player.mass = 800
	player.xvel = 0
	player.yvel = 0
	player.jumpheight = 800
	player.jumping = 0
	player.dir = "idle"
	player.lastdir = "idle"
	player.score = 0
	player.alive = 1
	player.life = 3	
		camera:setPosition(
			player.x - (love.graphics.getWidth()/2) +(player.w/2),
			player.y - (world.groundLevel -200)
		)
end



function player:draw()
	--body trails		
	
	love.graphics.setColor(40,180,120,100)
	love.graphics.rectangle("fill", player.x-player.xvel/(player.mass/10), player.y+player.yvel/(player.jumpheight/10), player.w, player.h)
	love.graphics.setColor(80,80,80,100)
	love.graphics.rectangle("line", player.x-player.xvel/(player.mass/10), player.y+player.yvel/(player.jumpheight/10), player.w, player.h)
	
	love.graphics.setColor(40,180,120,50)
	love.graphics.rectangle("fill", player.x-player.xvel/(player.mass/20), player.y+player.yvel/(player.jumpheight/20), player.w, player.h)
	love.graphics.setColor(80,80,80,50)
	love.graphics.rectangle("line", player.x-player.xvel/(player.mass/20), player.y+player.yvel/(player.jumpheight/20), player.w, player.h)
	
	love.graphics.setColor(40,180,120,25)
	love.graphics.rectangle("fill", player.x-player.xvel/(player.mass/30), player.y+player.yvel/(player.jumpheight/30), player.w, player.h)
	love.graphics.setColor(80,80,80,25)
	love.graphics.rectangle("line", player.x-player.xvel/(player.mass/30), player.y+player.yvel/(player.jumpheight/30), player.w, player.h)
	
	--player main	
	love.graphics.setColor(40,180,120,255)
	love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
	love.graphics.setColor(80,80,80,255)
	love.graphics.rectangle("line", player.x, player.y, player.w, player.h)
	
	--eyes
	love.graphics.setColor(0,0,0,255)
	if player.lastdir == "right" then
		love.graphics.rectangle("fill", player.x+player.w-10, player.y+10, 3, 4)
		love.graphics.rectangle("fill", player.x+player.w-20, player.y+10, 3, 4 )
	end
	
	if player.lastdir == "left" then
		love.graphics.rectangle("fill", player.x+10, player.y+10, 3, 4)
		love.graphics.rectangle("fill", player.x+20, player.y+10, 3, 4 )
	end
	

	
	if debug == 1 then
		player:drawDebug()
	end
end

function player:drawDebug()
	
	love.graphics.setColor(255,0,0,100)
	love.graphics.rectangle("line", player.x, player.y, player.w, player.h)
	util:drawCoordinates(player)
	
end

function player:follow(bool)
	if bool == 1 then
		-- follow player
		if player.alive == 1 then
		
			if player.x > world.cameraOffset then
				camera:setPosition(
						player.x - (love.graphics.getWidth()/2) +(player.w/2),
						player.y - (love.graphics.getHeight()/2) +(player.h/2) -50
				)
			else
				camera:setPosition(
						null,
						player.y - (love.graphics.getHeight()/2) +(player.h/2) - 50
				)

			end
			
		elseif player.y > world.groundLevel then
			world:init()
			player:init()
		end
	
	end
	

end



function player:collect(item)
	util:dprint("[PICKUP     ] item")
	
	if item == "coin" then
		sound:play(sound.coin)
		player.score = player.score + 5
	elseif item == "life" then
		sound:play(sound.lifeup)
		player.life = player.life +1
	end
end
