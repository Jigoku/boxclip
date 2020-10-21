-- console:print(" ****** crusher file test ****** ")
crusher = {}
table.insert(enemies.list, "crusher")
table.insert(editor.entities, {"crusher", "enemy"})
enemies.textures["crusher"] = {love.graphics.newImage("data/images/enemies/crusher.png"),}


function crusher.worldInsert(x,y,movespeed,movedist,dir,name)
	
	table.insert(world.entities.enemy, {
		movespeed = movespeed or 100,
		movedist = movedist or 300,
		movey = 1,
		ticks = love.math.random(100), 
		x = x or 0, 
		y = y or 0, 
		xorigin = x, 
		yorigin = y, 
		w = enemies.textures[name][1]:getWidth(),
		h = enemies.textures[name][1]:getHeight() ,
		group = "enemy",
		type = name,
		dir = 0,
		frame = 1,
		alive = true
	})
end

function crusher.checkCollision(entityCrusher, dt)
	entityCrusher.ticks = entityCrusher.ticks +1
	physics:crusher_movey(entityCrusher, dt)
	physics:update(entityCrusher)
	
	-- NOT ACTIVE WHILST EDITING 
	if mode == "game" and player.alive and collision:check(player.newX,player.newY,player.w,player.h,
		entityCrusher.x+5,entityCrusher.y+5,entityCrusher.w-10,entityCrusher.h-10) then
		
		if(entityCrusher.y < player.y and (player.x > entityCrusher.x and (player.x + player.w) < (entityCrusher.x + entityCrusher.w))) then
			
			player:die(entityCrusher.group)
		
		elseif (entityCrusher.y < player.y and (player.x<=entityCrusher.x or (player.x + player.w) >= (entityCrusher.x + entityCrusher.w))) then 
			
			subtract = player.dir * player.speed * 1.3 * 0.005;
			player.xvel = 0 
			player.x = player.x - subtract
			player.newX = player.x
			
		end
		
	end
	
end

