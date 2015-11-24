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

--[[
	editor binds
	
	select/drag     : lmb
	delete entity   : rmb
	scroll entities : wu/wd
	
	rotate/entdir	: r
	move up	    	: numpad 8
	move down		: numpad 2
	move left		: numpad 4
	move right		: numpad 6
	theme palette   : t
	copy dimensions	: c
	paste			: p	
	delete entity	: del
	camera scale	: z
	camera position	: w,a,s,d
	
	some may be undocumented, check this when adding help menu for editor
--]]

editor = {}
editing = false

mousePosX = 0
mousePosY = 0

editor.entdir = 0 			--(used for some entites 0,1,2,3 = up,down,right,left)
editor.entsel = 0			--current entity id for placement
editor.themesel = 0			--theme pallete in use
editor.showpos = true		--axis info for entitys
editor.showid  = true		--id info for entities
editor.showmmap = true	    --toggle minimap
editor.showguide = true     --toggle guidelines
editor.showentmenu = true   --toggle entmenu
editor.showhelpmenu = false  --toggle helpmenu
editor.drawsel = false		--selection outline
editor.movespeed = 1000		--editing floatspeed

editor.entmenuw = 150       --entmenu width
editor.entmenuh = 300		--entmenu height
editor.helpmenuw = 240
editor.helpmenuh = 400

editor.clipboard = {}		--clipboard contents


function editor:entname(id)
	--list of entity id's (these can be reordered / renumbered
	--without any issues, as long as "entity.name" is specified
	if id == 0 then return "spawn" 
	elseif id == 1 then return "goal" 
	elseif id == 2 then return "platform" 
	elseif id == 3 then return "platform_b" 
	elseif id == 4 then return "platform_b_x" 
	elseif id == 5 then return "platform_b_y" 
	elseif id == 6 then return "platform_x" 
	elseif id == 7 then return "platform_y" 
	elseif id == 8 then return "platform_s" 
	elseif id == 9 then return "checkpoint" 
	elseif id ==10 then return "crate" 
	elseif id ==11 then return "spike" 
	elseif id ==12 then return "spike_large" 
	elseif id ==13 then return "icicle" 
	elseif id ==14 then return "walker" 
	elseif id ==15 then return "floater" 
	elseif id ==16 then return "spikeball" 
	elseif id ==17 then return "gem" 
	elseif id ==18 then return "life" 
	elseif id ==19 then return "magnet" 
	elseif id ==20 then return "shield" 
	elseif id ==21 then return "flower" 
	elseif id ==22 then return "rock" 
	elseif id ==23 then return "tree" 
	elseif id ==24 then return "arch" 
	elseif id ==25 then return "arch2" 
	elseif id ==26 then return "pillar" 
	elseif id ==27 then return "spring_s" 
	elseif id ==28 then return "spring_m" 
	elseif id ==29 then return "spring_l" 
	else return "----"
	end
end



function editor:themename(id)
	if id == 0 then return "sunny" 
	elseif id == 1 then return "frost" 
	elseif id == 2 then return "hell" 
	elseif id == 3 then return "mist" 
	elseif id == 4 then return "dust" 
	elseif id == 5 then return "swamp" 
	elseif id == 6 then return "night" 
	end
end

function editor:settheme()
	world.theme = self:themename(self.themesel)
	world:settheme(world.theme)
	
	for i,e in ipairs(enemies) do 
		if e.name == "spike" then e.gfx = spike_gfx end
		if e.name == "spike_large" then e.gfx = spike_large_gfx end
		if e.name == "icicle" then e.gfx = icicle_gfx end
	end
	self.themesel = self.themesel +1
	if self.themesel > 6 then self.themesel = 0 end
	
end

