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

console = {}
console.buffer = {}
console.h = 305
console.canvas = love.graphics.newCanvas(love.graphics.getWidth(), console.h)
console.opacity = 0
console.maxopacity = 0
console.minopacity = 0.8
console.fadespeed = 4
console.active = false
--console.scrollback = 256
console.scrollback = 20

--[[
add pgup pgdn to move selection of scrollback, by setting for eg;
	console.min = 10
	console.max = 20
--]]




function console:toggle()
	sound:play(sound.effects["beep"])
	self.active = not self.active
	debug = not debug
end

function console:draw()
	if self.active then

		-- this could be moved elsewhere on screen, as it's debug info (not console info)
		if not (mode == "title") then
			--score etc
			if mode == "game" then
				love.graphics.setColor(1,0,1,1)
				love.graphics.print(
					"[lives: " .. player.lives .. "]"..
					"[score: " .. player.score .. "]"..
					"[time: " .. world:formattime(world.time) .. "]"..
					"[alive: "..(player.alive and 1 or 0).."]", 
					250,5
				)
			end
		
			love.graphics.setColor(1,1,1,1)
			love.graphics.print(
				"X: " .. math.round(player.x) .. 
				" | Y: " .. math.round(player.y) .. 
				" | dir: " .. player.dir .. 
				" | xvel: " .. math.round(player.xvel) .. 
				" | yvel: " .. math.round(player.yvel) .. 
				" | jumping: " .. (player.jumping and 1 or 0) ..
				" | camera.scale: " .. camera.scale, 
				5, 20
			)
		
	
			love.graphics.setColor(0,0,0,0.20)
			love.graphics.rectangle("fill",  love.graphics.getWidth()/5, love.graphics.getHeight()-50, 600, 25)
			love.graphics.setColor(1,0.4,1,1)
			love.graphics.print(
				"pickups: " .. #world.entities.pickup .. "(".. world.pickups .. ")" ..
				" | enemies: " .. #world.entities.enemy .. "(".. world.enemies .. ")" ..
				" | platforms: " .. #world.entities.platform .. "(".. world.platforms .. ")" ..
				" | props: " .. #world.entities.prop .. "("..world.props .. ")" ..
				" | springs: " .. #world.entities.spring .. "("..world.springs .. ")" ..
				" | portals: " .. #world.entities.portal .. "("..world.portals .. ")" ..
				" | crates: " .. #world.entities.crate .. "("..world.crates .. ")" .. "\n"..
				"checkpoints: " .. #world.entities.checkpoint .. "("..world.checkpoints .. ")" ..
				" | decals: " .. #world.entities.decal .. "("..world.decals .. ")" ..
				" | bumpers: " .. #world.entities.bumper .. "("..world.bumpers .. ")" ..
				" | traps: " .. #world.entities.trap .. "(" .. world.traps .. ")" ..
				" | tips: " .. #world.entities.tip .. "(" .. world.tips .. ")" ..
				" | total: " .. world:totalents() .. "(" .. world:totalentsdrawn() .. ")" .. 
				" | ccpf: " .. world.collision,
				love.graphics.getWidth()/5, love.graphics.getHeight()-50
			)
		end
	end
		
	if self.opacity > 0 then
		-- draw the console contents
		love.graphics.setCanvas(self.canvas)
		love.graphics.setFont(fonts.default)
		love.graphics.setColor(0,0,0,1)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), self.h,10,10)	
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("line", 0, 0, love.graphics.getWidth(), self.h,10,10)
		
		
		love.graphics.setColor(1,1,1,1)
			
		for i, line in ripairs(self.buffer) do
			if i > self.scrollback then break end
			love.graphics.print(self.buffer[i],5,i*15-10)			
		end
		
		love.graphics.print("> ",5,console.h-20)
		love.graphics.setCanvas()
		
		love.graphics.setColor(1,1,1,self.opacity)
		love.graphics.draw(self.canvas, 0,0)
	end
	
end


function console:update(dt)
	-- animate console transition
	if self.active then
		if self.opacity < 1 then
			self.opacity = math.min(self.minopacity, self.opacity + self.fadespeed * dt)
		end
	else
		self.opacity = math.max(self.maxopacity, self.opacity - self.fadespeed * dt)
	end
end


-- add console with capability to set variables as command input TODO
function console:print(event)
	local elapsed =  world:formattime(os.difftime(os.time()-game.runtime))
	local line = elapsed .. " | " ..  event
	
	if #self.buffer >= self.scrollback then 
		table.remove(self.buffer, 1)
	end
	
	table.insert(self.buffer, line)
	print (line)
end
