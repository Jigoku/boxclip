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
 
 transitions = {}
 transitions.active = false

function transitions:fadein()
	transitions.fade = 255
	self.state_fadein = true
	self.active = true

end

function transitions:fadeout(mode)
	transitions.fade = 0
	self.state_fadeout = true
	self.active = true
	self.mode = mode
end




function transitions:run(dt)
	if self.state_fadeout then
		self.fade = self.fade +500 *dt
		love.audio.setVolume( love.audio.getVolume()-2*dt)
		if self.fade > 255 then
			self.fade = 0
			self.state_fadeout = false
			self.active = false
			love.audio.stop()
			love.audio.setVolume(1)
			world:init(self.mode)
		end
	end
	
	if self.state_fadein then
		self.fade = self.fade -500 *dt
		if self.fade < 0 then
			self.fade = 255
			self.state_fadein = false
			self.active = false
		end
	end
end


function transitions:draw()
	if self.active then
		love.graphics.setColor(0,0,0,self.fade)
		love.graphics.rectangle("fill", 0,0,WIDTH,HEIGHT)
	end
end