function editor:keypressed(key)
	--print (key)

	if key == "f1" then 
		editing = not editing
		player.xvel = 0
		player.yvel = 0
		player.angle = 0
		player.jumping = false
		player.xvelboost = 0
	end

	if key == "z" then self:zoom() end
	if key == "h" then self.showhelpmenu = not self.showhelpmenu end	
	if key == "m" then self.showmmap = not self.showmmap end
	
	
	--free roaming	
	if editing then
		if key == "kp+" then self.entsel = self.entsel +1 end
		if key == "kp-" then self.entsel = self.entsel -1 end
	
		if key == "delete" then self:removesel() end
		if key == "c" then self:copy() end
		if key == "v" then self:paste() end
		if key == "r" then self:rotate() end
		if key == "e" then self.showentmenu = not self.showentmenu end

		if key == "g" then self.showguide = not self.showguide end
		if key == "x" then self:sendtospawn(player) end
		if key == "," then self.showpos = not self.showpos end
		if key == "." then self.showid = not self.showid end
		if key == "f12" then mapio:savemap(world.map) end
	
		if key == "t" then self:settheme() end
	
		for i, platform in ripairs(platforms) do
			--fix this for moving platform (yorigin,xorigin etc)
			if world:inview(platform) then
				if collision:check(mousePosX,mousePosY,1,1, platform.x,platform.y,platform.w,platform.h) then
					if love.keyboard.isDown("kp8") then 
						platform.y = math.round(platform.y - 10,-1) --up
					end
					if love.keyboard.isDown("kp2") then 
						platform.y = math.round(platform.y + 10,-1) --down
						platform.yorigin = platform.y
					end 
					if love.keyboard.isDown("kp4") then 
						platform.x = math.round(platform.x - 10,-1) --left
						platform.xorigin = platform.x
					end 
					if love.keyboard.isDown("kp6") then 
						platform.x = math.round(platform.x + 10,-1)  --right
						platform.xorigin = platform.x
					end
	
					return true
				end
			end
		end
	end
end

function editor:checkkeys(dt)
		if love.keyboard.isDown("d") or love.keyboard.isDown("right")  then
			player.x = player.x + self.movespeed *dt
		end
		if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			player.x = player.x - self.movespeed *dt
		end
		if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
			player.y = player.y - self.movespeed *dt
		end
		if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
			player.y = player.y + self.movespeed *dt
		end
		
		if love.keyboard.isDown("[") then
			self:adjustent(-1,dt)
		end
		if love.keyboard.isDown("]") then
			self:adjustent(1,dt)
		end
end


function editor:adjustent(dir,dt)
			
	for _,platform in ipairs(platforms) do
		if world:inview(platform) then
			if platform.swing and collision:check(mousePosX,mousePosY,1,1,
				platform.xorigin-platform_link_origin:getWidth()/2, platform.yorigin-platform_link_origin:getHeight()/2,  
				platform_link_origin:getWidth(),platform_link_origin:getHeight()) then

				platform.angle = platform.angle - dir*2 *dt
				if platform.angle > math.pi then platform.angle = math.pi end			
				if platform.angle < 0 then platform.angle = 0 end
				return true
			end

			if platform.movex == 1 and collision:check(mousePosX,mousePosY,1,1,
				platform.xorigin, platform.y, platform.movedist+platform.w, platform.h) then
				platform.movedist = platform.movedist + dir*2
				if platform.movedist < platform.w then platform.movedist = platform.w end
				return true
			end
			if platform.movey == 1 and collision:check(mousePosX,mousePosY,1,1,
				platform.xorigin, platform.yorigin, platform.w, platform.h+platform.movedist) then
				
				platform.movedist = platform.movedist + dir*2
				if platform.movedist < platform.h then platform.movedist = platform.h end
				return true
			end
		end
	end
	
	for _,enemy in ipairs(enemies) do
		if world:inview(enemy) then
			if enemy.movex == 1 and collision:check(mousePosX,mousePosY,1,1,
				enemy.xorigin, enemy.y, enemy.movedist+enemy.w, enemy.h) then
				enemy.movedist = enemy.movedist + dir*2
				if enemy.movedist < enemy.w then enemy.movedist = enemy.w end
				return true
			end
		end
	end
end

function editor:zoom()
	love.audio.play( sound.beep )
	if camera.scaleX == 1 and camera.scaleY == 1 then
		camera.scaleX = 2
		camera.scaleY = 2
	else
		camera.scaleX = 1
		camera.scaleY = 1 
	end
end

