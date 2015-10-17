--[[
	editor binds
	
	select ent type	: 1-9
	move up			: numpad 8
	move down		: numpad 2
	move left		: numpad 4
	move right		: numpad 6
	copy dimensions	: c
	paste			: p	
	delete entity	: del
	camera scale	: z
	camera position	: w,a,s,d
--]]

--[[
entity id's
	0 = spawn
	1 = goal
	2 = platform
	3 = platform_x
	4 = platform_y
	5 = checkpoint
	6 = crate
	7 = spike
	8 = icicle
	9 = walker
	10 = gem
	11 = life
	12 = flower
--]]



editor = {}
editing = false

mousePosX = 0
mousePosY = 0

editor.entdir = 0 --(used for some entites 0,1,2,3 = up,down,right,left)
editor.entsel = 0
editor.showpos = true
editor.showid  = true
editor.drawsel = false
editor.drawminimap = true
editor.movespeed = 1000
	
editor.clipboard = {}


function editor:entname(id)
	if id == 0 then return "spawn" 
	elseif id == 1 then return "goal" 
	elseif id == 2 then return "platform" 
	elseif id == 3 then return "platform_x" 
	elseif id == 4 then return "platform_y" 
	elseif id == 5 then return "checkpoint" 
	elseif id == 6 then return "crate" 
	elseif id == 7 then return "spike" 
	elseif id == 8 then return "icicle" 
	elseif id == 9 then return "walker" 
	elseif id ==10 then return "gem" 
	elseif id ==11 then return "life" 
	elseif id ==12 then return "flower" 
	elseif id ==13 then return "rock" 
	else return editor.entsel
	end
end

function editor:keypressed(key)
	--print (key)
	if love.keyboard.isDown("kp+") then editor.entsel = editor.entsel +1 end
	if love.keyboard.isDown("kp-") then editor.entsel = editor.entsel -1 end
	
	if love.keyboard.isDown("delete") then self:removesel() end
	if love.keyboard.isDown("c") then self:copy() end
	if love.keyboard.isDown("v") then self:paste() end
	if love.keyboard.isDown("r") then self:rotate() end
	
	if love.keyboard.isDown("m") then self.drawminimap = not self.drawminimap end
	if love.keyboard.isDown(",") then self.showpos = not self.showpos end
	if love.keyboard.isDown(".") then self.showid = not self.showid end
	if love.keyboard.isDown("f12") then self:savemap(world.map) end

	if key == "kp8" or key == "kp2" or key == "kp4" or key == "kp6" then
	for i, platform in ipairs(platforms) do
		--fix this for moving platform (yorigin,xorigin etc)
		if world:inview(platform) then
			if collision:check(mousePosX,mousePosY,1,1, platform.x,platform.y,platform.w,platform.h) then
				if love.keyboard.isDown("kp8") then 
					platform.y = math.round(platform.y - 10,-1) --up
				end
				if love.keyboard.isDown("kp2") then 
					platform.y = math.round(platform.y + 10,-1) --down
					platform.yorigin = platform.y
				end 
				if love.keyboard.isDown("kp4") then 
					platform.x = math.round(platform.x - 10,-1) --left
					platform.xorigin = platform.x
				end 
				if love.keyboard.isDown("kp6") then 
					platform.x = math.round(platform.x + 10,-1)  --right
					platform.xorigin = platform.x
				end

				return true
			end
		end
	end
	end
end

function editor:checkkeys(dt)
		if love.keyboard.isDown("d") or love.keyboard.isDown("right")  then
			player.x = player.x + editor.movespeed *dt
		end
		if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			player.x = player.x - editor.movespeed *dt
		end
		if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			player.y = player.y - editor.movespeed *dt
		end
		if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
			player.y = player.y + editor.movespeed *dt
		end
end


