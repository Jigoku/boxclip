--[[
 * Copyright (C) 2015 - 2022 Ricky K. Thomson
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

gameover = {}

function gameover:init()
	mode = "gameover"
	self.bg = love.graphics.newImage("data/images/platforms/0001.png")
	self.bg:setWrap("repeat", "repeat")
	self.bgquad = love.graphics.newQuad( 0,0, love.graphics.getWidth(), love.graphics.getHeight(), self.bg:getDimensions() )
	self.bgscroll = 0
	self.bgscrollspeed = 25

	sound:playambient(0)
	sound:playbgm(5)

	transitions:fadein()

	console:print("initialized gameover")
end


function gameover:keypressed(key)
	if not transitions.active then
		title:init()
	end
end


function gameover:draw()
	---background
	love.graphics.setBackgroundColor(0,0,0,1)
	love.graphics.setColor(1,1,1,0.19)
	self.bgquad:setViewport(-self.bgscroll,-self.bgscroll,love.graphics.getWidth(), love.graphics.getHeight() )
	love.graphics.draw(self.bg, self.bgquad, 0,0)

	--frames
	love.graphics.setColor(0.03,0.03,0.03,0.58)
	love.graphics.rectangle("fill", love.graphics.getWidth()/4-50, love.graphics.getHeight()/4+50, love.graphics.getWidth()/2+100,love.graphics.getHeight()/2-50,10)

	--gameover
	love.graphics.setFont(fonts.huge)
	love.graphics.setColor(1,1,1,0.60)
	love.graphics.printf("Game Over",love.graphics.getWidth()/4,love.graphics.getHeight()/4,love.graphics.getWidth()/2,"center")
	love.graphics.print("SCORE: "..player.score,love.graphics.getWidth()/4,love.graphics.getHeight()/4+100)
	love.graphics.printf("Press any key to exit",love.graphics.getWidth()/4,love.graphics.getHeight()-100,love.graphics.getWidth()/2,"center")

	love.graphics.setFont(fonts.default)
end


function gameover:update(dt)
	self.bgscroll = self.bgscroll + self.bgscrollspeed * dt
	if self.bgscroll > self.bg:getHeight() then
		self.bgscroll = self.bgscroll - self.bg:getWidth()
	end
end





