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
	editor binds (see binds.lua) or
	https://github.com/Jigoku/boxclip/wiki/Controls#editor-controls
	
	some may be undocumented, check this when adding help menu for editor
--]]

editor = {}
editing = false


editor.mouse = {
	x = 0,
	y = 0,
	pressed  = { x=0, y=0 },
	released = { x=0, y=0 }
}

editor.entdir = 0 			--(used for some entites 0,1,2,3 = up,down,right,left)
editor.entsel = 1			--current entity id for placement
editor.themesel = 1			--theme pallete in use
editor.texturesel = 1		--texture slot to use for platforms
editor.showpos = true		--axis info for entitys
editor.showid  = true		--id info for entities
editor.showmmap = true	    --toggle minimap
editor.showguide = true     --toggle guidelines
editor.showentmenu = true   --toggle entmenu
editor.showhelpmenu = false  --toggle helpmenu
editor.showmusicbrowser = false --toggle musicbrowser
editor.drawsel = false		--selection outline
editor.floatspeed = 1000		--editing floatspeed
editor.maxcamerascale = 8   --maximum zoom
editor.mincamerascale = 0.4 --minimum zoom

editor.mmapw = 200
editor.mmaph = 200
editor.mmapscale = 15*camera.scaleX
editor.mmapcanvas = love.graphics.newCanvas( editor.mmapw, editor.mmaph )

	
editor.entmenuw = 150       --entmenu width
editor.entmenuh = 300		--entmenu height
editor.entmenu = love.graphics.newCanvas(editor.entmenuw,editor.entmenuh)
	
editor.helpmenuw = 240
editor.helpmenuh = 400
editor.helpmenu = love.graphics.newCanvas(editor.helpmenuw,editor.helpmenuh)

editor.clipboard = {}		--clipboard contents


--order of entities in entmenu
editor.entities = {
	"spawn",
	"goal",
	"platform" ,
	"platform_b" ,
	"platform_x" ,
	"platform_y" ,
	"platform_s" ,
	"log",
	"bridge",
	"brick",
	"water",
	"stream",
	"lava",
	"blood",
	"death",
	"checkpoint" ,
	"crate" ,
	"spike",
	"spike_large",
	"icicle" ,
	"walker",
	"floater", 
	"spikeball" ,
	"gem" ,
	"life",
	"magnet", 
	"shield" ,
	"flower" ,
	"grass" ,
	"rock",
	"tree" ,
	"arch" ,
	"arch2",
	"arch3",
	"arch3_end_l",
	"arch3_end_r",
	"arch3_pillar",
	"porthole",
	"mesh",
	"girder",
	"pillar", 
	"spring_s",
	"spring_m" ,
	"spring_l",
	"bumper",
}

--entities which are draggable (size placement)
editor.draggable = {
	"platform", "platform_b", "platform_x", "platform_y", 
	"blood", "lava", "water", "stream", 
	"death" 
}


editor.themes = {
	"default",
	"sunny",
	"neon",
	"frost",
	"hell",
	"mist",
	"dust",
	"swamp",
	"night"
}

function editor:settexture(platform)
	print(self.texturesel)
	for _,p in ipairs(platforms) do
		if p.selected then
			p.texture = self.texturesel
			p.selected = false
		end
	end
end

function editor:settheme()
	world.theme = self.themes[self.themesel]

	world:settheme(world.theme)
	
	--update themeable textures
	for i,e in ipairs(enemies) do 
		if e.name == "spike" then e.gfx = spike_gfx end
		if e.name == "spike_large" then e.gfx = spike_large_gfx end
		if e.name == "icicle" then e.gfx = icicle_gfx end
	end
	self.themesel = self.themesel +1
	if self.themesel > #self.themes then self.themesel = 1 end
	
end

