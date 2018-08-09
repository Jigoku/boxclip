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

title.splash = true -- disable this for debugging
title.splash_logo = love.graphics.newImage("data/artsoftware.png")
title.splashDelay = 1.5
title.splashCycle = 1.5
title.splashOpacity = 1

title.opacity = 1
title.opacitystep = 1
title.opacitymin = 0.4
title.opacitymax = 1

title.overlay = {}
title.overlay.opacity = 0
title.overlay.fadespeed = 0.78

title.menuitem = 1



title.mainmenu = {
	label="Boxclip (alpha preview)",
	{ "Play Map", select=function() title.activemenu = title:listmaps(0) end },
	{ "Edit Map", select=function() title.activemenu = title:listmaps(1) end },
	{ "Game Options", select=function() title.activemenu = title.optionsmenu end },
	{ "Quit", select=function() love.event.quit() end }
}
title.optionsmenu = {
	label="Game Options",
	{ "Keyboard/Input", select=function() title.activemenu = title.inputmenu  end },
	{ "Sound", select=function() title.activemenu = title.soundmenu  end },
	{ "Graphics", select=function() title.activemenu = title.graphicsmenu  end},
	{ "<- Back", select=function() title.activemenu = title.mainmenu end},		
}

title.inputmenu = {
	label="Keyboard/Input",
	{ "joystick: " ..joystick:getName(), select=function() return end },
	{ "<- Back", select=function() title.activemenu = title.optionsmenu end},		
}

title.graphicsmenu = {
	label="Graphics",
	{ "unimplemented", select=function() return end },
	{ "<- Back", select=function() title.activemenu = title.optionsmenu end},		
}

title.soundmenu = {
	label="Sound",
	{ "unimplemented", select=function() return end },
	{ "<- Back", select=function() title.activemenu = title.optionsmenu end},		
}

title.activemenu = title.mainmenu -- set the default menu to show



function title:init()
	mode = "title"
	self.bg = love.graphics.newImage("data/images/platforms/0001.png")
	self.bg:setWrap("repeat", "repeat")
	self.bgquad = love.graphics.newQuad( 0,0, love.graphics.getWidth(), love.graphics.getHeight(), self.bg:getDimensions() )
	self.bgscroll = 0
	self.bgscrollspeed = 25

	sound:playambient(0)
	sound:playbgm(12)
	self.keystr = ""
	
	cheats = {
		catlife = false,
		jetpack = false,
		magnet = false,
		millionare = false,
	}
	
	transitions:fadein()
	console:print("initialized title")
end


function title:listmaps(mode)
	-- build a dynamic menu for existing maps
	-- 0 = game
	-- 1 = edit
	local maps = mapio:getmaps()
	local menu = {}
	for i,map in ipairs(maps) do
		table.insert(menu, { 
			map, select = function() 
				world.map = title.activemenu[title.menuitem][1] 
				transitions:fadeoutmode((mode == 0 and "game" or "editing"))
				sound:play(sound.effects["start"])
			end
		})
	end
	table.insert(menu,{ "<- Back", select=function() title.activemenu = title.mainmenu end})
	menu.label = "Select a map to " .. (mode == 0 and "play" or "edit")
	
	return menu
	
end


function title:keypressed(key)
	self:checkcheatcodes(key)
end