function editor:mousepressed(x,y,button)
	
	local x = math.round(pressedPosX,-1)
	local y = math.round(pressedPosY,-1)
	
	-- entity selection with mousescroll
	if button == 'wd' then editor.entsel = editor.entsel +1 end
	if button == 'wu' then editor.entsel = editor.entsel -1 end
	
	if button == 'l' then
		local selection = self:entname(self.entsel)
		
		if selection == "spawn" then
			self:removeall(portals, "spawn")
			portals:add(x,y,"spawn")
		end
		if selection == "goal" then
			self:removeall(portals, "goal")
			portals:add(x,y,"goal")
		end
		
		if selection == "crate" then crates:add(x,y,"gem") end
		if selection == "walker" then enemies:walker(x,y,100,100) end
		if selection == "floater" then enemies:floater(x,y,100,400) end
		if selection == "spikeball" then enemies:spikeball(x,y) end
		if selection == "platform_s" then platforms:add(x,y,1,20,0,0,0,100,0,1,0) end
		if selection == "checkpoint" then checkpoints:add(x,y) end
		if selection == "gem" then pickups:add(x,y,"gem") end
		if selection == "life" then pickups:add(x,y,"life") end
		if selection == "magnet" then pickups:add(x,y,"magnet") end
		if selection == "shield" then pickups:add(x,y,"shield") end
		if selection == "spike" then enemies:spike(x,y,self.entdir) end
		if selection == "spike_large" then enemies:spike_large(x,y,self.entdir) end
		if selection == "icicle" then enemies:icicle(x,y) end
		if selection == "flower" then props:add(x,y,"flower") end
		if selection == "rock" then props:add(x,y,"rock") end
		if selection == "tree" then props:add(x,y,"tree") end
		if selection == "arch" then props:add(x,y,"arch") end
		if selection == "arch2" then props:add(x,y,"arch2") end
		if selection == "pillar" then props:add(x,y,"pillar") end
		if selection == "spring_s" then springs:add(x,y,self.entdir,"spring_s") end
		if selection == "spring_m" then springs:add(x,y,self.entdir,"spring_m") end
		if selection == "spring_l" then springs:add(x,y,self.entdir,"spring_l") end
		
	elseif button == 'r' then
		self:removesel()
	end
end

function editor:mousereleased(x,y,button)
	--check if we have selected platforms, then place if neccesary
	if button == 'l' then 
		local draggable = {"platform", "platform_b", "platform_x", "platform_y", "platform_b_y", "platform_b_x"}
		for _,entity in ipairs(draggable) do
			if self:entname(self.entsel) == entity then
				self:addplatform(pressedPosX,pressedPosY,releasedPosX,releasedPosY)
			end
		end
		return
	end
end


function editor:sendtospawn(entity)
	for _,portal in ipairs(portals) do
		if portal.name == "spawn" then
			entity.x = portal.x
			entity.y = portal.y
			return true
		end
	end
	
	entity.x = 0
	entity.y = 0
	
end