function editor:keypressed(key)
	if key == editbinds.edittoggle then 
		editing = not editing
		player.xvel = 0
		player.yvel = 0
		player.angle = 0
		player.jumping = false
		player.xvelboost = 0
	end

	if key == editbinds.helptoggle then self.showhelpmenu = not self.showhelpmenu end	
	if key == editbinds.maptoggle then self.showmmap = not self.showmmap end
	if key == editbinds.musicbrowser then self.showmusicbrowser = not self.showmusicbrowser end
		
	
	--free roaming	
	if editing then
		if key == editbinds.entselup then self.entsel = self.entsel +1 end
		if key == editbinds.entseldown then self.entsel = self.entsel -1 end
	
		if key == editbinds.delete then self:removesel() end
		if key == editbinds.entcopy then self:copy() end
		if key == editbinds.entpaste then self:paste() end
		if key == editbinds.entrotate then self:rotate() end
		if key == editbinds.entmenutoggle then self.showentmenu = not self.showentmenu end

		if key == editbinds.guidetoggle then self.showguide = not self.showguide end
		if key == editbinds.respawn then self:sendtospawn(player) end
		if key == editbinds.showpos then self.showpos = not self.showpos end
		if key == editbinds.showid then self.showid = not self.showid end
		if key == editbinds.savemap then mapio:savemap(world.map) end
	
		if key == editbinds.musicprev then 
			if world.mapmusic == 0 then 
				world.mapmusic = #sound.music
			else
				world.mapmusic = world.mapmusic -1
			end
		
			sound:playbgm(world.mapmusic)
			sound:playambient(world.mapambient)	
		end
		
		if key == editbinds.musicnext then 
			if world.mapmusic == #sound.music then 
				world.mapmusic = 0 
			else
				world.mapmusic = world.mapmusic +1
			end
			
			sound:playbgm(world.mapmusic)
			sound:playambient(world.mapambient)	
		end
	
		if key == editbinds.themecycle then self:settheme() end
	
		for i, platform in ripairs(platforms) do
			--fix this for moving platform (yorigin,xorigin etc)
			if world:inview(platform) then
				if collision:check(self.mouse.x,self.mouse.y,1,1, platform.x,platform.y,platform.w,platform.h) then
					if love.keyboard.isDown(editbinds.moveup) then 
						platform.y = math.round(platform.y - 10,-1) --up
					end
					if love.keyboard.isDown(editbinds.movedown) then 
						platform.y = math.round(platform.y + 10,-1) --down
						platform.yorigin = platform.y
					end 
					if love.keyboard.isDown(editbinds.moveleft) then 
						platform.x = math.round(platform.x - 10,-1) --left
						platform.xorigin = platform.x
					end 
					if love.keyboard.isDown(editbinds.moveright) then 
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

		if love.keyboard.isDown(editbinds.right)  then
			player.x = player.x + self.floatspeed *camera.scaleX *dt
		end
		if love.keyboard.isDown(editbinds.left)  then
			player.x = player.x - self.floatspeed *camera.scaleX *dt
		end
		if love.keyboard.isDown(editbinds.up) then
			player.y = player.y - self.floatspeed *camera.scaleY *dt
		end
		if love.keyboard.isDown(editbinds.down) then
			player.y = player.y + self.floatspeed *camera.scaleY *dt
		end
		
		if love.keyboard.isDown(editbinds.decrease) then
			self:adjustent(-1,dt)
		end
		if love.keyboard.isDown(editbinds.increase) then
			self:adjustent(1,dt)
		end
end


