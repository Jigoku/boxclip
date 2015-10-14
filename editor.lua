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

editor = {}
editing = false

mousePosX = 0
mousePosY = 0

editor.entsel = "nil"
editor.showpos = true
editor.showid  = true
editor.drawsel = false
editor.drawminimap = true
editor.movespeed = 1000
	
editor.clipboard = {}


function editor:keypressed(key)
	if love.keyboard.isDown("1") then self.entsel = "platform" end
	if love.keyboard.isDown("2") then self.entsel = "platform_y" end
	if love.keyboard.isDown("3") then self.entsel = "platform_x" end
	if love.keyboard.isDown("4") then self.entsel = "crate" end
	if love.keyboard.isDown("5") then self.entsel = "walker" end
	if love.keyboard.isDown("6") then self.entsel = "checkpoint" end
	if love.keyboard.isDown("7") then self.entsel = "gem" end
	if love.keyboard.isDown("8") then self.entsel = "life" end
	if love.keyboard.isDown("9") then self.entsel = "spike" end
	
	if love.keyboard.isDown("delete") then self:removesel() end
	if love.keyboard.isDown("c") then self:copy() end
	if love.keyboard.isDown("v") then self:paste() end
	if love.keyboard.isDown("m") then self.drawminimap = not self.drawminimap end
	
	if love.keyboard.isDown(",") then self.showpos = not self.showpos end
	if love.keyboard.isDown(".") then self.showid = not self.showid end

	if love.keyboard.isDown("f12") then self:savemap(world.map) end

	for i, platform in ipairs(platforms) do
		--fix this for moving platform (yorigin,xorigin etc)
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


function editor:mousepressed(button)
	
	local x = math.round(pressedPosX,-1)
	local y = math.round(pressedPosY,-1)
	
	if button == 'l' then

	
		if self.entsel == "crate" then
				crates:add(x,y,"gem")
		end
		
		if self.entsel == "walker" then
			enemies:walker(x,y,movespeed,movedist)
		end
		if self.entsel == "checkpoint" then
			checkpoints:add(x,y)

		end
		if self.entsel == "gem" then
			pickups:add(x,y,"gem")
		end
		if self.entsel == "life" then
			pickups:add(x,y,"life")
		end
		if self.entsel == "spike" then
			enemies:spike(x,y)

		end
		
	end
	if button == 'r' then
		editor:removesel()
	end
end

function editor:mousereleased(x,y,button)
	if button == 'l' then
		if self.entsel == "platform" or self.entsel == "platform_x" or self.entsel == "platform_y" then
			self:addplatform(pressedPosX,pressedPosY,releasedPosX,releasedPosY)
		end
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
		
		if self.entsel == "platform" then
			platforms:add(x,y,w,h, 0,0,0,0)
		end
		if self.entsel == "platform_x" then
			platforms:add(x,y,w,h, 1, 0, 100, 200)
		end
		if self.entsel == "platform_y" then
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
	return self:selection(pickups) or
			self:selection(enemies) or
			self:selection(crates) or
			self:selection(checkpoints) or
			self:selection(platforms)
end

function editor:selection(entity, x,y,w,h)
	-- hilights the entity when mouseover 
	love.graphics.setColor(0,255,0,200)
	for i, entity in ripairs(entity) do
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

function editor:removesel()
	return self:remove(pickups) or
			self:remove(enemies) or
			self:remove(crates) or
			self:remove(checkpoints) or
			self:remove(platforms)
end

function editor:remove(type, x,y,w,h)
	--deletes the selected entity
	
	for i, item in ripairs(type) do
		if collision:check(mousePosX,mousePosY,1,1, item.x,item.y,item.w,item.h) then
			print( item.name .. " (" .. i .. ") removed" )
			table.remove(type,i)
			return true
		end
	end
end

function editor:copy()
	--primitive copy (dimensions only for now)
	for i, platform in ripairs(platforms) do
		if collision:check(mousePosX,mousePosY,1,1, platform.x,platform.y,platform.w,platform.h) then
			self.clipboard = {
				w = platform.w,
				h = platform.h
			}
			return true
		end
	end
end

function editor:paste()
	--paste the new entity with copied paramaters
	local x = math.round(mousePosX,-1)
	local y = math.round(mousePosY,-1)
	local w = self.clipboard.w or 20
	local h = self.clipboard.h or 20
	
	if self.entsel == "platform" then
		platforms:add(x,y,w,h,0,0,0,0)
	end
	if self.entsel == "platform_x" then
		platforms:add(x,y,w,h, 1, 0, 100, 200)
	end
	if self.entsel == "platform_y" then
		platforms:add(x,y,w,h, 0, 1, 100, 200)
	end
	
	if self.entsel == "crate" then
		self:addcrate(x,y)
	end
		
	if self.entsel == "walker" then
		self:addwalker(x,y, 100, 100)
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
	fh:write("background=30,70,70,255".."\n")
	
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
			fh:write("walker="..math.round(entity.xorigin)..","..math.round(entity.yorigin)..","..entity.movespeed..","..entity.movedist.."\n")
		end
		if entity.name == "spike" then
			fh:write("spike="..math.round(entity.x)..","..math.round(entity.y).."\n")
		end
	end
	
	fh:close()
end
