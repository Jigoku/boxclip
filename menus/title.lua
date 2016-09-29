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
 
 
 -- https://love2d.org/wiki/love.textinput
 -- https://love2d.org/wiki/love.keyboard.setTextInput
title = {}




function title:mapname(id)
	for i,map in ipairs(mapio:getmaps()) do
		if i == id then return map end
	end
end




function title:init()
	

	mode = "title"
	self.bg = love.graphics.newImage("data/images/backgrounds/sky.png")
	self.bg:setWrap("repeat", "repeat")
	self.bgquad = love.graphics.newQuad( 0,0, game.width, game.height, self.bg:getDimensions() )
	self.bgscroll = 0
	self.bgscrollspeed = 60
	
	self.frame = love.graphics.newImage("data/images/tiles/checked.png")
	self.frame:setWrap("repeat", "repeat")
	
	sound:playambient(0)
	sound:playbgm(6)
	self.sel = 1
	self.menu = "main"
	self.keystr = ""
	self.mapsel = 1
	
	cheats = {
		catlife = false,
		jetpack = false,
		magnet = false,
		millionare = false,
	}
	
	player:init() 
	--use for fade transition
	--self.fade = 255
	transitions:fadein()

	console:print("initialized title")
end

function title:mainselect(cmd)

	if cmd == "up" then 
		self.sel = self.sel -1 
		sound:play(sound.effects["blip"])
	end
	
	if cmd == "down" then 
		self.sel = self.sel +1 
		sound:play(sound.effects["blip"])
	end
	
 
	if cmd == "left" then self.mapsel = self.mapsel -1 end
	if cmd == "right" then self.mapsel = self.mapsel +1 end
		
	if self.mapsel < 1 then self.mapsel = 1 end
	if self.mapsel > #mapio:getmaps() then self.mapsel = #mapio:getmaps() end

	
	if cmd == "go" then
		world.map = self:mapname(self.mapsel)
		if self.sel == 1 then 
			transitions:fadeoutmode("game") 
			sound:play(sound.effects["start"])
		end
		if self.sel == 2 then 
			transitions:fadeoutmode("editing") 
			sound:play(sound.effects["blip"])
		end
		if self.sel == 3 then 
			self.menu = "options" 
			sound:play(sound.effects["blip"])
		end
		if self.sel == 4 then love.event.quit() end
	end
	
	if self.sel < 1 then self.sel = 1 return end
	if self.sel > 4 then self.sel = 4 return end

end


function title:keypressed(key)
	if not transitions.active then
		self:checkcheatcodes(key)
	
		if self.menu == "main" then
			if key == "escape" then love.event.quit() end
			if key == "up"     then title:mainselect("up") end
			if key == "down"   then title:mainselect("down") end
			if key == "return"   then title:mainselect("go") end
			if key == "left"   then title:mainselect("left") end
			if key == "right"   then title:mainselect("right") end
		end
	
		if self.menu == "options" then
			if key == "escape" then self.menu = "main" end
		end
	end
end

function title:draw()

	---background
	love.graphics.setBackgroundColor(0,0,0,255)
	love.graphics.setColor(255,255,255,255)		
	self.bgquad:setViewport(-self.bgscroll,0,game.width, game.height )
	love.graphics.draw(self.bg, self.bgquad, 0,0)
		
	--frames	
	love.graphics.setColor(210,150,100,255)		
	self.framequad = love.graphics.newQuad( 0,0, game.width/2+160,game.height/2+60, self.frame:getDimensions() ) -- update this
	love.graphics.draw(self.frame, self.framequad, game.width/4-80, game.height/4-30)
	
	love.graphics.setColor(10,10,10,150)
	love.graphics.rectangle("fill", game.width/4-50, game.height/4+50, game.width/2+100,game.height/2-50)
	
	
	--title	
	love.graphics.setFont(fonts.huge)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("Boxclip " ..version ..build,game.width/4,game.height/4,game.width/2,"center")
	
	if self.menu == "main" then
		self:drawmain()
	end
	
	love.graphics.setFont(fonts.default)
end



function title:update(dt)
	self.bgscroll = self.bgscroll + self.bgscrollspeed * dt
	if self.bgscroll > self.bg:getHeight() then
		self.bgscroll = self.bgscroll - self.bg:getWidth()
	end	
	--love.audio.setVolume( volume )
end






function title:checkcheatcodes(key)

	self.keystr = self.keystr .. key
	
	if string.match(self.keystr, "catlife") then
		console:print("cheat: catlife enabled")
		cheats.catlife = true
		self.keystr = ""
	end
	if string.match(self.keystr, "jetpack") then
		console:print("cheat: jetpack enabled")
		cheats.jetpack = true
		self.keystr = ""
	end
	if string.match(self.keystr, "magnet") then
		console:print("cheat: magnet enabled")
		cheats.magnet = true
		self.keystr = ""
	end
	if string.match(self.keystr, "shield") then
		console:print("cheat: shield enabled")
		cheats.shield = true
		self.keystr = ""
	end
	
	if string.match(self.keystr, "millionare") then
		console:print("cheat: millionare enabled")
		cheats.millionare = true
		self.keystr = ""
	end
end


function title:drawmain()
	--options
	love.graphics.setFont(fonts.menu)


	if self.sel == 0 then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill", game.width/4-10,game.height/4+90,game.width/2+20,40)
	end
	love.graphics.setColor(255,255,255,255)
	love.graphics.printf("Press left/right to select map",game.width/4,game.height/4+100,game.width/3,"left")





	--play 
	if self.sel == 1 then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill", game.width/4-10,game.height/4+130,game.width/2+20,40)
	end
		
	love.graphics.setColor(100,150,160,255)
	love.graphics.printf("Play",game.width/4,game.height/4+140,game.width/3,"left")
	love.graphics.setColor(100,140,60,155)
	love.graphics.printf("play " .. self:mapname(self.mapsel),game.width/4,game.height/4+140,game.width/2,"right")

	--editing 
		
	if self.sel == 2 then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill", game.width/4-10,game.height/4+170,game.width/2+20,40)
	end
		
	love.graphics.setColor(100,150,160,255)
	love.graphics.printf("Map Editor",game.width/4,game.height/4+180,game.width/3,"left")
	love.graphics.setColor(100,140,60,155)
	love.graphics.printf("edit " .. self:mapname(self.mapsel),game.width/4,game.height/4+180,game.width/2,"right")
		
	--options
	if self.sel == 3 then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill", game.width/4-10,game.height/4+210,game.width/2+20,40)
	end
		
	love.graphics.setColor(100,150,160,255)
	love.graphics.printf("Options",game.width/4,game.height/4+220,game.width/3,"left")
	love.graphics.setColor(100,140,60,155)
	love.graphics.printf("(unimplemented)",game.width/4,game.height/4+220,game.width/2,"right")
	
	--quit
	if self.sel == 4 then
		love.graphics.setColor(0,0,0,155)
		love.graphics.rectangle("fill", game.width/4-10,game.height/4+250,game.width/2+20,40)
	end
	
	love.graphics.setColor(100,150,160,255)
	love.graphics.printf("Quit",game.width/4,game.height/4+260,game.width/3,"left")
	


end