function editor:adjustent(dir,dt)
			
	for _,platform in ipairs(platforms) do
		if world:inview(platform) then
			if platform.swing and collision:check(self.mouse.x,self.mouse.y,1,1,
				platform.xorigin-platform_link_origin:getWidth()/2, platform.yorigin-platform_link_origin:getHeight()/2,  
				platform_link_origin:getWidth(),platform_link_origin:getHeight()) then

				platform.angle = platform.angle - dir*2 *dt
				if platform.angle > math.pi then platform.angle = math.pi end			
				if platform.angle < 0 then platform.angle = 0 end
				return true
			end

			if platform.movex == 1 and collision:check(self.mouse.x,self.mouse.y,1,1,
				platform.xorigin, platform.y, platform.movedist+platform.w, platform.h) then
				platform.movedist = math.round(platform.movedist + dir*2,1)
				if platform.movedist < platform.w then platform.movedist = platform.w end
				return true
			end
			if platform.movey == 1 and collision:check(self.mouse.x,self.mouse.y,1,1,
				platform.xorigin, platform.yorigin, platform.w, platform.h+platform.movedist) then
				
				platform.movedist = math.round(platform.movedist + dir*2,1)
				if platform.movedist < platform.h then platform.movedist = platform.h end
				return true
			end
		end
	end
	
	for _,enemy in ipairs(enemies) do
		if world:inview(enemy) then
			if enemy.movex == 1 and collision:check(self.mouse.x,self.mouse.y,1,1,
				enemy.xorigin, enemy.y, enemy.movedist+enemy.w, enemy.h) then
				enemy.movedist = enemy.movedist + dir*2
				if enemy.movedist < enemy.w then enemy.movedist = enemy.w end
				return true
			end
		end
	end
end

function editor:wheelmoved(x, y)
    
    
    if love.keyboard.isDown("lctrl") then
		if y > 0 then
			if camera.scaleX > self.mincamerascale then
				camera.scaleX = camera.scaleX - 0.1
				camera.scaleY = camera.scaleY - 0.1
			else
				camera.scaleX = self.mincamerascale
				camera.scaleY = self.mincamerascale
			end
		elseif y < 0 then
			if camera.scaleX < self.maxcamerascale then
				camera.scaleX = camera.scaleX + 0.1
				camera.scaleY = camera.scaleY + 0.1
			else
				camera.scaleX = self.maxcamerascale
				camera.scaleY = self.maxcamerascale
			end
		end
	elseif love.keyboard.isDown("y") then
	
		if y > 0 then
			self.texturesel = self.texturesel -1
		elseif y < 0 then
			self.texturesel = self.texturesel +1
		end
		if self.texturesel > #platforms.textures then self.texturesel = 1 end
		if self.texturesel < 1 then self.texturesel = #platforms.textures end
		
		self:settexture(p)
		
	else
		if y > 0 then
			editor.entsel = editor.entsel -1
		elseif y < 0 then
			editor.entsel = editor.entsel +1
		end
	end
end