function title:draw()
	
	if title.splash then
		love.graphics.setColor(1,1,1,title.splashOpacity)
		love.graphics.draw(title.splash_logo,love.graphics.getWidth()/2-title.splash_logo:getWidth()/2, love.graphics.getHeight()/2-title.splash_logo:getHeight()/2)
		return
	end
	
	---background
	love.graphics.setBackgroundColor(0,0,0,0)
	love.graphics.setColor(1,1,0.9,0.4)
	self.bgquad:setViewport(-self.bgscroll,-self.bgscroll,love.graphics.getWidth(), love.graphics.getHeight() )
	love.graphics.draw(self.bg, self.bgquad, 0,0)
		
	--frames	
	love.graphics.setColor(0.1,0.1,0.1,0.8)
	love.graphics.rectangle("fill",love.graphics.getWidth()/4-80, love.graphics.getHeight()/4-30,love.graphics.getWidth()/2+160,love.graphics.getHeight()/2+60,20)
	
	love.graphics.setColor(0.2,0.2,0.2,1)
	love.graphics.rectangle("fill", love.graphics.getWidth()/4-50, love.graphics.getHeight()/4+50, love.graphics.getWidth()/2+100,love.graphics.getHeight()/2-50,10)
	
	--title	
	love.graphics.setFont(fonts.huge)
	love.graphics.setColor(1,1,1,0.5)
	love.graphics.printf(self.activemenu.label,love.graphics.getWidth()/4,love.graphics.getHeight()/4,love.graphics.getWidth()/2,"center")
	
	--version
	love.graphics.setFont(fonts.default)
	love.graphics.setColor(1,1,1,0.5)
	love.graphics.printf("v"..version..build.." ("..love.system.getOS() ..") by "..author,10,love.graphics.getHeight()-25,300,"left",0,1,1)


	--menu / selection
	love.graphics.setFont(fonts.titlemenu)
	local padding = 30
	for i,menu in ipairs(title.activemenu) do
		if title.menuitem == i then
			love.graphics.setColor(0.7,0.5,0.2,1)
			love.graphics.rectangle("fill",love.graphics.getWidth()/4, love.graphics.getHeight()/3+(i*padding)-padding/4,300,padding,5,5)
			love.graphics.setColor(0,0,0,1)
		else
			love.graphics.setColor(1,1,1,1)	
		end
		
		love.graphics.print(menu,love.graphics.getWidth()/4, love.graphics.getHeight()/3+(i*padding))
	end


	love.graphics.setFont(fonts.default)
end



function title:update(dt)

	if title.splash then
		title.splashCycle = math.max(0, title.splashCycle - dt)
		
		if title.splashCycle <= 0 then
			if title.splashOpacity > 0 then
				title.splashOpacity = title.splashOpacity - 1 *dt
			else
				title.splashCycle = title.splashDelay
				title.splash = false
				transitions:fadein()
			end
		end
	
		return
	
	end

	--main title sequence
	
	title.opacity = (title.opacity - title.opacitystep*dt)
	if title.opacity < title.opacitymin  then
	title.opacity = title.opacitymin
		title.opacitystep = -title.opacitystep
	end
	if title.opacity > title.opacitymax  then
		title.opacity = title.opacitymax
		title.opacitystep = -title.opacitystep
	end		
	
	if title.overlay.fadeout then
		title.overlay.opacity = title.overlay.opacity +title.overlay.fadespeed *dt
		
		if title.overlay.opacity > 1 then
			title.overlay.opacity = 0
			title.overlay.fadeout = false
		end
	end
	
	if title.overlay.fadein then
		title.overlay.opacity = title.overlay.opacity -title.overlay.fadespeed *dt
		
		if title.overlay.opacity < 0 then
			title.overlay.opacity = 0
			title.overlay.fadein = false
		end
	end


	--scrolling background animation
	self.bgscroll = self.bgscroll + self.bgscrollspeed * dt
	if self.bgscroll > self.bg:getHeight() then
		self.bgscroll = self.bgscroll - self.bg:getWidth()
	end	

	--joystick/keyboard support for controlling menu
	self.key_delay_timer = math.max(0, self.key_delay_timer - dt)


	if self.key_delay_timer <= 0 then
		if transitions.active or console.active then return end
		
		if love.keyboard.isDown("down") or joystick:isDown("dpdown") then
			self.menuitem = self.menuitem +1
			--sound:play(sound.effects["blip"])
			self.key_delay_timer = self.key_delay
			
		elseif love.keyboard.isDown("up") or joystick:isDown("dpup") then 
			self.menuitem = self.menuitem -1
			--sound:play(sound.effects["blip"])
			self.key_delay_timer = self.key_delay
			
		elseif love.keyboard.isDown("return") or joystick:isDown("a") then 
			title.activemenu[title.menuitem].select()
			title.menuitem = 1
			sound:play(sound.effects["blip"])
			self.key_delay_timer = self.key_delay
			
		elseif love.keyboard.isDown("escape") or joystick:isDown("b") then 
			title.activemenu[#title.activemenu].select()
			sound:play(sound.effects["blip"])
			self.key_delay_timer = self.key_delay
		end
	end
	
	self.menuitem = math.max(math.min(self.menuitem,#title.activemenu),1)

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
