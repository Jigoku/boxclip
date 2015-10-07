editor = {}

function editor:mousepressed(x,y,button)
	editorPosX = util:round(camera.x+x*camera.scaleX)
	editorPosY = util:round(camera.y+y*camera.scaleY)
		
	if button == 'l' then
		--SPAWN A CRATE
		structures:crate(util:round(camera.x+x*camera.scaleX),util:round(camera.y+y*camera.scaleY),"gem")
		--print( "crate added @  X:"..util:round(camera.x+x).." Y: "..util:round(camera.y+y))
		
		--SPAWN A WALKER
		--enemies:walker(editorPosX,editorPosY, 100, 100)
		
		--SPAWN A PLATFORM
		
		
	end
	if button == 'r' then
		for i, structure in ipairs(structures) do
			if collision:check(editorPosX,editorPosY,1,1, structure.x,structure.y,structure.w,structure.h) then
				print( structure.name .. " (" .. i .. ") removed" )
				table.remove(structures,i)
			end
		end
		for i, pickup in ipairs(pickups) do
			if collision:check(editorPosX,editorPosY,1,1, pickup.x-pickup.gfx:getWidth()/2, pickup.y-pickup.gfx:getHeight()/2, pickup.gfx:getHeight(),pickup.gfx:getWidth()) then
				print( pickup.name .. " (" .. i .. ") removed" )
				table.remove(pickups,i)
			end
		end
		for i, enemy in ipairs(enemies) do
			if collision:check(editorPosX,editorPosY,1,1, enemy.x,enemy.y,enemy.w,enemy.h) then
				print( enemy.name .. " (" .. i .. ") removed" )
				table.remove(enemies,i)
			end
		end
	end
end