function editor:mousepressed(x,y,button)
	if not editing then return end
	
	self.mouse.pressed.x = math.round(camera.x-(game.width/2*camera.scaleX)+x*camera.scaleX,-1)
	self.mouse.pressed.y = math.round(camera.y-(game.height/2*camera.scaleY)+y*camera.scaleX,-1)
	
	
	local x = math.round(self.mouse.pressed.x,-1)
	local y = math.round(self.mouse.pressed.y,-1)
	

	
	
	
	if button == 1 then
		local selection = self.entities[self.entsel]
		
		if selection == "spawn" then
			self:removeall(portals, "spawn")
			portals:add(x,y,"spawn")
		end
		if selection == "goal" then
			self:removeall(portals, "goal")
			portals:add(x,y,"goal")
		end
		
		if selection == "crate" then crates:add(x,y,"gem") end
		
		if selection == "walker" then enemies:add(x,y,100,100,0,"walker") end
		if selection == "floater" then enemies:add(x,y,100,400,0,"floater") end
		if selection == "spikeball" then enemies:add(x,y,0,0,0,"spikeball") end
		if selection == "spike" then enemies:add(x,y,0,0,self.entdir,"spike") end
		if selection == "spike_large" then enemies:add(x,y,0,0,self.entdir,"spike_large") end
		if selection == "icicle" then enemies:add(x,y,0,0,0,"icicle") end
		
		if selection == "platform_s" then platforms:add(x,y,1,20,0,0,0,2,0,1,0) end
		
		if selection == "checkpoint" then checkpoints:add(x,y) end
		
		if selection == "gem" then pickups:add(x,y,"gem") end
		if selection == "life" then pickups:add(x,y,"life") end
		if selection == "magnet" then pickups:add(x,y,"magnet") end
		if selection == "shield" then pickups:add(x,y,"shield") end

		if selection == "log" then traps:add(x,y,"log") end
		if selection == "bridge" then traps:add(x,y,"bridge") end
		if selection == "brick" then traps:add(x,y,"brick") end
		
		if selection == "flower" then props:add(x,y,"flower") end
		if selection == "grass" then props:add(x,y,"grass") end
		if selection == "rock" then props:add(x,y,"rock") end
		if selection == "tree" then props:add(x,y,"tree") end
		if selection == "arch" then props:add(x,y,"arch") end
		if selection == "arch2" then props:add(x,y,"arch2") end
		if selection == "arch3" then props:add(x,y,"arch3") end
		if selection == "arch3_end_l" then props:add(x,y,"arch3_end_l") end
		if selection == "arch3_end_r" then props:add(x,y,"arch3_end_r") end
		if selection == "arch3_pillar" then props:add(x,y,"arch3_pillar") end
		if selection == "porthole" then props:add(x,y,"porthole") end
		if selection == "mesh" then props:add(x,y,"mesh") end
		if selection == "pillar" then props:add(x,y,"pillar") end
		if selection == "girder" then props:add(x,y,"girder") end
		
		if selection == "spring_s" then springs:add(x,y,self.entdir,"spring_s") end
		if selection == "spring_m" then springs:add(x,y,self.entdir,"spring_m") end
		if selection == "spring_l" then springs:add(x,y,self.entdir,"spring_l") end
		
		if selection == "bumper" then bumpers:add(x,y) end
		
		
	elseif button == 2 then
		self:removesel()
	end
end

function editor:mousereleased(x,y,button)
	--check if we have selected draggable entity, then place if neccesary
	if not editing then return end
	
	self.mouse.released.x = math.round(camera.x-(game.width/2*camera.scaleX)+x*camera.scaleX,-1)
	self.mouse.released.y = math.round(camera.y-(game.height/2*camera.scaleY)+y*camera.scaleX,-1)
	
	
	editor.drawsel = false

	if button == 1 then 
		for _,entity in ipairs(self.draggable) do
			if self.entities[self.entsel] == entity then
				self:placedraggable(self.mouse.pressed.x,self.mouse.pressed.y,self.mouse.released.x,self.mouse.released.y)
			end
		end
		return
	end
	
	if button == 3 then
		local entities = {enemies,pickups,portals,crates,checkpoints,springs,props,platforms,decals,traps}
		for _,entitytype in ripairs(entities) do
		
		for i,entity in ripairs(entitytype) do
			if world:inview(entity) then
				if entity.movex == 1 then
					if collision:check(self.mouse.x,self.mouse.y,1,1,entity.xorigin, entity.y, entity.movedist+entity.w, entity.h) then
						world:sendtoback(entitytype,i)
						
						return true
					end
				elseif entity.movey == 1 then
					if collision:check(self.mouse.x,self.mouse.y,1,1,entity.xorigin, entity.yorigin, entity.w, entity.h+entity.movedist) then
					
						world:sendtoback(entitytype,i)
						return true
					end
				
				elseif entity.swing == 1 then
				
					if collision:check(self.mouse.x,self.mouse.y,1,1,
							entity.xorigin-platform_link_origin:getWidth()/2, entity.yorigin-platform_link_origin:getHeight()/2,  
							platform_link_origin:getWidth(),platform_link_origin:getHeight()
						) then
						
							world:sendtoback(entitytype,i)
							return true
						
					end
			
				elseif collision:check(self.mouse.x,self.mouse.y,1,1, entity.x,entity.y,entity.w,entity.h) then

					world:sendtoback(entitytype,i)
					return true
			
				end

			end
		end
		end
	end
