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
 
pickups = {}

pickups.magnet_power = 300

pickups.textures = {
	["gem"] = love.graphics.newImage("data/images/pickups/gem.png"),
	["life"] = love.graphics.newImage( "data/images/pickups/heart.png"),
	["magnet"] = love.graphics.newImage( "data/images/pickups/magnet.png"),
	["shield"] = love.graphics.newImage( "data/images/pickups/shield.png"),
	["star"] = love.graphics.newImage( "data/images/pickups/star.png"),
}

function pickups:add(x,y,item,dropped)
	local score
	if item == "gem" then
		score = "200"
	elseif item == "life" then
		score = "1000"
	elseif item == "magnet" then
		score = "1000"
	elseif item == "shield" then
		score = "1000"
	elseif item == "star" then
		score = "2500"
	end
	
	table.insert(pickups, {
		x =x or 0,
		y =y or 0,
		w = self.textures[item]:getWidth(),
		h = self.textures[item]:getHeight(),
		name = item,
		gfx = self.textures[item],
		collected = false,
		dropped = dropped or false,
		attract = false,
		bounce = true,
		red = math.random(150,255),
		green = math.random(150,255),
		blue = math.random(0,255),
		mass = 800,
		xvel = 0,
		yvel = 0,
		score = score,
	})	

	print( item .. " added @  X:"..x.." Y: "..y)
end


function pickups:draw()
	local count = 0
	local i, pickup
	for i, pickup in ipairs(pickups) do
		if not pickup.collected and world:inview(pickup) then
			count = count + 1
			
			if pickup.name == "gem" then
				love.graphics.setColor(255,255,50,255)	
				love.graphics.draw(
					pickup.gfx, pickup.x, 
					pickup.y, 0, 1, 1
				)
			end
			
			if pickup.name == "life" then
				love.graphics.setColor(255,0,0, 255)	
				love.graphics.draw(
					pickup.gfx, pickup.x, 
					pickup.y, 0, 1, 1
				)
			end

			if pickup.name == "magnet" then
				love.graphics.setColor(255,255,255, 255)	
				love.graphics.draw(
					pickup.gfx, pickup.x, 
					pickup.y, 0, 1, 1
				)
			end
			
			if pickup.name == "shield" then
				love.graphics.setColor(255,255,255, 255)	
				love.graphics.draw(
					pickup.gfx, pickup.x, 
					pickup.y, 0, 1, 1
				)
			end
			
			if pickup.name == "star" then
				love.graphics.setColor(255,255,255, 255)	
				love.graphics.draw(
					pickup.gfx, pickup.x, 
					pickup.y, 0, 1, 1
				)
			end

			if editing or debug then
				pickups:drawdebug(pickup, i)
			end
		end
	end
	world.pickups = count
end



function pickups:drawdebug(pickup, i)
	love.graphics.setColor(100,255,100,100)
	love.graphics.rectangle(
		"line", 
		pickup.x, 
		pickup.y, 
		pickup.gfx:getWidth(), 
		pickup.gfx:getHeight()
	)
	editor:drawid(pickup, i)
	editor:drawcoordinates(pickup)
end

function pickups:destroy(pickups, i)
	-- fade/collect animation can be added here
	table.remove(pickups, i)
end


