editor = {}

function editor:mousepressed(x,y,button)
	pressedPosX = util:round(camera.x+x*camera.scaleX)
	pressedPosY = util:round(camera.y+y*camera.scaleY)
		
	if button == 'l' then
		--add gui element for switching TYPES
		-- so we place one thing at a time
		self:addcrate(pressedPosX,pressedPosY)
		self:addwalker(pressedPosX,pressedPosY, 100, 100)
		
		----------
	end
	if button == 'r' then
		for i, structure in ipairs(structures) do
			if collision:check(pressedPosX,pressedPosY,1,1, structure.x,structure.y,structure.w,structure.h) then
				print( structure.name .. " (" .. i .. ") removed" )
				table.remove(structures,i)
			end
		end
		for i, pickup in ipairs(pickups) do
			if collision:check(pressedPosX,pressedPosY,1,1, pickup.x-pickup.gfx:getWidth()/2, pickup.y-pickup.gfx:getHeight()/2, pickup.gfx:getHeight(),pickup.gfx:getWidth()) then
				print( pickup.name .. " (" .. i .. ") removed" )
				table.remove(pickups,i)
			end
		end
		for i, enemy in ipairs(enemies) do
			if collision:check(pressedPosX,pressedPosY,1,1, enemy.x,enemy.y,enemy.w,enemy.h) then
				print( enemy.name .. " (" .. i .. ") removed" )
				table.remove(enemies,i)
			end
		end
	end
end

function editor:mousereleased(x,y,button)
	releasedPosX = util:round(camera.x+x*camera.scaleX)
	releasedPosY = util:round(camera.y+y*camera.scaleY)
	

	if button == 'l' then
		self:addplatform(x,y,w,h)
	end
end


function editor:addcrate(x,y)
	structures:crate(x,y,"gem")
	print( "crate added @  X:"..x.." Y: "..y)
end

function editor:addwalker(x,y,movespeed,movedist)
	enemies:walker(x,y,movespeed,movedist)
	print( "walker added @  X:"..x.." Y: "..y)
end

function editor:addplatform(x,y,w,h)
	-- draw platform structure
	--min size
	if releasedPosX-pressedPosX < 20 then releasedPosX = releasedPosX +20	end
	if releasedPosY-pressedPosY < 20 then releasedPosY = releasedPosY +20 end
	-- draw grid for drag/area of platform (drag down and right, otherwise it's bugged!)
	structures:platform(pressedPosX,pressedPosY, (releasedPosX-pressedPosX),(releasedPosY-pressedPosY), 0, 0, 100, 200)
	print( "platform added @  X:"..pressedPosX.." Y: "..pressedPosY .. "(w:" .. (releasedPosX-pressedPosX) .. " h:".. (releasedPosY-pressedPosY).. ")")
end