end




function editor:sendtospawn(entity)
	
	for _,portal in ipairs(portals) do
		if portal.name == "spawn" then
			entity.x = portal.x
			entity.y = portal.y
			camera.scaleX = camera.defaultscale
			camera.scaleY = camera.defaultscale
			return true
		end
	end
	
	entity.x = 0
	entity.y = 0
	
end



function editor:placedraggable(x1,y1,x2,y2)
	local ent = self.entities[self.entsel]

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
		if ent == "platform" then platforms:add(x,y,w,h,1,0,0,0,0,0,0,self.texturesel) end
		if ent == "platform_b" then platforms:add(x,y,w,h,0,0,0,0,0,0,0,self.texturesel) end
		if ent == "platform_x" then platforms:add(x,y,w,h,0,1,0,100,200,0,0,self.texturesel) end
		if ent == "platform_y" then platforms:add(x,y,w,h,0,0,1,100,200,0,0,self.texturesel) end
		
		if ent == "blood" then decals:add(x,y,w,h,"blood") end
		if ent == "lava" then decals:add(x,y,w,h,"lava") end
		if ent == "water" then decals:add(x,y,w,h,"water") end
		if ent == "stream" then decals:add(x,y,w,h,"stream") end
		
		if ent == "death" then materials:add(x,y,w,h,"death") end
	end
end

function editor:drawguide()

	if self.showguide then
		love.graphics.setColor(200,200,255,50)
		--vertical
		love.graphics.line(
			math.round(self.mouse.x,-1),
			math.round(self.mouse.y+love.graphics.getHeight()*camera.scaleY,-1),
			math.round(self.mouse.x,-1),
			math.round(self.mouse.y-love.graphics.getHeight()*camera.scaleY,-1)
		)
		--horizontal
		love.graphics.line(
			math.round(self.mouse.x-love.graphics.getWidth()*camera.scaleX,-1),
			math.round(self.mouse.y,-1),
			math.round(self.mouse.x+love.graphics.getWidth()*camera.scaleX-1),
			math.round(self.mouse.y,-1)
		)
	end
end

function editor:drawcursor()
	--cursor
	love.graphics.setColor(255,200,255,255)
	love.graphics.line(
		math.round(self.mouse.x,-1),
		math.round(self.mouse.y,-1),
		math.round(self.mouse.x,-1)+10,
		math.round(self.mouse.y,-1)
	)
	love.graphics.line(
		math.round(self.mouse.x,-1),
		math.round(self.mouse.y,-1),
		math.round(self.mouse.x,-1),
		math.round(self.mouse.y,-1)+10
	)
	
	local cursor = { x =self.mouse.x, y =self.mouse.y   }
	self:drawCoordinates(cursor)
	
end


function editor:draw()
	love.graphics.setColor(0,255,155,155)
		
	love.graphics.setFont(fonts.large)
	love.graphics.print("editing",game.width-80, 10,0,1,1)
	love.graphics.setFont(fonts.default)
	love.graphics.print("press 'h' for help",game.width-115, 30,0,1,1)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("active selection:",game.width-115, 65,0,1,1)
	love.graphics.print(editor.selname or "",game.width-115, 80,0,1,1)
	
	if editing then
		camera:set()
	
		self:drawguide()
		self:drawcursor()
		self:drawselected()
		self:drawselbox()
	
		camera:unset()
		if self.showentmenu then self:drawentmenu() end
		
		--notify keybind for spawn position
		if world.collision == 0 then
			love.graphics.setColor(255,255,255,255)
			love.graphics.setFont(fonts.menu)
			love.graphics.print("(Tip: press \"".. editbinds.respawn .. "\" to reset camera)", 200, game.height-50,0,1,1)
			love.graphics.setFont(fonts.default)
		end
	end
	

	
	if self.showmmap then self:drawmmap() end
	if self.showhelpmenu then self:drawhelpmenu() end
	if self.showmusicbrowser then musicbrowser:draw() end
