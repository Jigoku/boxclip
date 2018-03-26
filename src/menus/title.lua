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
 
 
 -- https://love2d.org/wiki/love.textinput
 -- https://love2d.org/wiki/love.keyboard.setTextInput
title = {}
title.key_delay_timer = 0
title.key_delay = 0.15

function title:mapname(id)
	for i,map in ipairs(self.maps) do
		if i == id then return map end
	end
end

function title:init()
	mode = "title"
	self.bg = love.graphics.newImage("data/images/platforms/0001.png")
	self.bg:setWrap("repeat", "repeat")
	self.bgquad = love.graphics.newQuad( 0,0, love.graphics.getWidth(), love.graphics.getHeight(), self.bg:getDimensions() )
	self.bgscroll = 0
	self.bgscrollspeed = 25

	
	sound:playambient(0)
	sound:playbgm(6)
	self.sel = 1
	self.menu = "main"
	self.keystr = ""
	self.mapsel = 1
	
	self.maps = mapio:getmaps()
	
	cheats = {
		catlife = false,
		jetpack = false,
		magnet = false,
		millionare = false,
	}
	
	--use for fade transition
	--self.fade = 255
	transitions:fadein()

	console:print("initialized title")
end



function title:keypressed(key)
	self:checkcheatcodes(key)
end

function title:draw()

	---background
	love.graphics.setBackgroundColor(0,0,0,255)
	love.graphics.setColor(255,255,255,50)		
	self.bgquad:setViewport(-self.bgscroll,-self.bgscroll,love.graphics.getWidth(), love.graphics.getHeight() )
	love.graphics.draw(self.bg, self.bgquad, 0,0)
		
	--frames	
	love.graphics.setColor(100,100,100,150)
	love.graphics.rectangle("fill",love.graphics.getWidth()/4-80, love.graphics.getHeight()/4-30,love.graphics.getWidth()/2+160,love.graphics.getHeight()/2+60,20)
	
	love.graphics.setColor(10,10,10,150)
	love.graphics.rectangle("fill", love.graphics.getWidth()/4-50, love.graphics.getHeight()/4+50, love.graphics.getWidth()/2+100,love.graphics.getHeight()/2-50,10)
	
	--title	
	love.graphics.setFont(fonts.huge)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("Boxclip",love.graphics.getWidth()/4,love.graphics.getHeight()/4,love.graphics.getWidth()/2,"center")
	
	--version
	love.graphics.setFont(fonts.menu)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("v"..version..build.." ("..love.system.getOS() ..") by "..author,10,love.graphics.getHeight()-25,300,"left",0,1,1)
	
	if self.menu == "main" then
		self:drawmain()
	elseif self.menu == "options" then
		self:drawoptions()
	end
	
	love.graphics.setFont(fonts.default)
end



