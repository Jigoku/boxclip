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


love.keyboard.setTextInput(false)

--console.scrollback = 256
--[[
add pgup pgdn to move selection of scrollback, by setting for eg;
	console.min = 10
	console.max = 20
--]]


function console:init()
	self.buffer = {}
	self.h = 200
	self.w = love.graphics.getWidth()/1.5
	self.canvas = love.graphics.newCanvas(self.w, self.h)
	self.opacity = 0
	self.maxopacity = 0
	self.minopacity = 0.8
	self.fadespeed = 4
	self.active = false
	self.scrollback = 11
	self.command = ""
	self.keydelay = 4
	
	self.key_delay_timer = 0 -- used for backspace key only at the moment
	self.key_delay = 0.05
	
	self:print (name .. " " .. version .. build .. " by " .. author)
end

function console:toggle(v)
	--sound:play(sound.effects["beep"])
	debug = not debug
	self.command = ""
	
	if self.active then
		self.active = false
		love.keyboard.setTextInput(false)
		
	else
		self.active = true
		love.keyboard.setTextInput(true)
	end
	

end

function console:draw()
	if self.active then

		-- this could be moved elsewhere on screen, as it's debug info (not console info)
		if not (mode == "title") then
		
			love.graphics.setColor(0,0,0,0.8)
			love.graphics.rectangle("fill",  love.graphics.getWidth()/5, love.graphics.getHeight()-100, 600, 90)
			
			--score etc
			if mode == "game" then
				love.graphics.setColor(1,1,1,1)
				love.graphics.print(
					"[lives: " .. player.lives .. "]"..
					"[score: " .. player.score .. "]"..
					"[time: " .. world:formattime(world.time) .. "]"..
					"[alive: "..(player.alive and 1 or 0).."]", 
					love.graphics.getWidth()/5, love.graphics.getHeight()-100
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
				love.graphics.getWidth()/5, love.graphics.getHeight()-75
			)
		

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
		
		
		--fps info etc
		love.graphics.setColor(0,0,0,0.7)
		love.graphics.rectangle("fill",love.graphics.getWidth()-160, 5,150,105,10)
		love.graphics.setFont(fonts.debug)
		love.graphics.setColor(1,1,1,1)
		love.graphics.print(
			"fps " .. love.timer.getFPS() .. "\n" ..
			"memory(gc) " ..  gcinfo() .."kB\n"..
			string.format("vram %.2fMB", love.graphics.getStats().texturememory / 1024 / 1024) .. "\n" ..
			"tick " .. game.ticks .. "\n" ..
			"update " .. math.round(game.utick_time,1) .. "ms\n" ..
			"draw " .. math.round(game.dtick_time,1) .. "ms",
			love.graphics.getWidth()-155, 10
		)
		
	end
		
	if self.opacity > 0 then
		-- draw the console contents
		love.graphics.setCanvas(self.canvas)
		love.graphics.setFont(fonts.console)
		love.graphics.setColor(0,0,0.1,1)
		love.graphics.rectangle("fill", 0, 0, self.w, self.h,10,10)	
		love.graphics.setColor(0.3,0.3,0.5,1)
		local lw = love.graphics.getLineWidth()
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("line", 0, 0, self.w, self.h,10,10)
		love.graphics.setLineWidth(lw)
		
		love.graphics.setColor(1,1,1,1)
			
		for i, line in ripairs(self.buffer) do
			if i > self.scrollback then break end
			love.graphics.print(self.buffer[i],5,i*15-10)			
		end
		
		love.graphics.print("exec> ".. self.command, 5, console.h-20)
		love.graphics.setCanvas()
		
		love.graphics.setColor(1,1,1,self.opacity)
		love.graphics.draw(self.canvas, 0,0)
	end
	
end

function console:textinput(t)
	-- concatenate text into console command input
	if self.active then
		self.command = self.command .. t
	end
end

function console:keypressed(key)


	-- add special keys
	if key == "return" then
		if     console.command == "quit" then love.event.quit() 
		elseif console.command == "kill" then player:die("suicide")
		elseif console.command == "title" then title:init()
		else
				-- run/exec function here
				console:print("unknown command: " .. console.command)
		end			
		console.command = ""
	end
		
		
	if key == "`" then
		console:toggle()
	end


end

function console:update(dt)
	
	if self.active then
		self.key_delay_timer = math.max(0, self.key_delay_timer - dt)
		if self.key_delay_timer <= 0 then
			if love.keyboard.isDown("backspace") then
				console.command = console.command:sub(1, -2)
			end
			self.key_delay_timer = self.key_delay
		end
		
		-- animate console transition when activated
		if self.opacity < 1 then
			self.opacity = math.min(self.minopacity, self.opacity + self.fadespeed * dt)
		end
		
	else
		-- animate console transition when deactivated
		self.opacity = math.max(self.maxopacity, self.opacity - self.fadespeed * dt)
	end
	
end


-- add console with capability to set variables as command input TODO
function console:print(event)
	local elapsed =  world:formattime(os.difftime(os.time()-game.runtime))
	local line = { --[[{1,0.5,1}, elapsed, --]]{0.5,1,0.5}, " | ", {1,1,0.5}, event }
	
	if #self.buffer >= self.scrollback then 
		table.remove(self.buffer, 1)
	end
	
	table.insert(self.buffer, line)
	--print (line)
end
