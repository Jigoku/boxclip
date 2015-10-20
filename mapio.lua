mapio = {}

function mapio:savemap(map)
	local fh = io.open(map, "w+")
	fh:write("mapmusic=5".."\n")
	fh:write("theme="..world.theme.."\n")
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
		if entity.name == "floater" then
			fh:write("floater="..math.round(entity.xorigin)..","..math.round(entity.y)..","..entity.movespeed..","..entity.movedist.."\n")
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



function mapio:loadmap(mapname)
	--cleanup the map
	repeat world:remove(enemies) until world:count(enemies) == 0
	repeat world:remove(pickups) until world:count(pickups) == 0
	repeat world:remove(crates) until world:count(crates) == 0
	repeat world:remove(scenery) until world:count(scenery) == 0
	repeat world:remove(platforms) until world:count(platforms) == 0
	repeat world:remove(checkpoints) until world:count(checkpoints) == 0
	repeat world:remove(portals) until world:count(portals) == 0

	--load the mapfile
	local mapdata = love.filesystem.newFileData(mapname)
	local lines = split(mapdata:getString(), "\n")
	
	for _, line in pairs(lines) do
		-- parse mapmusic
		if string.find(line, "^mapmusic=(.+)") then
			world.mapmusic = string.match(line, "^mapmusic=(%d+)")
			sound:playbgm(world.mapmusic)
		end
		-- parse theme
		if string.find(line, "^theme=(.+)") then
			world.theme = string.match(line, "^theme=(.+)")
			world:settheme(world.theme)
			love.graphics.setBackgroundColor(background_r,background_g,background_b,255)
		
		end
		--parse platforms
		if string.find(line, "^platform=(.+)") then
		
			local x,y,w,h,movex,movey,movespeed,movedist = string.match(
				line, "^platform=(%-?%d+),(%-?%d+),(%-?%d+),(%-?%d+),(%-?%d+),(%-?%d+),(%-?%d+),(%-?%d+)"
			)
			platforms:add(tonumber(x),tonumber(y),tonumber(w),tonumber(h),tonumber(movex),tonumber(movey),tonumber(movespeed),tonumber(movedist))
		end
		-- parse pickups
		if string.find(line, "^pickup=(.+)") then
			local x,y,item = string.match(
				line, "^pickup=(%-?%d+),(%-?%d+),(.+)"
			)
			pickups:add(tonumber(x),tonumber(y),item)
		end
		--parse crates
		if string.find(line, "^crate=(.+)") then
			local x,y,item = string.match(
				line, "^crate=(%-?%d+),(%-?%d+),(.+)"
			)
			crates:add(tonumber(x),tonumber(y),item)
		end
		--parse checkpoints
		if string.find(line, "^checkpoint=(.+)") then
			local x,y = string.match(
				line, "^checkpoint=(%-?%d+),(%-?%d+)"
			)
			checkpoints:add(tonumber(x),tonumber(y))
		end
		--parse enemy(walker)
		if string.find(line, "^walker=(.+)") then
			local x,y,movespeed,movedist = string.match(
				line, "^walker=(%-?%d+),(%-?%d+),(%-?%d+),(%-?%d+)"
			)
			enemies:walker(tonumber(x),tonumber(y),tonumber(movespeed),tonumber(movedist))
			
		end
		--parse enemy(floater)
		if string.find(line, "^floater=(.+)") then
			local x,y,movespeed,movedist = string.match(
				line, "^floater=(%-?%d+),(%-?%d+),(%-?%d+),(%-?%d+)"
			)
			enemies:floater(tonumber(x),tonumber(y),tonumber(movespeed),tonumber(movedist))
			
		end
		
		--parse enemy(spike)
		if string.find(line, "^spike=(.+)") then
			local x,y,dir = string.match(
				line, "^spike=(%-?%d+),(%-?%d+),(%-?%d+)"
			)
			enemies:spike(tonumber(x),tonumber(y),tonumber(dir))
			
		end
		--parse enemy(icicle)
		if string.find(line, "^icicle=(.+)") then
			local x,y,dir = string.match(
				line, "^icicle=(%-?%d+),(%-?%d+),(%-?%d+)"
			)
			enemies:icicle(tonumber(x),tonumber(y),tonumber(dir))
			
		end
		--parse scenery
		if string.find(line, "^scenery=(.+)") then
			local x,y,type = string.match(
				line, "^scenery=(%-?%d+),(%-?%d+),(.+)"
			)
			scenery:add(tonumber(x),tonumber(y),type)
			
		end
		--parse portals
		if string.find(line, "^portal=(.+)") then
			local x,y,type = string.match(
				line, "^portal=(%-?%d+),(%-?%d+),(.+)"
			)
			portals:add(tonumber(x),tonumber(y),type)
			
		end
		for _, portal in ipairs(portals) do
			--set starting spawn
			if portal.name == "spawn" then
				player.spawnX = portal.x
				player.spawnY = portal.y
			end
		end	
		

	end
   
end