function editor:mousepressed(x,y,button)
	
	local x = math.round(pressedPosX,-1)
	local y = math.round(pressedPosY,-1)
	
	-- entity selection with mousescroll
	if button == 'wu' then editor.entsel = editor.entsel +1 end
	if button == 'wd' then editor.entsel = editor.entsel -1 end
	
	if button == 'l' then
		local selection = self:entname(self.entsel)
		if selection == "spawn" then
			self:removeall(portals, "spawn")
			portals:add(x,y,"spawn")
		end
		if selection == "goal" then
			self:removeall(portals, "goal")
			portals:add(x,y,"goal")
		end
		
		if selection == "crate" then
			crates:add(x,y,"gem")
		end
		
		if selection == "walker" then
			enemies:walker(x,y,100,100) --movespeed,movedist should be configurable
		end
		if selection == "checkpoint" then
			checkpoints:add(x,y)

		end
		if selection == "gem" then
			pickups:add(x,y,"gem")
		end
		if selection == "life" then
			pickups:add(x,y,"life")
		end
		if selection == "spike" then
			enemies:spike(x,y,editor.entdir)
			--enemies:spike(x,y,dir)
		end
		if selection == "flower" then
			scenery:add(x,y,"flower")
		end
		if selection == "rock" then
			scenery:add(x,y,"rock")
		end
		
	elseif button == 'r' then
		editor:removesel()
	end
end

function editor:mousereleased(x,y,button)
	if button == 'l' then
		local selection = self:entname(self.entsel)
		if selection == "platform" or selection == "platform_x" or selection == "platform_y" then
			self:addplatform(pressedPosX,pressedPosY,releasedPosX,releasedPosY)
		end
		return
	end
end


function editor:addplatform(x1,y1,x2,y2)
	-- add platform platform

	if not (x2 < x1 or y2 < y1) then
		--min sizes
		if x2-x1 < 20  then x2 = x1 +20 end
		if y2-y1 < 20  then y2 = y1 +20 end

		local x = math.round(x1,-1)
		local y = math.round(y1,-1)
		local w = (x2-x1)
		local h = (y2-y1)
		
		if self.entsel == 2 then
			platforms:add(x,y,w,h, 0,0,0,0)
		end
		if self.entsel == 3 then
			platforms:add(x,y,w,h, 1, 0, 100, 200)
		end
		if self.entsel == 4 then
			platforms:add(x,y,w,h, 0, 1, 100, 200)
		end

	end
end


function editor:crosshair()
	love.graphics.setColor(200,200,255,50)
	--vertical
	love.graphics.line(
		math.round(mousePosX,-1),
		math.round(mousePosY+love.graphics.getHeight()*camera.scaleY,-1),
		math.round(mousePosX,-1),
		math.round(mousePosY-love.graphics.getHeight()*camera.scaleY,-1)
	)
	--horizontal
	love.graphics.line(
		math.round(mousePosX-love.graphics.getWidth()*camera.scaleX,-1),
		math.round(mousePosY,-1),
		math.round(mousePosX+love.graphics.getWidth()*camera.scaleX-1),
		math.round(mousePosY,-1)
	)
	love.graphics.setColor(255,200,255,255)
	love.graphics.line(
		math.round(mousePosX,-1),
		math.round(mousePosY,-1),
		math.round(mousePosX,-1)+10,
		math.round(mousePosY,-1)
	)
	love.graphics.line(
		math.round(mousePosX,-1),
		math.round(mousePosY,-1),
		math.round(mousePosX,-1),
		math.round(mousePosY,-1)+10
	)
	
	cursor = { x =mousePosX, y =mousePosY   }
	util:drawCoordinates(cursor)
	
end


function editor:draw()
	camera:set()
	
	editor:crosshair()
	editor:drawselected()
	editor:drawselbox()
	
	camera:unset()
	
	if editor.drawminimap then
		editor:drawmmap()
	end
	
end

function editor:drawselbox()
	if editor.drawsel then
		love.graphics.setColor(0,255,255,100)
		love.graphics.rectangle(
			"line", 
			pressedPosX,pressedPosY, 
			mousePosX-pressedPosX, mousePosY-pressedPosY
		)
	end
end

function editor:drawselected()
	return self:selection(enemies) or
			self:selection(pickups) or	
			self:selection(portals) or		
			self:selection(crates) or
			self:selection(checkpoints) or
			self:selection(scenery) or
			self:selection(platforms)
