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
		local errortitle = "Error"
		local errormessage = "Unable to save the map '"..filename.."'\n"..
		love.window.showMessageBox(errortitle, errormessage, "error")
	end
	
	fh:write("world.gravity = ".. world.gravity .."\n")
	fh:write("world.mapmusic = ".. world.mapmusic .."\n")
	fh:write("world.mapambient = "..world.mapambient.."\n")
	fh:write("world.maptitle = \"".. (world.maptitle  or "unnamed map") .."\"\n")
	fh:write("world.nextmap = \"".. (world.nextmap or "title") .."\"\n")
	fh:write("world.deadzone = ".. world.deadzone .."\n")
	fh:write("world:settheme(\""..world.theme.."\")\n")
	
	

	for _, e in ipairs(world.entities.platform) do
		fh:write("platforms:add("..math.round(e.xorigin)..","..math.round(e.yorigin)..","..e.w..","..e.h..","..tostring(e.clip)..","..tostring(e.movex)..","..tostring(e.movey)..","..e.movespeed..","..e.movedist..","..tostring(e.swing)..","..e.angleorigin..","..e.texture..")\n")
	end
	for _, e in ipairs(world.entities.pickup) do
		fh:write("pickups:add("..math.round(e.x)..","..math.round(e.y)..",\""..e.type.."\")\n")
	end
	for _, e in ipairs(world.entities.crate) do
		fh:write("crates:add("..math.round(e.x)..","..math.round(e.y)..",\""..e.type.."\")\n")
	end
	for _, e in ipairs(world.entities.checkpoint) do
		fh:write("checkpoints:add("..math.round(e.x)..","..math.round(e.y)..")\n")
	end
	for _, e in ipairs(world.entities.enemy) do
		fh:write("enemies:add("..math.round(e.xorigin)..","..math.round(e.yorigin)..","..e.movespeed..","..e.movedist ..","..e.dir..",\""..e.type.."\")\n")
	end
	for _, e in ipairs(world.entities.prop) do
		fh:write("props:add("..math.round(e.x)..","..math.round(e.y)..","..e.dir..","..tostring(e.flip)..",\""..e.type.."\")\n")
	end
	for _, e in ipairs(world.entities.spring) do
		fh:write("springs:add("..math.round(e.x)..","..math.round(e.y)..","..e.dir.. ",\""..e.type.."\")\n")
	end
	for _, e in ipairs(world.entities.portal) do
		fh:write("portals:add("..math.round(e.x)..","..math.round(e.y)..",\""..e.type.."\")\n")
	end
	for _, e in ipairs(world.entities.decal) do
		fh:write("decals:add("..math.round(e.x)..","..math.round(e.y)..","..e.w..","..e.h..",\""..e.type.."\")\n")
	end
	for _, e in ipairs(world.entities.bumper) do
		fh:write("bumpers:add("..math.round(e.x)..","..math.round(e.y)..")\n")
	end
	for _, e in ipairs(world.entities.material) do
		fh:write("materials:add("..math.round(e.x)..","..math.round(e.y)..","..e.w..","..e.h..",\""..e.type.."\")\n")
	end
	for _, e in ipairs(world.entities.trap) do
		fh:write("traps:add("..math.round(e.x)..","..math.round(e.y)..",\""..e.type.."\")\n")
	end
	for _, e in ipairs(world.entities.tip) do
		fh:write("tips:add("..math.round(e.xorigin)..","..math.round(e.yorigin)..",\""..e.text.."\")\n")
	end
	
	if fh:close() then
		console:print("saved map: " ..self.path.."/"..filename)
	end
end



function mapio:loadmap(mapname)
	if love.filesystem.load("maps/".. mapname  )( ) then 
		console:print("failed to load map:  " .. mapname)
	else
		console:print("load map: " .. mapname)
	end
end


function mapio:getmaps()
	-- custom maps override built ins with the same name
	return tableconcat(						
		love.filesystem.getDirectoryItems( self.path .. "maps" ),--custom maps
		love.filesystem.getDirectoryItems( "/maps" )--built in maps
	)
end
