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

util = {}
console = false

cbuff = {
	--make this configurable (maxconlines etc, with scrollback buffer)
	l1 = "",
	l2 = "",
	l3 = "",
	l4 = "",
	l5 = "",
	l6 = "",
	l7 = ""
}


-- this function redefine love.graphics.newImage( ), so all images are
-- not put through linear filter, which makes things more crisp on the
--  pixel level (less blur)... should this be used?
--[[

local _newImage = love.graphics.newImage
function love.graphics.newImage(...)
	local img = _newImage(...)
	img:setFilter('nearest', 'nearest')
	return img
end
--]]


function math.round(num, idp)
	-- round integer to decimal places
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function ripairs(t)
	--same as ipairs, but itterate from last to first
	local function ripairs_it(t,i)
		i=i-1
		local v=t[i]
		if v==nil then return v end
		return i,v
	end
	return ripairs_it, t, #t+1
end


function split(s, delimiter)
	--split string into a table
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end




function util:drawConsole()
	if console then
		--console info
		love.graphics.setColor(0,0,0,100)
		love.graphics.rectangle("fill", 1, 1, WIDTH-2, 160)	
		love.graphics.setColor(100,100,100,100)
		love.graphics.rectangle("line", 1, 1, WIDTH-2, 160)
		
		--sysinfo
		love.graphics.setColor(100,255,100,255)
		love.graphics.print(
			"FPS: " .. love.timer.getFPS() .. 
			" | Memory (kB): " ..  gcinfo() ..
			string.format(" | vram: %.2fMB", love.graphics.getStats().texturememory / 1024 / 1024), 
			5,5
		)
		
		if not (mode == "title") then
		--score etc
		love.graphics.setColor(255,100,40,255)
		love.graphics.print(
			"[lives: " .. player.lives .. "]"..
			"[score: " .. player.score .. "]"..
			"[time: " .. world:formatTime(world.time) .. "]"..
			"[alive: "..(player.alive and 1 or 0).."]", 
			250,5
		)
		
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(
			"X: " .. math.round(player.x) .. 
			" | Y: " .. math.round(player.y) .. 
			" | dir: " .. player.dir .. 
			" | xvel: " .. math.round(player.xvel) .. 
			" | yvel: " .. math.round(player.yvel) .. 
			" | jumping: " .. (player.jumping and 1 or 0) ..
			" | camera scale: " .. camera.scaleX, 
			5, 20
		)
		

		love.graphics.setColor(255,100,255,255)
		love.graphics.print(
			"pickups: " .. world:count(pickups) .. "(".. world.pickups .. ")" ..
			" | enemies: " .. world:count(enemies) .. "(".. world.enemies .. ")" ..
			" | platforms: " .. world:count(platforms) .. "(".. world.platforms .. ")" ..
			" | props: " .. world:count(props) .. "("..world.props .. ")" ..
			" | springs: " .. world:count(springs) .. "("..world.springs .. ")" ..
			" | portals: " .. world:count(portals) .. "("..world.portals .. ")" ..
			" | crates: " .. world:count(crates) .. "("..world.crates .. ")" ..
			" | checkpoints: " .. world:count(checkpoints) .. "("..world.checkpoints .. ")" ..
			" | t: " ..world:totalents() .. "(" .. world:totalentsdrawn() .. ")" ..
			" | ccpf: " .. world.collision,
			 5, 35
		)
		end
		
		love.graphics.setColor(155,155,155,255)
		love.graphics.print(cbuff.l1,5,50)
		love.graphics.print(cbuff.l2,5,65)
		love.graphics.print(cbuff.l3,5,80)
		love.graphics.print(cbuff.l4,5,95)
		love.graphics.print(cbuff.l5,5,110)
		love.graphics.print(cbuff.l6,5,125)
		love.graphics.print(cbuff.l7,5,140)

	end
end



function util:drawid(entity,i)
	if editor.showid then
		love.graphics.setColor(255,255,0,100)       
		love.graphics.print(entity.name .. "(" .. i .. ")", entity.x-20, entity.y-40, 0)
	end
end

function util:drawCoordinates(object)
	if editor.showpos then
		-- co-ordinates
		love.graphics.setColor(255,255,255,100)
		love.graphics.print("X:".. object.x ..",Y:" .. object.y , object.x-20,object.y-20,0)  
	end
end

function util:dprint(event)
	local elapsed =  world:formatTime(os.difftime(os.time()-runtime))
	local line = elapsed .. " | " ..  event
	cbuff.l1 = cbuff.l2
	cbuff.l2 = cbuff.l3
	cbuff.l3 = cbuff.l4
	cbuff.l4 = cbuff.l5
	cbuff.l5 = cbuff.l6
	cbuff.l6 = cbuff.l7
	cbuff.l7 = line
	print (line)
end


function util:togglefullscreen()
	paused = true
	local fs, fstype = love.window.getFullscreen()
	
	if fs then
		--camera.scaleX = 1
		--camera.scaleY = 1
		local success = love.window.setFullscreen( false )

	else
		--camera.scaleX = 0.75
		--camera.scaleY = 0.75
		local success = love.window.setFullscreen( true, "desktop" )

	end
			
	if not success then
		util:dprint("Failed to toggle fullscreen mode!")
	end
	paused = false
end