function editor:addplatform(x1,y1,x2,y2)
	local ent = self:entname(self.entsel)

	--we must drag down and right
	if not (x2 < x1 or y2 < y1) then
		--min sizes (we don't want impossible to select/remove platforms)
		if x2-x1 < 20  then x2 = x1 +20 end
		if y2-y1 < 20  then y2 = y1 +20 end

		local x = math.round(x1,-1)
		local y = math.round(y1,-1)
		local w = (x2-x1)
		local h = (y2-y1)
		
		--place the platform
		if ent == "platform" then
			platforms:add(x,y,w,h,1,0,0,0,0)
		end
		
		if ent == "platform_b" then
			platforms:add(x,y,w,h,0,0,0,0,0)
		end
		if ent == "platform_b_x" then
			platforms:add(x,y,w,h,0, 1, 0, 100, 200)
		end
		if ent == "platform_b_y" then
			platforms:add(x,y,w,h,0, 0, 1, 100, 200)
		end
		
		if ent == "platform_x" then
			platforms:add(x,y,w,h,1, 1, 0, 100, 200)
		end
		if ent == "platform_y" then
			platforms:add(x,y,w,h,1, 0, 1, 100, 200)
		end

	end
end

function editor:drawguide()

	if self.showguide then
		love.graphics.setColor(200,200,255,50)
		--vertical
		love.graphics.line(
			math.round(mousePosX,-1),
			math.round(mousePosY+love.graphics.getHeight()*camera.scaleY,-1),
			math.round(mousePosX,-1),
			math.round(mousePosY-love.graphics.getHeight()*camera.scaleY,-1)
		)
		--horizontal
		love.graphics.line(
			math.round(mousePosX-love.graphics.getWidth()*camera.scaleX,-1),
			math.round(mousePosY,-1),
			math.round(mousePosX+love.graphics.getWidth()*camera.scaleX-1),
			math.round(mousePosY,-1)
		)
	end
end

function editor:drawcursor()
	--cursor
	love.graphics.setColor(255,200,255,255)
	love.graphics.line(
		math.round(mousePosX,-1),
		math.round(mousePosY,-1),
		math.round(mousePosX,-1)+10,
		math.round(mousePosY,-1)
	)
	love.graphics.line(
		math.round(mousePosX,-1),
		math.round(mousePosY,-1),
		math.round(mousePosX,-1),
		math.round(mousePosY,-1)+10
	)
	
	cursor = { x =mousePosX, y =mousePosY   }
	util:drawCoordinates(cursor)
	
end


function editor:draw()
	love.graphics.setColor(0,255,155,155)
		
	love.graphics.setFont(fonts.large)
	love.graphics.print("editing",WIDTH-80, 10,0,1,1)
	love.graphics.setFont(fonts.default)
	love.graphics.print("press 'h' for help",WIDTH-115, 30,0,1,1)

	
	if editing then
		camera:set()
	
		self:drawguide()
		self:drawcursor()
		self:drawselected()
		self:drawselbox()
	
		camera:unset()
		if self.showentmenu then self:drawentmenu() end
	end
	
	
	if self.showmmap then self:drawmmap() end
	if self.showhelpmenu then self:drawhelpmenu() end
	
end

function editor:drawselbox()
	--draw an outline when dragging mouse when entsel is one of these types
	if self.drawsel then
		local draggable = { "platform", "platform_b", "platform_b_x", "platform_b_y", "platform_x", "platform_y"}
		for _,entity in ipairs(draggable) do
			if self:entname(self.entsel) == entity then
				love.graphics.setColor(0,255,255,100)
				love.graphics.rectangle(
					"line", 
					pressedPosX,pressedPosY, 
					mousePosX-pressedPosX, mousePosY-pressedPosY
				)
			end
		end
	end
end


function editor:drawhelpmenu()
	
	local menu = love.graphics.newCanvas(self.helpmenuw,self.helpmenuh)
	love.graphics.setCanvas(menu)
	menu:clear()
	
	--frame
	love.graphics.setColor(0,0,0,200)
	love.graphics.rectangle("fill",0,0, menu:getWidth(), menu:getHeight())
	--border
	love.graphics.setColor(255,255,255,150)
	love.graphics.rectangle("fill",0,0, menu:getWidth(), 5)
	--title
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Editor Help",10,10)
	
	--hrule
	love.graphics.setColor(255,255,255,150)
	love.graphics.rectangle("fill",10,25, menu:getWidth()-10, 1)
	
	local s = 15 -- vertical spacing

	
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("[h] to close",menu:getWidth()-110,10,100,"right")
		
	love.graphics.setFont(fonts.menu)

	love.graphics.setColor(155,255,255,155)
	love.graphics.print("f1",10,s*2); 
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("toggle editmode",menu:getWidth()/8,s*2,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("wasd",10,s*3)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("move",menu:getWidth()/8,s*3,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("left mouse",10,s*4)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("select/drag",menu:getWidth()/8,s*4,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("right mouse",10,s*5)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("remove entity",menu:getWidth()/8,s*5,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("mousewheel",10,s*6)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("select entity type",menu:getWidth()/8,s*6,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("r",10,s*7)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("entity direction",menu:getWidth()/8,s*7,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("keypad arrow",10,s*8)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("reposition entity",menu:getWidth()/8,s*8,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("t",10,s*9)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("change theme",menu:getWidth()/8,s*9,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("c",10,s*10)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("copy",menu:getWidth()/8,s*10,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("p",10,s*11)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("paste",menu:getWidth()/8,s*11,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("z",10,s*12)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("camera zoom",menu:getWidth()/8,s*12,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("f12",10,s*13)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("savemap",menu:getWidth()/8,s*13,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("escape",10,s*14)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("exit to title",menu:getWidth()/8,s*14,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("`",10,s*15)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("toggle console",menu:getWidth()/8,s*15,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("g",10,s*16)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("toggle guidelines",menu:getWidth()/8,s*16,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("m",10,s*17)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("toggle minimap",menu:getWidth()/8,s*17,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("h",10,s*18)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("show help",menu:getWidth()/8,s*18,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("x",10,s*19)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("set camera to origin/spawn",menu:getWidth()/8,s*19,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(",",10,s*20)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("toggle co-ord display",menu:getWidth()/8,s*20,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(".",10,s*21)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("toggle id display",menu:getWidth()/8,s*21,200,"right")
	
	love.graphics.setFont(fonts.default)
		
	love.graphics.setCanvas()
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(menu, WIDTH/2-menu:getWidth()/2, HEIGHT/2-menu:getHeight()/2 )
	
	
end


function editor:drawentmenu()
	--gui scrolling list for entity selection
	local menu = love.graphics.newCanvas(self.entmenuw,self.entmenuh)
	love.graphics.setCanvas(menu)
	menu:clear()
		
	--frame
	love.graphics.setColor(0,0,0,150)
	love.graphics.rectangle(
		"fill",0,0, menu:getWidth(), menu:getHeight()
	)
	
	--border
	love.graphics.setColor(255,255,255,150)
	love.graphics.rectangle(
		"fill",0,0, menu:getWidth(), 5
	)
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("entity selection",10,10)
	
	--hrule
	love.graphics.setColor(255,255,255,150)
	love.graphics.rectangle(
		"fill",10,25, menu:getWidth()-10, 1
	)
	
	local s = 15 -- vertical spacing
	local entname = self:entname(self.entsel)
	
	love.graphics.setColor(255,255,255,155)
	love.graphics.setFont(fonts.menu)
	love.graphics.print(self:entname(self.entsel-4),10,s*2)
	love.graphics.print(self:entname(self.entsel-3),10,s*3)
	love.graphics.print(self:entname(self.entsel-2),10,s*4)
	love.graphics.print(self:entname(self.entsel-1),10,s*5)
	
	--selected
	love.graphics.setColor(200,200,200,150)

	love.graphics.rectangle(
		"fill",10,s*6, menu:getWidth()-20, 15
	)
	----------
	
	love.graphics.setColor(0,0,0,255)
	love.graphics.print(self:entname(self.entsel  ),10,s*6)
	
	
	love.graphics.setColor(255,255,255,155)
	love.graphics.print(self:entname(self.entsel+1),10,s*7)
	love.graphics.print(self:entname(self.entsel+2),10,s*8)
	love.graphics.print(self:entname(self.entsel+3),10,s*9)
	love.graphics.print(self:entname(self.entsel+4),10,s*10)
	love.graphics.setFont(fonts.default)
	
	--entdir
	love.graphics.setColor(255,255,255,255)
	local dir
	if self.entdir == 0 then dir = "up" 
		elseif self.entdir == 1 then dir = "down"
		elseif self.entdir == 2 then dir = "right"
		elseif self.entdir == 3 then dir = "left"
	end
	love.graphics.print("entdir: "..dir,10,s*12)
	
	
	
	love.graphics.setCanvas()
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(menu, 10, HEIGHT-menu:getHeight()-10 )
end


function editor:drawselected()
	return self:selection(enemies) or
			self:selection(pickups) or	
			self:selection(portals) or		
			self:selection(crates) or
			self:selection(checkpoints) or
			self:selection(springs) or
			self:selection(props) or
			self:selection(platforms)
end

function editor:selection(entities, x,y,w,h)
	-- hilights the entity when mouseover 
	love.graphics.setColor(0,255,0,200)
	for i, entity in ripairs(entities) do
		if world:inview(entity) then
			if entity.movex == 1 then
				if collision:check(mousePosX,mousePosY,1,1,entity.xorigin, entity.y, entity.movedist+entity.w, entity.h) then
					love.graphics.rectangle("line", entity.xorigin, entity.y, entity.movedist+entity.w, entity.h)
					return true
				end
			elseif entity.movey == 1 then
				if collision:check(mousePosX,mousePosY,1,1,entity.xorigin, entity.yorigin, entity.w, entity.h+entity.movedist) then
					love.graphics.rectangle("line", entity.xorigin, entity.yorigin,entity.w, entity.h+entity.movedist)
					return true
				end
			elseif entity.swing == 1 then
				if collision:check(mousePosX,mousePosY,1,1,
						entity.xorigin-platform_link_origin:getWidth()/2, entity.yorigin-platform_link_origin:getHeight()/2,  
						platform_link_origin:getWidth(),platform_link_origin:getHeight()
					) then
						
						love.graphics.rectangle("line", 
							entity.xorigin-platform_link_origin:getWidth()/2, entity.yorigin-platform_link_origin:getHeight()/2,  
							platform_link_origin:getWidth(),platform_link_origin:getHeight()
						)
						return true
				end
			elseif collision:check(mousePosX,mousePosY,1,1,entity.x,entity.y,entity.w,entity.h) then
					love.graphics.rectangle("line", entity.x,entity.y,entity.w,entity.h)
					return true

			end
		end
	end
end

function editor:removesel()
	return self:remove(enemies) or
			self:remove(pickups) or	
			self:remove(portals) or		
			self:remove(crates) or
			self:remove(checkpoints) or
			self:remove(springs) or
			self:remove(props) or
			self:remove(platforms)
end

function editor:removeall(entities, name)
	--removes all entity types of given entity
	for i, entity in ipairs(entities) do
		if type(entity) == "table" and entity.name == name then

			table.remove(entities,i)
		end
	end
end

function editor:remove(entities, x,y,w,h)
	--deletes the selected entity
	
	for i, entity in ripairs(entities) do
		if world:inview(entity) then
			if entity.movex == 1 then
				if collision:check(mousePosX,mousePosY,1,1,entity.xorigin, entity.y, entity.movedist+entity.w, entity.h) then
					table.remove(entities,i)
					print( entity.name .. " (" .. i .. ") removed" )
					return true
				end
			elseif entity.movey == 1 then
				if collision:check(mousePosX,mousePosY,1,1,entity.xorigin, entity.yorigin, entity.w, entity.h+entity.movedist) then
					print( entity.name .. " (" .. i .. ") removed" )
					table.remove(entities,i)
					return true
				end
				
			elseif entity.swing == 1 then
			
				if collision:check(mousePosX,mousePosY,1,1,
						entity.xorigin-platform_link_origin:getWidth()/2, entity.yorigin-platform_link_origin:getHeight()/2,  
						platform_link_origin:getWidth(),platform_link_origin:getHeight()
					) then
						print( entity.name .. " (" .. i .. ") removed" )
						table.remove(entities,i)
						return true
						
				end
			
			elseif collision:check(mousePosX,mousePosY,1,1, entity.x,entity.y,entity.w,entity.h) then
				print( entity.name .. " (" .. i .. ") removed" )
				table.remove(entities,i)
				return true
			
			end
		end
	end
end


function editor:rotate()
	--set rotation value for the entity
	--four directions, 0,1,2,3 at 90degree angles
	self.entdir = self.entdir +1
	if self.entdir > 3 then
		self.entdir = 0
	end
end

function editor:copy()
	--primitive copy (dimensions only for now)
	for i, platform in ripairs(platforms) do
		if world:inview(platform) then
			if collision:check(mousePosX,mousePosY,1,1, platform.x,platform.y,platform.w,platform.h) then
				self.clipboard = {
					w = platform.w,
					h = platform.h,
					e = self.entsel,
				}
				return true
			end
		end
	end
end

function editor:paste()
	--paste the new entity with copied paramaters
	--
	local x = math.round(mousePosX,-1)
	local y = math.round(mousePosY,-1)
	local w = self.clipboard.w or 20
	local h = self.clipboard.h or 20
	local selection = self:entname(self.entsel)
	if selection == "platform" then
		platforms:add(x,y,w,h,1,0,0,0,0)
	end
	if selection == "platform_b" then
		platforms:add(x,y,w,h,0,0,0,0,0)
	end
	if selection == "platform_b_x" then
		platforms:add(x,y,w,h,1, 1, 0, 100, 200)
	end
	if selection == "platform_b_y" then
		platforms:add(x,y,w,h,1,0, 1, 100, 200)
	end
	if selection == "platform_x" then
		platforms:add(x,y,w,h,0, 1, 0, 100, 200)
	end
	if selection == "platform_y" then
		platforms:add(x,y,w,h,0,0, 1, 100, 200)
	end
end




function editor:drawmmap()
	--experimental! does not work as intended! (but is still useful)
	--fix camera scaling... and remove duplicate code
	self.mmapw = WIDTH/5
	self.mmaph = HEIGHT/5
	self.mmapscale = 15*camera.scaleX
	mmapcanvas = love.graphics.newCanvas( self.mmapw, self.mmaph )
	love.graphics.setCanvas(mmapcanvas)
	mmapcanvas:clear()


	love.graphics.setColor(0,0,0,100)
	love.graphics.rectangle("fill", 0,0,self.mmapw,self.mmaph )
	

	
	for i, platform in ipairs(platforms) do
		if platform.clip == 1 then
			love.graphics.setColor(255,50,0,255)
		else
			love.graphics.setColor(155,0,0,255)
		end
		love.graphics.rectangle(
			"fill", 
			(platform.x/self.mmapscale)-(camera.x/self.mmapscale)+self.mmapw/2, 
			(platform.y/self.mmapscale)-(camera.y/self.mmapscale)+self.mmaph/2, 
			platform.w/self.mmapscale, 
			platform.h/self.mmapscale
		)
	end

	love.graphics.setColor(0,255,255,255)
	for i, crate in ipairs(crates) do
		love.graphics.rectangle(
			"fill", 
			(crate.x/self.mmapscale)-camera.x/self.mmapscale+self.mmapw/2, 
			(crate.y/self.mmapscale)-camera.y/self.mmapscale+self.mmaph/2, 
			crate.w/self.mmapscale, 
			crate.h/self.mmapscale
		)
	end
	
	love.graphics.setColor(255,0,255,255)
	for i, enemy in ipairs(enemies) do
		love.graphics.rectangle(
			"line", 
			(enemy.x/self.mmapscale)-camera.x/self.mmapscale+self.mmapw/2, 
			(enemy.y/self.mmapscale)-camera.y/self.mmapscale+self.mmaph/2, 
			enemy.w/self.mmapscale, 
			enemy.h/self.mmapscale
		)
	end
	
	love.graphics.setColor(255,255,100,255)
	for i, pickup in ipairs(pickups) do
		love.graphics.rectangle(
			"line", 
			(pickup.x/self.mmapscale)-camera.x/self.mmapscale+self.mmapw/2, 
			(pickup.y/self.mmapscale)-camera.y/self.mmapscale+self.mmaph/2, 
			pickup.w/self.mmapscale, 
			pickup.h/self.mmapscale
		)
	end
	
	love.graphics.setColor(0,255,0,255)
	for i, checkpoint in ipairs(checkpoints) do
		love.graphics.rectangle(
			"fill", 
			(checkpoint.x/self.mmapscale)-camera.x/self.mmapscale+self.mmapw/2, 
			(checkpoint.y/self.mmapscale)-camera.y/self.mmapscale+self.mmaph/2, 
			checkpoint.w/self.mmapscale, 
			checkpoint.h/self.mmapscale
		)
	end

	love.graphics.setColor(0,255,0,255)
	for i, spring in ipairs(springs) do
		love.graphics.rectangle(
			"fill", 
			(spring.x/self.mmapscale)-camera.x/self.mmapscale+self.mmapw/2, 
			(spring.y/self.mmapscale)-camera.y/self.mmapscale+self.mmaph/2, 
			spring.w/self.mmapscale, 
			spring.h/self.mmapscale
		)
	end


	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle(
		"line", 
		(player.x/self.mmapscale)-(camera.x/self.mmapscale)+self.mmapw/2, 
		(player.y/self.mmapscale)-(camera.y/self.mmapscale)+self.mmaph/2, 
		player.w/self.mmapscale, 
		player.h/self.mmapscale
	)
	

	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(mmapcanvas, WIDTH-10-self.mmapw,love.graphics.getHeight()-10-self.mmaph )

end
