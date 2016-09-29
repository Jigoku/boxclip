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

console = {}

console.show = false

console.buffer = {
	--make this configurable (maxconlines etc, with scrollback buffer)
	l1 = "",
	l2 = "",
	l3 = "",
	l4 = "",
	l5 = "",
	l6 = "",
	l7 = ""
}

function console:toggle()
	sound:play(sound.effects["beep"])
	console.show = not console.show
	debug = not debug
end
function console:draw()
	if self.show then
		--console info
		love.graphics.setColor(0,0,0,100)
		love.graphics.rectangle("fill", 1, 1, game.width-2, 160)	
		love.graphics.setColor(100,100,100,100)
		love.graphics.rectangle("line", 1, 1, game.width-2, 160)
		
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
		

		love.graphics.setColor(0,0,0,55)
		love.graphics.rectangle("fill",  game.width/5, game.height-50, 600, 25)
		love.graphics.setColor(255,100,255,255)
		love.graphics.print(
			"pickups: " .. world:count(pickups) .. "(".. world.pickups .. ")" ..
			" | enemies: " .. world:count(enemies) .. "(".. world.enemies .. ")" ..
			" | platforms: " .. world:count(platforms) .. "(".. world.platforms .. ")" ..
			" | props: " .. world:count(props) .. "("..world.props .. ")" ..
			" | springs: " .. world:count(springs) .. "("..world.springs .. ")" ..
			" | portals: " .. world:count(portals) .. "("..world.portals .. ")" ..
			" | crates: " .. world:count(crates) .. "("..world.crates .. ")" .. "\n"..
			
			" checkpoints: " .. world:count(checkpoints) .. "("..world.checkpoints .. ")" ..
			" | decals: " .. world:count(decals) .. "("..world.decals .. ")" ..
			" | bumpers: " .. world:count(bumpers) .. "("..world.bumpers .. ")" ..
			" | traps: " .. world:count(traps) .. "(" .. world.traps .. ")" ..
			" | t: " ..world:totalents() .. "(" .. world:totalentsdrawn() .. ")" ..
			" | ccpf: " .. world.collision,
			 game.width/5, game.height-50
		)
		end
		
		love.graphics.setColor(155,155,155,255)
		love.graphics.print(self.buffer.l1,5,50)
		love.graphics.print(self.buffer.l2,5,65)
		love.graphics.print(self.buffer.l3,5,80)
		love.graphics.print(self.buffer.l4,5,95)
		love.graphics.print(self.buffer.l5,5,110)
		love.graphics.print(self.buffer.l6,5,125)
		love.graphics.print(self.buffer.l7,5,140)

	end
end





function console:print(event)
	local elapsed =  world:formatTime(os.difftime(os.time()-game.runtime))
	local line = elapsed .. " | " ..  event
	self.buffer.l1 = self.buffer.l2
	self.buffer.l2 = self.buffer.l3
	self.buffer.l3 = self.buffer.l4
	self.buffer.l4 = self.buffer.l5
	self.buffer.l5 = self.buffer.l6
	self.buffer.l6 = self.buffer.l7
	self.buffer.l7 = line
	print (line)
end
