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


function console:init()
	love.keyboard.setTextInput(false)
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

	self.key_delay_timer = 0 -- used for backspace key only at the moment
	self.key_delay = 0.05

	self:print (name .. " " .. version .. build .. "-" .. love.system.getOS() .. " by " .. author)
	self:print ("-------------------------------------------------")
	self:print (love.system.getOS() .. " | " .. _VERSION .. " | " .. string.format("Love2D %d.%d.%d - %s",love.getVersion()))
	self:print ("-------------------------------------------------")

end


function console:toggle(v)

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
	if self.active and self.opacity > 0 then
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

	if key == "return" then

		-- add special commands
		if string.match(self.command, "^/") then
			if     self.command == "/quit" then love.event.quit()
			elseif self.command == "/kill" then player:die("suicide")
			elseif self.command == "/title" then title:init()
			elseif self.command == "/showfps" then fps = not fps
			elseif self.command == "/debug" then debug = not debug
			elseif self.command == "/savemap" then mapio:savemap(world.map)
			else
				self:print ("unknown command")

			end
		else
			-- run/exec lua code here
			local fn, err = loadstring(self.command)
			if not fn then
					self:print(err)
				else
				local ok, result = pcall(fn)
				if not ok then
					-- There was an error, so result is an error. Print it out.
					self:print(result)
				elseif result then
					self:print(result)
				end
			end

			--alternative method
			--[[local fn, err = loadstring(console.command)
			if not fn then
				console:print(err)
			else
				local result = {pcall(fn)}
				local ok = table.remove(result, 1)
				if not ok then
					console:print(result[1])
				else
					for i = 1, #result do
						result[i] = tostring(result[i])
					end
					console:print(table.concat(result, '\t'))
				end
			end--]]

		end

		self.command = ""
	end

	if key == "`" then
		self:toggle()
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


function console:print(event)
	local elapsed =  world:formattime(os.difftime(os.time()-game.runtime))
	local line = { {1,0.5,0}, elapsed, {0.5,1,0.5}, " | ", {1,1,0.5}, event }

	if #self.buffer >= self.scrollback then
		table.remove(self.buffer, 1)
	end

	table.insert(self.buffer, line)
	print (event)
end
