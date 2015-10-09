--[[
	TODO
		remove duplicated loops (or put all object types into a single table referenced by entities.name?


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
mousePosX = 0
mousePosY = 0

editor.entsel = "nil"
editor.clipboard = {}


function editor:keypressed(key)
	if love.keyboard.isDown("1") then self.entsel = "platform" end
	if love.keyboard.isDown("2") then self.entsel = "platform_y" end
	if love.keyboard.isDown("3") then self.entsel = "platform_x" end
	if love.keyboard.isDown("4") then self.entsel = "crate" end
	if love.keyboard.isDown("5") then self.entsel = "walker" end
	if love.keyboard.isDown("delete") then self:removesel() end
	if love.keyboard.isDown("c") then self:copy() end
	if love.keyboard.isDown("v") then self:paste() end
	
	for i, structure in ipairs(structures) do
		if collision:check(mousePosX,mousePosY,1,1, structure.x,structure.y,structure.w,structure.h) then
			if love.keyboard.isDown("kp8") then structure.y = util:round(structure.y - 10,-1) end -- up
			if love.keyboard.isDown("kp2") then structure.y = util:round(structure.y + 10,-1) end -- down
			if love.keyboard.isDown("kp4") then structure.x = util:round(structure.x - 10,-1) end -- left
			if love.keyboard.isDown("kp6") then structure.x = util:round(structure.x + 10,-1) end -- right

			return true
		end
	end
end

function editor:mousepressed(x,y,button)
		
	if button == 'l' then

	
		if self.entsel == "crate" then
			self:addcrate(pressedPosX,pressedPosY)
		end
		
		if self.entsel == "walker" then
			self:addwalker(pressedPosX,pressedPosY, 100, 100)
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


function editor:addcrate(x,y)
	structures:crate(util:round(x,-1),util:round(y, -1),"gem")
	print( "crate added @  X:"..util:round(x,-1).." Y: "..util:round(y,-1))
end

function editor:addwalker(x,y,movespeed,movedist)
	enemies:walker(util:round(x,-1),util:round(y, -1),movespeed,movedist)
	print( "walker added @  X:"..util:round(x,-1).." Y: "..util:round(y,-1))
end

function editor:addplatform(x1,y1,x2,y2)
	-- add platform structure

	if not (x2 < x1 or y2 < y1) then
		--min sizes
		if x2-x1 < 20  then x2 = x1 +20 end
		if y2-y1 < 20  then y2 = y1 +20 end

		local x = util:round(x1,-1)
		local y = util:round(y1,-1)
		local w = util:round((x2-x1)-1)
		local h = util:round((y2-y1),-1)
		
		if self.entsel == "platform" then
			structures:platform(x,y,w,h, 0,0,0,0)
		end
		if self.entsel == "platform_x" then
			structures:platform(x,y,w,h, 1, 0, 100, 200)
		end
		if self.entsel == "platform_y" then
			structures:platform(x,y,w,h, 0, 1, 100, 200)
		end
		util:dprint("platform added @  X:"..x.." Y: "..y .. "(w:" .. w .. " h:".. h.. ")")
	end
end


function editor:hud()
	--add hud / ent selection menus here
end


function editor:draw()
	editor:hud()
	
	editor:scansel(pickups)

end


function editor:scansel()
	self:selection(pickups)
	self:selection(enemies)
	self:selection(structures)
end

function editor:selection(type, x,y,w,h)
	-- hilights the entity when mouseover
	for i, item in ipairs(type) do
		if collision:check(mousePosX,mousePosY,1,1,item.x,item.y,item.w,item.h) then
			love.graphics.setColor(0,255,0,255)
			love.graphics.rectangle("line", item.x,item.y,item.w,item.h)
			return true
		end
	end
end

function editor:removesel()
	self:remove(pickups)
	self:remove(enemies)
	self:remove(structures)
end

function editor:remove(type, x,y,w,h)
	for i, item in ipairs(type) do
		if collision:check(mousePosX,mousePosY,1,1, item.x,item.y,item.w,item.h) then
			print( item.name .. " (" .. i .. ") removed" )
			table.remove(type,i)
			return true
		end
	end
end

function editor:copy()
	for i, structure in ipairs(structures) do
		if collision:check(mousePosX,mousePosY,1,1, structure.x,structure.y,structure.w,structure.h) then
			self.clipboard = {
				w = structure.w,
				h = structure.h
			}
			return true
		end
	end
end

function editor:paste()
	local x = util:round(mousePosX,-1)
	local y = util:round(mousePosY,-1)
	local w = self.clipboard.w or 20
	local h = self.clipboard.h or 20
	
	if self.entsel == "platform" then
		structures:platform(x,y,w,h,0,0,0,0)
	end
	if self.entsel == "platform_x" then
		structures:platform(x,y,w,h, 1, 0, 100, 200)
	end
	if self.entsel == "platform_y" then
		structures:platform(x,y,w,h, 0, 1, 100, 200)
	end
	
	if self.entsel == "crate" then
		self:addcrate(x,y)
	end
		
	if self.entsel == "walker" then
		self:addwalker(x,y, 100, 100)
	end
end

function editor:run(dt)


end
