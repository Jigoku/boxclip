--[[
 * Copyright (C) 2015 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 --]]
 
mapio = {}
mapio.path = love.filesystem.getSaveDirectory( )


--create maps folder if it doesn't exist
if not love.filesystem.exists( mapio.path .. "/maps/" ) then
	love.filesystem.createDirectory( "maps" )
end

--create screenshots folder if it doesn't exist
if not love.filesystem.exists( mapio.path .. "/screenshots/" ) then
	love.filesystem.createDirectory( "screenshots" )
end


function mapio:savemap(map)
	local filename = "maps/"..map
	local fh = love.filesystem.newFile(filename)
	
	if not fh:open("w") then
		local errortitle = "Failed to save map"
		local errormessage = "Unable to save the map '"..filename.."'\n"..
		love.window.showMessageBox(errortitle, errormessage, "error")
	end
	
	fh:write("world.mapmusic = ".. world.mapmusic .."\n")
	fh:write("world.mapambient = "..world.mapambient.."\n")
	fh:write("world.maptitle = \"".. (world.maptitle  or "unnamed map") .."\"\n")
	fh:write("world.nextmap = \"".. (world.nextmap or "title") .."\"\n")

	fh:write("world:settheme(\""..world.theme.."\")\n")
	
	for i, entity in ipairs(platforms) do
		fh:write("platforms:add("..math.round(entity.xorigin)..","..math.round(entity.yorigin)..","..entity.w..","..entity.h..","..entity.clip..","..entity.movex..","..entity.movey..","..entity.movespeed..","..entity.movedist..","..entity.swing..","..math.round(entity.angle,2)..","..entity.texture..")\n")
	end
	
	for i, entity in ipairs(pickups) do
		fh:write("pickups:add("..math.round(entity.x)..","..math.round(entity.y)..",\""..entity.name.."\")\n")
	end
	for i, entity in ipairs(crates) do
		fh:write("crates:add("..math.round(entity.x)..","..math.round(entity.y)..",\""..entity.item.."\")\n")
	end
	for i, entity in ipairs(checkpoints) do
		fh:write("checkpoints:add("..math.round(entity.x)..","..math.round(entity.y)..")\n")
	end
	for i, entity in ipairs(enemies) do
		fh:write("enemies:add("..math.round(entity.xorigin)..","..math.round(entity.yorigin)..","..entity.movespeed..","..entity.movedist ..","..entity.dir..",\""..entity.name.."\")\n")
	end
	for i, entity in ipairs(props) do
		fh:write("props:add("..math.round(entity.x)..","..math.round(entity.y)..",\""..entity.name.."\")\n")
	end
	for i, entity in ipairs(springs) do
		fh:write("springs:add("..math.round(entity.x)..","..math.round(entity.y)..","..entity.dir.. ",\""..entity.name.."\")\n")
	end
	for i, entity in ipairs(portals) do
		fh:write("portals:add("..math.round(entity.x)..","..math.round(entity.y)..",\""..entity.name.."\")\n")
	end
	for i, entity in ipairs(decals) do
		fh:write("decals:add("..math.round(entity.x)..","..math.round(entity.y)..","..entity.w..","..entity.h..",\""..entity.name.."\")\n")
	end
	for i, entity in ipairs(bumpers) do
		fh:write("bumpers:add("..math.round(entity.x)..","..math.round(entity.y)..")\n")
	end
	for i, entity in ipairs(materials) do
		fh:write("materials:add("..math.round(entity.x)..","..math.round(entity.y)..","..entity.w..","..entity.h..",\""..entity.name.."\")\n")
	end
	for i, entity in ipairs(traps) do
		fh:write("traps:add("..math.round(entity.x)..","..math.round(entity.y)..",\""..entity.name.."\")\n")
	end
	
	if fh:close() then
		console:print("saved map: " ..self.path.."/"..filename)
	end
end



function mapio:loadmap(mapname)
	--defaults in case not specified in map file
	world:settheme("default")
	world.mapmusic = 0
	world.mapambient = 0
	world.maptitle = "unnamed map"
	world.nextmap = "title"
	
	if love.filesystem.load("maps/".. mapname  )( ) then 
		console:print("failed to load map:  " .. mapname)
	else
		console:print("load map: " .. mapname)
	
	end
	
				
	for _, portal in ipairs(portals) do
		--set starting spawn
		if portal.name == "spawn" then
			player.spawnX = portal.x
			player.spawnY = portal.y
		end
	end	
	

end


function mapio:getmaps()
	-- custom maps override built ins with the same name
	return tableconcat(						
		love.filesystem.getDirectoryItems( self.path .. "maps" ),--custom maps
		love.filesystem.getDirectoryItems( "/maps" )--built in maps
	)
end