end

function editor:selection(entity, x,y,w,h)
	-- hilights the entity when mouseover 
	love.graphics.setColor(0,255,0,200)
	for i, entity in ripairs(entity) do
		if world:inview(entity) then
			if entity.movex == 1 then
				if collision:check(mousePosX,mousePosY,1,1,entity.xorigin, entity.yorigin, entity.movedist+entity.w, entity.h) then
					love.graphics.rectangle("line", entity.xorigin, entity.yorigin, entity.movedist+entity.w, entity.h)
					return true
				end
			elseif entity.movey == 1 then
				if collision:check(mousePosX,mousePosY,1,1,entity.xorigin, entity.yorigin, entity.w, entity.h+entity.movedist) then
					love.graphics.rectangle("line", entity.xorigin, entity.yorigin,entity.w, entity.h+entity.movedist)
					return true
				end
			else
				if collision:check(mousePosX,mousePosY,1,1,entity.x,entity.y,entity.w,entity.h) then
					love.graphics.rectangle("line", entity.x,entity.y,entity.w,entity.h)
					return true
				end
			end
		end
	end
end

function editor:removesel()
	return self:remove(enemies) or
			self:remove(pickups) or	
			self:remove(portals) or		
			self:remove(crates) or
			self:remove(checkpoints) or
			self:remove(scenery) or
			self:remove(platforms)
end

function editor:removeall(objects, name)
	for i, entity in ipairs(objects) do
		if type(entity) == "table" and entity.name == name then

			table.remove(objects,i)
		end
	end
end

function editor:remove(type, x,y,w,h)
	--deletes the selected entity
	
	for i, item in ripairs(type) do
		if world:inview(item) then
			if collision:check(mousePosX,mousePosY,1,1, item.x,item.y,item.w,item.h) then
				print( item.name .. " (" .. i .. ") removed" )
				table.remove(type,i)
				return true
			end
		end
	end
end


function editor:rotate()
	editor.entdir = editor.entdir +1
	if editor.entdir > 3 then
		editor.entdir = 0
	end
end

function editor:copy()
	--primitive copy (dimensions only for now)
	for i, platform in ripairs(platforms) do
		if world:inview(platform) then
			if collision:check(mousePosX,mousePosY,1,1, platform.x,platform.y,platform.w,platform.h) then
				self.clipboard = {
					w = platform.w,
					h = platform.h
				}
				return true
			end
		end
	end
end

function editor:paste()
	--paste the new entity with copied paramaters
	local x = math.round(mousePosX,-1)
	local y = math.round(mousePosY,-1)
	local w = self.clipboard.w or 20
	local h = self.clipboard.h or 20
	local selection = editor:entname(self.entsel)
	if selection == "platform" then
		platforms:add(x,y,w,h,0,0,0,0)
	end
	if selection == "platform_x" then
		platforms:add(x,y,w,h, 1, 0, 100, 200)
	end
	if selection == "platform_y" then
		platforms:add(x,y,w,h, 0, 1, 100, 200)
	end
end

function editor:run(dt)
	player.xvel = 0
	player.yvel = 0
end


