--[[
 * Copyright (C) 2015 - 2018 Ricky K. Thomson
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
 
entities = {}
local path = "entities/"
print("Loading Entities...")


local files = love.filesystem.getDirectoryItems(path)

-- load all files in entities/ to allow drop-in modules
for i, file in ipairs(files) do
	local info = love.filesystem.getInfo(path .. file)
	if info.type == "file" and file ~= "init.lua" then
		local m = file:match("(.+)%.lua")
		print(i .. ". " .. path .. m)
		require(path .. m)
	end
	
end


-- **** LOAD ENEMIES **** 
local enemypath = "entities/enemies/"
local enemyfiles = love.filesystem.getDirectoryItems(enemypath)

-- Load all files in "entities/enemies/" to allow drop-in modules
for i, file in ipairs(enemyfiles) do
	local enemyinfo = love.filesystem.getInfo(enemypath .. file)
	if enemyinfo.type == "file" and file ~= "init.lua" then
		local m = file:match("(.+)%.lua")
		print(i .. ". " .. enemypath .. m)
		require(enemypath .. m)
	end
end



--[[
	TODO, read functions from each module, merge into entities tables...
	
	editor()
	draw()
	update()

	function entities:update(dt)
		for _, e in ipairs(entities) do
			entities.update()
		end
	end
	
	//etc......
--]]



return entities