function title:update(dt)
	--scrolling background animation
	self.bgscroll = self.bgscroll + self.bgscrollspeed * dt
	if self.bgscroll > self.bg:getHeight() then
		self.bgscroll = self.bgscroll - self.bg:getWidth()
	end	
	
	--joystick/keyboard support
	self.key_delay_timer = math.max(0, self.key_delay_timer - dt)
	if self.key_delay_timer <= 0 then
		if transitions.active then return end
		
		if love.keyboard.isDown("down") or joystick:isDown("dpdown") then
			if self.menu == "main" then
				self.sel = self.sel +1 
			end
			sound:play(sound.effects["blip"])
			self.key_delay_timer = self.key_delay
			
		elseif love.keyboard.isDown("up") or joystick:isDown("dpup") then 
			if self.menu == "main" then
				self.sel = self.sel -1 
			end
			sound:play(sound.effects["blip"])
			self.key_delay_timer = self.key_delay
			
		elseif love.keyboard.isDown("left") or joystick:isDown("dpleft") then
			if self.menu == "main" then
				self.mapsel = self.mapsel -1 
			end
			sound:play(sound.effects["blip"])
			self.key_delay_timer = self.key_delay
			
		elseif love.keyboard.isDown("right") or joystick:isDown("dpright") then 
			if self.menu == "main" then
				self.mapsel = self.mapsel +1
			end
			sound:play(sound.effects["blip"])
			self.key_delay_timer = self.key_delay
			
		elseif love.keyboard.isDown("return") or joystick:isDown("a") then 
			if self.menu == "main" then
				world.map = self:mapname(self.mapsel)
			end
			sound:play(sound.effects["blip"])
			self.key_delay_timer = self.key_delay
			
			if self.menu == "main" then
				if self.sel == 1 then 
					transitions:fadeoutmode("game") 
					sound:play(sound.effects["start"])
				end
				if self.sel == 2 then 
					transitions:fadeoutmode("editing") 
				end
				if self.sel == 3 then 
					self.menu = "options" 
				end
				if self.sel == 4 then 
					love.event.quit() 
				end
			elseif self.menu == "options" then
				--unimplemented
			end
			
		elseif love.keyboard.isDown("escape") or joystick:isDown("b") then 
			self.menu = "main"
			sound:play(sound.effects["blip"])
			self.key_delay_timer = self.key_delay
		end
		
		self.sel = math.min(math.max(self.sel,1),4)
		self.mapsel = math.min(math.max(self.mapsel,1),#self.maps)
	end
	

end



function title:checkcheatcodes(key)

	self.keystr = self.keystr .. key
	
	if string.match(self.keystr, "catlife") then
		console:print("cheat: catlife enabled")
		cheats.catlife = true
		self.keystr = ""
		sound:play(sound.effects["start"])
	end
	if string.match(self.keystr, "jetpack") then
		console:print("cheat: jetpack enabled")
		cheats.jetpack = true
		self.keystr = ""
		sound:play(sound.effects["start"])
	end
	if string.match(self.keystr, "magnet") then
		console:print("cheat: magnet enabled")
		cheats.magnet = true
		self.keystr = ""
		sound:play(sound.effects["start"])
	end
	if string.match(self.keystr, "shield") then
		console:print("cheat: shield enabled")
		cheats.shield = true
		self.keystr = ""
		sound:play(sound.effects["start"])
	end
	
	if string.match(self.keystr, "millionare") then
		console:print("cheat: millionare enabled")
		cheats.millionare = true
		self.keystr = ""
		sound:play(sound.effects["start"])
	end
end


function title:drawoptions()
	love.graphics.setFont(fonts.menu)
	if self.sel == 0 then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill", love.graphics.getWidth()/4-10,love.graphics.getHeight()/4+90,love.graphics.getWidth()/2+20,40)
	end
	love.graphics.setColor(255,255,255,255)
	love.graphics.printf("Press left/right to change setting",love.graphics.getWidth()/4,love.graphics.getHeight()/4+100,love.graphics.getWidth()/3,"left")

	--play 
	if self.sel == 1 then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill", love.graphics.getWidth()/4-10,love.graphics.getHeight()/4+130,love.graphics.getWidth()/2+20,40)
	end
		
	love.graphics.setColor(100,150,160,255)
	love.graphics.printf("vsync",love.graphics.getWidth()/4,love.graphics.getHeight()/4+140,love.graphics.getWidth()/3,"left")
	love.graphics.setColor(100,140,60,155)
	love.graphics.printf("n/a",love.graphics.getWidth()/4,love.graphics.getHeight()/4+140,love.graphics.getWidth()/2,"right")

	--editing 
		
	if self.sel == 2 then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill", love.graphics.getWidth()/4-10,love.graphics.getHeight()/4+170,love.graphics.getWidth()/2+20,40)
	end
		
	love.graphics.setColor(100,150,160,255)
	love.graphics.printf("joystick",love.graphics.getWidth()/4,love.graphics.getHeight()/4+180,love.graphics.getWidth()/3,"left")
	love.graphics.setColor(100,140,60,155)
	love.graphics.printf(joystick:getName(),love.graphics.getWidth()/4,love.graphics.getHeight()/4+180,love.graphics.getWidth()/2,"right")
		
	
	love.graphics.setColor(100,150,160,255)
	love.graphics.printf("Back",love.graphics.getWidth()/4,love.graphics.getHeight()/4+260,love.graphics.getWidth()/3,"left")
	
end

function title:drawmain()
	--options
	love.graphics.setFont(fonts.menu)


	if self.sel == 0 then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill", love.graphics.getWidth()/4-10,love.graphics.getHeight()/4+90,love.graphics.getWidth()/2+20,40)
	end
	love.graphics.setColor(255,255,255,255)
	love.graphics.printf("Press left/right to select map",love.graphics.getWidth()/4,love.graphics.getHeight()/4+100,love.graphics.getWidth()/3,"left")

	--play 
	if self.sel == 1 then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill", love.graphics.getWidth()/4-10,love.graphics.getHeight()/4+130,love.graphics.getWidth()/2+20,40)
	end
		
	love.graphics.setColor(100,150,160,255)
	love.graphics.printf("Play",love.graphics.getWidth()/4,love.graphics.getHeight()/4+140,love.graphics.getWidth()/3,"left")
	love.graphics.setColor(100,140,60,155)
	love.graphics.printf("play " .. self:mapname(self.mapsel),love.graphics.getWidth()/4,love.graphics.getHeight()/4+140,love.graphics.getWidth()/2,"right")

	--editing 
		
	if self.sel == 2 then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill", love.graphics.getWidth()/4-10,love.graphics.getHeight()/4+170,love.graphics.getWidth()/2+20,40)
	end
		
	love.graphics.setColor(100,150,160,255)
	love.graphics.printf("Map Editor",love.graphics.getWidth()/4,love.graphics.getHeight()/4+180,love.graphics.getWidth()/3,"left")
	love.graphics.setColor(100,140,60,155)
	love.graphics.printf("edit " .. self:mapname(self.mapsel),love.graphics.getWidth()/4,love.graphics.getHeight()/4+180,love.graphics.getWidth()/2,"right")
		
	--options
	if self.sel == 3 then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill", love.graphics.getWidth()/4-10,love.graphics.getHeight()/4+210,love.graphics.getWidth()/2+20,40)
	end
		
	love.graphics.setColor(100,150,160,255)
	love.graphics.printf("Options",love.graphics.getWidth()/4,love.graphics.getHeight()/4+220,love.graphics.getWidth()/3,"left")
	love.graphics.setColor(100,140,60,155)
	love.graphics.printf("(unimplemented)",love.graphics.getWidth()/4,love.graphics.getHeight()/4+220,love.graphics.getWidth()/2,"right")
	
	--quit
	if self.sel == 4 then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill", love.graphics.getWidth()/4-10,love.graphics.getHeight()/4+250,love.graphics.getWidth()/2+20,40)
	end
	
	love.graphics.setColor(100,150,160,255)
	love.graphics.printf("Quit",love.graphics.getWidth()/4,love.graphics.getHeight()/4+260,love.graphics.getWidth()/3,"left")
	
end