end

function editor:drawselbox()
	--draw an outline when dragging mouse when entsel is one of these types
	if self.drawsel then
		for _,entity in ipairs(self.draggable) do
			if self.entities[self.entsel] == entity then
				love.graphics.setColor(0,255,255,100)
				love.graphics.rectangle(
					"line", 
					self.mouse.pressed.x,self.mouse.pressed.y, 
					self.mouse.x-self.mouse.pressed.x, self.mouse.y-self.mouse.pressed.y
				)
			end
		end
	end
end


function editor:drawhelpmenu()
	
	
	love.graphics.setCanvas(self.helpmenu)
	love.graphics.clear()
	
	--frame
	love.graphics.setColor(0,0,0,200)
	love.graphics.rectangle("fill",0,0, self.helpmenu:getWidth(), self.helpmenu:getHeight())
	--border
	love.graphics.setColor(255,255,255,150)
	love.graphics.rectangle("fill",0,0, self.helpmenu:getWidth(), 5)
	--title
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Editor Help",10,10)
	
	--hrule
	love.graphics.setColor(255,255,255,150)
	love.graphics.rectangle("fill",10,25, self.helpmenu:getWidth()-10, 1)
	
	local s = 15 -- vertical spacing

	
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("["..editbinds.helptoggle.."] to close",self.helpmenu:getWidth()-110,10,100,"right")
		
	love.graphics.setFont(fonts.menu)

	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.edittoggle,10,s*2); 
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("toggle editmode",self.helpmenu:getWidth()/8,s*2,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.up..","..editbinds.left..","..editbinds.down..","..editbinds.right ,10,s*3)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("move",self.helpmenu:getWidth()/8,s*3,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("left mouse",10,s*4)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("select/drag",self.helpmenu:getWidth()/8,s*4,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("right mouse",10,s*5)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("remove entity",self.helpmenu:getWidth()/8,s*5,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print("mousewheel",10,s*6)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("select entity type",self.helpmenu:getWidth()/8,s*6,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.entrotate,10,s*7)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("entity direction",self.helpmenu:getWidth()/8,s*7,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.moveup..","..editbinds.moveleft..","..editbinds.movedown..","..editbinds.moveright,10,s*8)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("reposition entity",self.helpmenu:getWidth()/8,s*8,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.themecycle,10,s*9)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("change theme",self.helpmenu:getWidth()/8,s*9,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.entcopy,10,s*10)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("copy",self.helpmenu:getWidth()/8,s*10,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.entpaste,10,s*11)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("paste",self.helpmenu:getWidth()/8,s*11,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.savemap,10,s*13)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("savemap",self.helpmenu:getWidth()/8,s*13,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(binds.exit,10,s*14)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("exit to title",self.helpmenu:getWidth()/8,s*14,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(binds.debug,10,s*15)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("toggle console",self.helpmenu:getWidth()/8,s*15,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.guidetoggle,10,s*16)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("toggle guidelines",self.helpmenu:getWidth()/8,s*16,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.maptoggle,10,s*17)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("toggle minimap",self.helpmenu:getWidth()/8,s*17,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.helptoggle,10,s*18)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("show help",self.helpmenu:getWidth()/8,s*18,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.respawn,10,s*19)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("set camera to origin/spawn",self.helpmenu:getWidth()/8,s*19,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.showpos,10,s*20)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("toggle co-ord display",self.helpmenu:getWidth()/8,s*20,200,"right")
	
	love.graphics.setColor(155,255,255,155)
	love.graphics.print(editbinds.showid,10,s*21)
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("toggle id display",self.helpmenu:getWidth()/8,s*21,200,"right")
	
	love.graphics.setFont(fonts.default)
		
	love.graphics.setCanvas()
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.helpmenu, game.width/2-self.helpmenu:getWidth()/2, game.height/2-self.helpmenu:getHeight()/2 )
	
	
end


function editor:drawentmenu()
	--gui scrolling list for entity selection

	love.graphics.setCanvas(self.entmenu)
	love.graphics.clear()
		
	--frame
	love.graphics.setColor(0,0,0,150)
	love.graphics.rectangle(
		"fill",0,0, self.entmenu:getWidth(), self.entmenu:getHeight()
	)
	
	--border
	love.graphics.setColor(255,255,255,150)
	love.graphics.rectangle(
		"fill",0,0, self.entmenu:getWidth(), 5
	)
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("entity selection",10,10)
	
	--hrule
	love.graphics.setColor(255,255,255,150)
	love.graphics.rectangle(
		"fill",10,25, self.entmenu:getWidth()-10, 1
	)
	
	local s = 15 -- vertical spacing
	local entname = self.entities[self.entsel]
	
	love.graphics.setColor(255,255,255,155)
	love.graphics.setFont(fonts.menu)
	love.graphics.print(self.entities[self.entsel-4] or "-----",10,s*2)
	love.graphics.print(self.entities[self.entsel-3] or "-----",10,s*3)
	love.graphics.print(self.entities[self.entsel-2] or "-----",10,s*4)
	love.graphics.print(self.entities[self.entsel-1] or "-----",10,s*5)
	
	--selected
	love.graphics.setColor(200,200,200,150)

	love.graphics.rectangle(
		"fill",10,s*6, self.entmenu:getWidth()-20, 15
	)
	----------
	
	love.graphics.setColor(0,0,0,255)
	love.graphics.print(self.entities[self.entsel] or "-----",10,s*6)
	
	
	love.graphics.setColor(255,255,255,155)
	love.graphics.print(self.entities[self.entsel+1] or "-----",10,s*7)
	love.graphics.print(self.entities[self.entsel+2] or "-----",10,s*8)
	love.graphics.print(self.entities[self.entsel+3] or "-----",10,s*9)
	love.graphics.print(self.entities[self.entsel+4] or "-----",10,s*10)
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
	love.graphics.draw(self.entmenu, 10, game.height-self.entmenu:getHeight()-10 )
end


function editor:drawselected()
	local entities = {enemies,pickups,portals,crates,checkpoints,springs,props,platforms,decals,traps}
	for _,e in ipairs(entities) do
		self:selection(e)
	end
end

function editor:selection(entities, x,y,w,h)
	-- hilights the entity when mouseover 
	editor.selname = "null"
	love.graphics.setColor(0,255,0,200)
	
	if love.mouse.isDown(3) then return end
	
	for i, entity in ripairs(entities) do
		entity.selected = false
		
		if world:inview(entity) then
			
			if entity.movex == 1 then
				if collision:check(self.mouse.x,self.mouse.y,1,1,entity.xorigin, entity.y, entity.movedist+entity.w, entity.h) then
					love.graphics.rectangle("line", entity.xorigin, entity.y, entity.movedist+entity.w, entity.h)
					editor.selname = entity.name .. "("..i..")"
					entity.selected = true
					return true
				end
			elseif entity.movey == 1 then
				if collision:check(self.mouse.x,self.mouse.y,1,1,entity.xorigin, entity.yorigin, entity.w, entity.h+entity.movedist) then
					love.graphics.rectangle("line", entity.xorigin, entity.yorigin,entity.w, entity.h+entity.movedist)
					editor.selname = entity.name .. "("..i..")"
					entity.selected = true
					return true
				end
			elseif entity.swing == 1 then
				if collision:check(self.mouse.x,self.mouse.y,1,1,
						entity.xorigin-platform_link_origin:getWidth()/2, entity.yorigin-platform_link_origin:getHeight()/2,  
						platform_link_origin:getWidth(),platform_link_origin:getHeight()
					) then
						
						love.graphics.rectangle("line", 
							entity.xorigin-platform_link_origin:getWidth()/2, entity.yorigin-platform_link_origin:getHeight()/2,  
							platform_link_origin:getWidth(),platform_link_origin:getHeight()
						)
						editor.selname = entity.name .. "("..i..")"
						entity.selected = true
						return true
				end
			elseif collision:check(self.mouse.x,self.mouse.y,1,1,entity.x,entity.y,entity.w,entity.h) then
					love.graphics.rectangle("line", entity.x,entity.y,entity.w,entity.h)
					editor.selname = entity.name .. "("..i..")"
					entity.selected = true
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
			self:remove(bumpers) or 
			self:remove(traps) or
			self:remove(platforms) or
			self:remove(decals) or 
			self:remove(props) or
			self:remove(materials) 
			
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
				if collision:check(self.mouse.x,self.mouse.y,1,1,entity.xorigin, entity.y, entity.movedist+entity.w, entity.h) then
					table.remove(entities,i)
					print( entity.name .. " (" .. i .. ") removed" )
					return true
				end
			elseif entity.movey == 1 then
				if collision:check(self.mouse.x,self.mouse.y,1,1,entity.xorigin, entity.yorigin, entity.w, entity.h+entity.movedist) then
					print( entity.name .. " (" .. i .. ") removed" )
					table.remove(entities,i)
					return true
				end
				
			elseif entity.swing == 1 then
			
				if collision:check(self.mouse.x,self.mouse.y,1,1,
						entity.xorigin-platform_link_origin:getWidth()/2, entity.yorigin-platform_link_origin:getHeight()/2,  
						platform_link_origin:getWidth(),platform_link_origin:getHeight()
					) then
						print( entity.name .. " (" .. i .. ") removed" )
						table.remove(entities,i)
						return true
						
				end
			
			elseif collision:check(self.mouse.x,self.mouse.y,1,1, entity.x,entity.y,entity.w,entity.h) then
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
			if collision:check(self.mouse.x,self.mouse.y,1,1, platform.x,platform.y,platform.w,platform.h) then
				self.clipboard = {
					w = platform.w,
					h = platform.h,
					m = platform.movedist,
					s = platform.movespeed,
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
	local x = math.round(self.mouse.x,-1)
	local y = math.round(self.mouse.y,-1)
	local w = self.clipboard.w or 20
	local h = self.clipboard.h or 20
	local m = self.clipboard.m or 0
	local s = self.clipboard.s or 0
	local selection = self.entities[self.entsel]
	if selection == "platform" then
		platforms:add(x,y,w,h,1,0,0,0,0)
	end
	if selection == "platform_b" then
		platforms:add(x,y,w,h,0,0,0,0,0)
	end
	if selection == "platform_x" then
		platforms:add(x,y,w,h,0, 1, 0,s,m)
	end
	if selection == "platform_y" then
		platforms:add(x,y,w,h,0,0, 1,s,m)
	end
end




function editor:drawmmap()
	
	love.graphics.setCanvas(self.mmapcanvas)
	love.graphics.clear()


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
	love.graphics.draw(self.mmapcanvas, game.width-10-self.mmapw,love.graphics.getHeight()-10-self.mmaph )

end



function editor:drawid(entity,i)
	if editor.showid then
		love.graphics.setColor(255,255,0,100)       
		love.graphics.print(entity.name .. "(" .. i .. ")", entity.x-20, entity.y-40, 0)
	end
end

function editor:drawCoordinates(object)
	if editor.showpos then
		love.graphics.setColor(255,255,255,100)
		love.graphics.print("X:".. object.x ..",Y:" .. object.y , object.x-20,object.y-20,0)  
	end
end


function editor:mousemoved(x,y,dx,dy)
	if not editing then return end

	self.mouse.x = math.round(camera.x-(game.width/2*camera.scaleX)+x*camera.scaleX,-1)
	self.mouse.y = math.round(camera.y-(game.height/2*camera.scaleY)+y*camera.scaleX,-1)

	if love.mouse.isDown(1) then
		editor.drawsel = true
	else
		editor.drawsel = false
	end

end
