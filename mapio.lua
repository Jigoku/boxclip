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

function mapio:savemap(map)

	local fh = io.open(map ..".lua", "w+")
	fh:write("world.mapmusic = ".. world.mapmusic .."\n")
	fh:write("world.mapambient = "..world.mapambient.."\n")
	

	fh:write("world:settheme(\""..world.theme.."\")\n")
	
	for i, entity in ipairs(platforms) do
		fh:write("platforms:add("..math.round(entity.xorigin)..","..math.round(entity.yorigin)..","..entity.w..","..entity.h..","..entity.clip..","..entity.movex..","..entity.movey..","..entity.movespeed..","..entity.movedist..","..entity.swing..","..math.round(entity.angle,2)..")\n")
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
		if entity.name == "walker" then
			fh:write("enemies:walker("..math.round(entity.xorigin)..","..math.round(entity.y)..","..entity.movespeed..","..entity.movedist..")\n")
		end
		if entity.name == "floater" then
			fh:write("enemies:floater("..math.round(entity.xorigin)..","..math.round(entity.y)..","..entity.movespeed..","..entity.movedist..")\n")
		end
		if entity.name == "spikeball" then
			fh:write("enemies:spikeball("..math.round(entity.xorigin)..","..math.round(entity.yorigin)..")\n")
		end
		if entity.name == "spike" then
			fh:write("enemies:spike("..math.round(entity.x)..","..math.round(entity.y)..","..math.round(entity.dir)..")\n")
		end
		if entity.name == "spike_large" then
			fh:write("enemies:spike_large("..math.round(entity.x)..","..math.round(entity.y)..","..math.round(entity.dir)..")\n")
		end
		
		if entity.name == "icicle" then
			fh:write("enemies:icicle("..math.round(entity.x)..","..math.round(entity.y)..")\n")
		end
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
	fh:close()
end




function mapio:loadmap(mapname)
	--defaults in case not specified in map file
	world.theme = "sunny"
	world.mapmusic = 0
	world.mapambient = 0
	
	if love.filesystem.load( mapname ..".lua" )( ) then 
		util:dprint("failed to load map:  " .. mapname)
	else
		util:dprint("load map: " .. mapname)
	
	end
	
				
	for _, portal in ipairs(portals) do
		--set starting spawn
		if portal.name == "spawn" then
			player.spawnX = portal.x
			player.spawnY = portal.y
		end
	end	
	

end
