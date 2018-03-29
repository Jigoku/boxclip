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
 
traps = {}

traps.textures = {
	["log"] = love.graphics.newImage("data/images/traps/log.png"),
	["bridge"] = love.graphics.newImage("data/images/traps/bridge.png"),
	["brick"] = love.graphics.newImage("data/images/traps/brick.png"),
}

table.insert(editor.entities, {"log","trap"})
table.insert(editor.entities, {"bridge","trap"})
table.insert(editor.entities, {"brick","trap"})

function traps:add(x,y,type)

	if type == "brick" then
		table.insert(world.entities.trap, {
			--dimensions
			x = x or 0,
			y = y or 0,
			w = self.textures[type]:getWidth()*2,
			h = self.textures[type]:getHeight()*2,
			--properties
			group = "trap",
			type = type,
			falling = false,
			active = true,
			timer = 0.00,
			mass = 800,
			segments = {
				[1] = {x=0,y=0 } ,
				[2] = {x=self.textures[type]:getWidth(),y=0 } ,
				[3] = {x=0,y=self.textures[type]:getHeight() } ,
				[4] = {x=self.textures[type]:getWidth(),y=self.textures[type]:getHeight() } ,
			},
			xvel = 100,
			yvel = 0,
			score = 100,
		})
		print("trap added @  X:"..x.." Y: "..y)
	
		return
	end


	table.insert(world.entities.trap, {
		--dimensions
		x = x or 0,
		y = y or 0,
		w = self.textures[type]:getWidth(),
		h = self.textures[type]:getHeight(),
		--properties
		group = "trap",
		type = type,
		falling = false,
		active = true,
		timer = 0.05,
		mass = 800,
		xvel = 0,
		yvel = 0,
	})
	print("trap added @  X:"..x.." Y: "..y)
	
end

function traps:draw()
	local count = 0
	
	for i, trap in ipairs(world.entities.trap) do
		if world:inview(trap) and trap.active then
			count = count +1
					
			love.graphics.setColor(255,255,255,255)

			local texture = self.textures[trap.type]

			if trap.type == "brick"  then
				love.graphics.draw(texture, trap.x+trap.segments[1].x,trap.y+trap.segments[1].y,0, 1, 1)
				love.graphics.draw(texture, trap.x+trap.segments[2].x,trap.y+trap.segments[2].y,0, 1, 1)
				love.graphics.draw(texture, trap.x+trap.segments[3].x,trap.y+trap.segments[3].y,0, 1, 1)
				love.graphics.draw(texture, trap.x+trap.segments[4].x,trap.y+trap.segments[4].y,0, 1, 1)
			else
				if trap.falling then
					local wobble = 1.5
					love.graphics.draw(texture, trap.x+love.math.random(-wobble,wobble),trap.y,0, 1, 1)
				else
					love.graphics.draw(texture, trap.x,trap.y,0, 1, 1)
				end
			end

			if editing or debug then
				traps:drawdebug(trap, i)
			end

		end
	end

	world.traps = count
end


function traps:drawdebug(trap, i)
	love.graphics.setColor(255,0,155,100)
	love.graphics.rectangle(
		"line", 
		trap.x, 
		trap.y, 
		trap.w, 
		trap.h
	)
	
	editor:drawid(trap, i)
	editor:drawcoordinates(trap)
end



