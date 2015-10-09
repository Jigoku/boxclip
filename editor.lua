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
	pressedPosX = util:round(camera.x+x*camera.scaleX)
	pressedPosY = util:round(camera.y+y*camera.scaleY)
		
	if button == 'l' then
		if editor.entsel == "crate" then
			self:addcrate(pressedPosX,pressedPosY)
		end
		
		if editor.entsel == "walker" then
			self:addwalker(pressedPosX,pressedPosY, 100, 100)
		end
		
		--if platform selected, draw drag area outline box
		

	end
	if button == 'r' then
		for i, pickup in ipairs(pickups) do
			if collision:check(pressedPosX,pressedPosY,1,1, pickup.x-pickup.gfx:getWidth()/2, pickup.y-pickup.gfx:getHeight()/2, pickup.gfx:getHeight(),pickup.gfx:getWidth()) then
				print( pickup.name .. " (" .. i .. ") removed" )
				table.remove(pickups,i)
				return true
			end
		end
		for i, enemy in ipairs(enemies) do
			if collision:check(pressedPosX,pressedPosY,1,1, enemy.x,enemy.y,enemy.w,enemy.h) then
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
end

function editor:mousereleased(x,y,button)
	releasedPosX = util:round(camera.x+x*camera.scaleX)
	releasedPosY = util:round(camera.y+y*camera.scaleY)
	

	if button == 'l' then
		if editor.entsel == "platform" or editor.entsel == "platform_x" or editor.entsel == "platform_y" then
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
	-- draw platform structure
	--min size
	if not (x2 < x1 or y2 < y1) then
		if x2-x1 < 10  then x2 = x1 +10 end
		if y2-y1 < 10  then y2 = y1 +10 end
		-- draw grid for drag/area of platform (drag down and right, otherwise it's bugged!)
		if editor.entsel == "platform" then
			structures:platform(util:round(x1,-1),util:round(y1,-1), util:round((x2-x1)-1),util:round((y2-y1),-1), 0,0,0,0)
		end
		if editor.entsel == "platform_x" then
			structures:platform(util:round(x1,-1),util:round(y1,-1), util:round((x2-x1)-1),util:round((y2-y1),-1), 1, 0, 100, 200)
		end
		if editor.entsel == "platform_y" then
			structures:platform(util:round(x1,-1),util:round(y1,-1), util:round((x2-x1)-1),util:round((y2-y1),-1), 0, 1, 100, 200)
		end
		print("platform added @  X:"..util:round(x1,-1).." Y: "..util:round(y1,-1) .. "(w:" .. util:round((x2-x1),-1) .. " h:".. util:round((y2-y1),-1).. ")")
	end
end


function editor:drawhud()
	
end
