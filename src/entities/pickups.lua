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
 
pickups = {}

pickups.magnet_power = 200
pickups.path = "data/images/pickups/"

pickups.list = {}
for _,pickup in ipairs(love.filesystem.getDirectoryItems(pickups.path)) do
	--possibly merge this into shared function ....
	--get file name without extension
	local name = pickup:match("^(.+)%..+$")
	--store list of prop names
	table.insert(pickups.list, name)
	--insert into editor menu
	table.insert(editor.entities, {name, "pickup"})
end

--load the textures
pickups.textures = textures:load(pickups.path)


function pickups:add(x,y,type,dropped)
	for i,pickup in ipairs(pickups.list) do
		--maybe better way to do this? 
		--loop over entity.list, find matching name
		-- then only insert when a match is found
		if pickup == type then

			local score = 0
			if type == "gem" then
				score = "200"
			elseif type == "life" then
				score = "1000"
			elseif type == "magnet" then
				score = "1000"
			elseif type == "shield" then
				score = "1000"
			elseif type == "star" then
				score = "2500"
			end
	
			table.insert(world.entities.pickup, {
				x =x or 0,
				y =y or 0,
				w = self.textures[i]:getWidth(),
				h = self.textures[i]:getHeight(),
				group = "pickup",
				type = type,
				collected = false,
				dropped = dropped or false,
				attract = false,
				bounce = true,
				slot = i,
				red = love.math.random(0.75,1),
				green = love.math.random(0.75,1),
				blue = love.math.random(0.75,1),
				xvel = 0,
				yvel = 0,
				score = score,
			})	

			print( "pickup added @  X:"..x.." Y: "..y)
		end
	end
end


function pickups:update(dt)
	for i, pickup in ipairs(world.entities.pickup) do			
		if not pickup.collected then
			--pulls all gems to player when attract = true
			if pickup.attract then
				pickup.speed = pickup.speed + (pickups.magnet_power*2) *dt
				if player.alive then
					local angle = math.atan2(player.y+player.h/2 - pickup.h/2 - pickup.y, player.x+player.w/2 - pickup.w/2 - pickup.x)
					pickup.newX = pickup.x + (math.cos(angle) * pickup.speed * dt)
					pickup.newY = pickup.y + (math.sin(angle) * pickup.speed * dt)
				end
			else
				pickup.speed = 100
				physics:applyGravity(pickup, dt)
				physics:applyVelocity(pickup,dt)
				physics:traps(pickup,dt)
				physics:platforms(pickup, dt)
				physics:crates(pickup, dt)			
			end
			
			physics:update(pickup)
			
			if mode == "game" and not pickup.collected then	
				if player.hasmagnet then
					if collision:check(player.x-pickups.magnet_power,player.y-pickups.magnet_power,
						player.w+(pickups.magnet_power*2),player.h+(pickups.magnet_power*2),
						pickup.x, pickup.y,pickup.w,pickup.h) then

						if not pickup.attract then
							pickup.attract = true
						end
					end
				end
			
				if player.alive and collision:check(player.x,player.y,player.w,player.h,
					pickup.x, pickup.y,pickup.w,pickup.h) then
						popups:add(pickup.x+pickup.w/2,pickup.y+pickup.h/2,"+"..pickup.score)
						console:print(pickup.group.."("..i..") collected")	
						player:collect(pickup)
						pickup.collected = true

				end
			end	
		end
	end
end


function pickups:draw()
	local count = 0
	for i, pickup in ipairs(world.entities.pickup) do
		if not pickup.collected and world:inview(pickup) then
			count = count + 1
			
			local texture = self.textures[pickup.slot]
			
			if pickup.type == "gem" then
				love.graphics.setColor(pickup.red,pickup.green,pickup.blue,1)	
				love.graphics.draw(texture, pickup.x, pickup.y, 0, 1, 1)
			end
			
			if pickup.type == "life" then
				love.graphics.setColor(1,0,0, 1)	
				love.graphics.draw(texture, pickup.x, pickup.y, 0, 1, 1)
			end

			if pickup.type == "magnet" then
				love.graphics.setColor(1,1,1, 1)	
				love.graphics.draw(texture, pickup.x, pickup.y, 0, 1, 1)
			end
			
			if pickup.type == "shield" then
				love.graphics.setColor(1,1,1, 1)	
				love.graphics.draw(texture, pickup.x, pickup.y, 0, 1, 1)
			end
			
			if pickup.type == "star" then
				love.graphics.setColor(1,1,1, 1)	
				love.graphics.draw(texture, pickup.x, pickup.y, 0, 1, 1)
			end

			if editing or debug then
				pickups:drawdebug(pickup, i)
			end
		end
	end
	world.pickups = count
end


function pickups:drawdebug(pickup, i)
	love.graphics.setColor(0.39,1,0.39,0.39)
	love.graphics.rectangle(
		"line", 
		pickup.x, 
		pickup.y, 
		pickup.w,
		pickup.h
	)
	
	editor:drawid(pickup, i)
	editor:drawcoordinates(pickup)
end

function pickups:destroy(pickups, i)
	-- fade/collect animation can be added here
	table.remove(pickups, i)
end


