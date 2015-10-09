editor = {}

editor.entsel = "nil"
function editor:keypressed(key)
	if love.keyboard.isDown("1") then editor.entsel = "platform" end
	if love.keyboard.isDown("2") then editor.entsel = "platform_y" end
	if love.keyboard.isDown("3") then editor.entsel = "platform_x" end
	if love.keyboard.isDown("4") then editor.entsel = "crate" end
	if love.keyboard.isDown("5") then editor.entsel = "walker" end

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
		self:remove()
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
	editor:mouseover()
end

function editor:mouseover()
	love.graphics.setColor(0,255,0,255)
	for i, pickup in ipairs(pickups) do
		if collision:check(mousePosX,mousePosY,1,1, pickup.x-pickup.gfx:getWidth()/2, pickup.y-pickup.gfx:getHeight()/2, pickup.gfx:getHeight(),pickup.gfx:getWidth()) then
			love.graphics.rectangle("line", pickup.x-pickup.gfx:getWidth()/2, pickup.y-pickup.gfx:getHeight()/2, pickup.gfx:getHeight(),pickup.gfx:getWidth())
			return true
		end
	end
	for i, enemy in ipairs(enemies) do
		if collision:check(mousePosX,mousePosY,1,1, enemy.x, enemy.y, enemy.w,enemy.h) then
			love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)
			return true
		end
	end
	for i, structure in ipairs(structures) do
		if collision:check(mousePosX,mousePosY,1,1,structure.x,structure.y,structure.w,structure.h) then
			love.graphics.rectangle("line", structure.x, structure.y, structure.w, structure.h)
			return true
		end
	end
end


function editor:remove()
	for i, pickup in ipairs(pickups) do
		if collision:check(pressedPosX,pressedPosY,1,1, pickup.x-pickup.gfx:getWidth()/2, pickup.y-pickup.gfx:getHeight()/2, pickup.gfx:getHeight(),pickup.gfx:getWidth()) then
			print( pickup.name .. " (" .. i .. ") removed" )
			table.remove(pickups,i)
			return true
		end
	end
	for i, enemy in ipairs(enemies) do
		if collision:check(pressedPosX,pressedPosY,1,1, enemy.x, enemy.y, enemy.w,enemy.h) then
			print( enemy.name .. " (" .. i .. ") removed" )
			table.remove(enemies,i)
			return true
		end
	end
	for i, structure in ipairs(structures) do
		if collision:check(pressedPosX,pressedPosY,1,1, structure.x,structure.y,structure.w,structure.h) then
			print( structure.name .. " (" .. i .. ") removed" )
			table.remove(structures,i)
			return true
		end
	end
end


function editor:run(dt)
	for i, structure in ipairs(structures) do
		if collision:check(mousePosX,mousePosY,1,1, structure.x,structure.y,structure.w,structure.h) then
			if love.keyboard.isDown("kp8") then structure.y = structure.y - 100 *dt end	-- up
			if love.keyboard.isDown("kp2") then structure.y = structure.y + 100 *dt end -- down
			if love.keyboard.isDown("kp4") then structure.x = structure.x - 100 *dt end	-- left
			if love.keyboard.isDown("kp6") then structure.x = structure.x + 100 *dt end	-- right
			return true
		end
	end

end