function editor:drawmmap()
	--experimental! does not work as intended!
	editor.mmapw = love.window.getWidth()/5
	editor.mmaph = love.window.getHeight()/5
	editor.mmapscale = 15
	mmapcanvas = love.graphics.newCanvas( editor.mmapw, editor.mmaph )
	love.graphics.setCanvas(mmapcanvas)
	mmapcanvas:clear()


	love.graphics.setColor(0,0,0,100)
	love.graphics.rectangle("fill", 0,0,editor.mmapw,editor.mmaph )
	

	love.graphics.setColor(255,50,0,255)
	for i, platform in ipairs(platforms) do
		love.graphics.rectangle(
			"fill", 
			(platform.x/editor.mmapscale)-(camera.x/editor.mmapscale)+editor.mmapw/3, 
			(platform.y/editor.mmapscale)-(camera.y/editor.mmapscale)+editor.mmaph/3, 
			platform.w/editor.mmapscale, 
			platform.h/editor.mmapscale
		)
	end

	love.graphics.setColor(0,255,255,255)
	for i, crate in ipairs(crates) do
		love.graphics.rectangle(
			"fill", 
			(crate.x/editor.mmapscale)-camera.x/editor.mmapscale+editor.mmapw/3, 
			(crate.y/editor.mmapscale)-camera.y/editor.mmapscale+editor.mmaph/3, 
			crate.w/editor.mmapscale, 
			crate.h/editor.mmapscale
		)
	end
	
	love.graphics.setColor(255,0,255,255)
	for i, enemy in ipairs(enemies) do
		love.graphics.rectangle(
			"line", 
			(enemy.x/editor.mmapscale)-camera.x/editor.mmapscale+editor.mmapw/3, 
			(enemy.y/editor.mmapscale)-camera.y/editor.mmapscale+editor.mmaph/3, 
			enemy.w/editor.mmapscale, 
			enemy.h/editor.mmapscale
		)
	end
	
	love.graphics.setColor(255,255,100,255)
	for i, pickup in ipairs(pickups) do
		love.graphics.rectangle(
			"line", 
			(pickup.x/editor.mmapscale)-camera.x/editor.mmapscale+editor.mmapw/3, 
			(pickup.y/editor.mmapscale)-camera.y/editor.mmapscale+editor.mmaph/3, 
			pickup.w/editor.mmapscale, 
			pickup.h/editor.mmapscale
		)
	end
	
	love.graphics.setColor(0,255,0,255)
	for i, checkpoint in ipairs(checkpoints) do
		love.graphics.rectangle(
			"fill", 
			(checkpoint.x/editor.mmapscale)-camera.x/editor.mmapscale+editor.mmapw/3, 
			(checkpoint.y/editor.mmapscale)-camera.y/editor.mmapscale+editor.mmaph/3, 
			checkpoint.w/editor.mmapscale, 
			checkpoint.h/editor.mmapscale
		)
	end

	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle(
		"line", 
		(player.x/editor.mmapscale)-(camera.x/editor.mmapscale)+editor.mmapw/3, 
		(player.y/editor.mmapscale)-(camera.y/editor.mmapscale)+editor.mmaph/3, 
		player.w/editor.mmapscale, 
		player.h/editor.mmapscale
	)
	

	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(mmapcanvas, love.window.getWidth()-10-editor.mmapw,love.graphics.getHeight()-10-editor.mmaph )

end


function editor:savemap(map)
	local fh = io.open(map, "w+")
	fh:write("background=130,150,150,255".."\n")
	fh:write("mapmusic=2".."\n")
	for i, entity in ipairs(platforms) do
		fh:write("platform="..math.round(entity.xorigin)..","..math.round(entity.yorigin)..","..entity.w..","..entity.h..","..entity.movex..","..entity.movey..","..entity.movespeed..","..entity.movedist.."\n")
	end
	
	for i, entity in ipairs(pickups) do
		fh:write("pickup="..math.round(entity.x)..","..math.round(entity.y)..","..entity.name.."\n")
	end
	for i, entity in ipairs(crates) do
		fh:write("crate="..math.round(entity.x)..","..math.round(entity.y)..","..entity.item.."\n")
	end
	for i, entity in ipairs(checkpoints) do
		fh:write("checkpoint="..math.round(entity.x)..","..math.round(entity.y).."\n")
	end
	for i, entity in ipairs(enemies) do
		if entity.name == "walker" then
			fh:write("walker="..math.round(entity.xorigin)..","..math.round(entity.y)..","..entity.movespeed..","..entity.movedist.."\n")
		end
		if entity.name == "spike" then
			fh:write("spike="..math.round(entity.x)..","..math.round(entity.y)..","..math.round(entity.dir).."\n")
		end
	end
	for i, entity in ipairs(scenery) do
		fh:write("scenery="..math.round(entity.x)..","..math.round(entity.y)..","..entity.name.."\n")
	end
	for i, entity in ipairs(portals) do
		fh:write("portal="..math.round(entity.x)..","..math.round(entity.y)..","..entity.name.."\n")
	end
	fh:close()
end
