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

--[[
	editor binds (see editbinds.lua) or
	https://github.com/Jigoku/boxclip/wiki/Controls#editor-controls

	some may be undocumented, check this when adding help menu for editor
--]]

editor = {}
editing = false
require "editor/editbinds"

editor.mouse = {
	x = 0,
	y = 0,
	pressed  = { x=0, y=0 },
	released = { x=0, y=0 },
	old_pos  = { x=0, y=0 },

	--cursor drawing
	hotspotx = 6, --hotspot offset for image
	hotspoty = 4,
	cursors = textures:load("data/images/editor/cursor/"),
	cur = 1, --default cursor
}

-- Editor selection save
editor.is_selected = false
editor.entity_selected = {}

--editor settings
editor.entdir = 0				--rotation placement 0,1,2,3 = up,right,down,left
editor.entsel = 1				--current entity id for placement
editor.themesel = 1				--world theme/pallete
editor.texturesel = 1			--texture slot to use for platforms
editor.showinfo = true			--display coordinates of entities
editor.showmmap = true			--show minimap
editor.showgrid = true			--show guidelines/grid
editor.showentmenu = true		--show entmenu
editor.showhelpmenu = false		--show helpmenu
editor.drawsel = false			--draw selection area
editor.floatspeed = 1000		--editing floatspeed
editor.maxcamerascale = 6		--maximum zoom
editor.mincamerascale = 0.1		--minimum zoom
editor.placing = false			--check if an entity is being placed
editor.entsizemin = 20			--minimum grid size per draggable entity

--misc textures
editor.errortex = love.graphics.newImage("data/images/editor/error.png")
editor.bullettex = love.graphics.newImage("data/images/editor/bullet.png")

-- minimap
editor.mmapw = love.graphics.getWidth()/3
editor.mmaph = love.graphics.getHeight()/3
editor.mmapscale = camera.scale/2
editor.mmapcanvas = love.graphics.newCanvas( editor.mmapw, editor.mmaph )

-- entity selection menu
editor.entmenuw = 150
editor.entmenuh = 300
editor.entmenu = love.graphics.newCanvas(editor.entmenuw,editor.entmenuh)

-- help menu
editor.helpmenuw = 460
editor.helpmenuh = 600
editor.helpmenu = love.graphics.newCanvas(editor.helpmenuw,editor.helpmenuh)

-- texture preview
editor.texmenutexsize = 75
editor.texmenupadding = 10
editor.texmenuoffset = 2
editor.texmenutimer = 0
editor.texmenuduration = 2
editor.texmenuopacity = 0
editor.texmenufadespeed = 5
editor.texmenuw = editor.texmenutexsize+(editor.texmenupadding*2)
editor.texmenuh = (editor.texmenutexsize*(editor.texmenuoffset*2+1))+(editor.texmenupadding*(editor.texmenuoffset*2))+(editor.texmenupadding*2)
editor.texmenu = love.graphics.newCanvas(editor.texmenuw,editor.texmenuh)
editor.texlist = {}

-- music track preview
editor.musicmenu = love.graphics.newCanvas(150,50)
editor.musicmenupadding = 10
editor.musicmenuopacity = 0
editor.musicmenufadespeed = 5
editor.musicmenutimer = 0
editor.musicmenuduration = 4

--placable entities listed in entmenu
--these are defined at top of entities/*.lua
editor.entities = {}


-- allow themes to be added by simply placing a theme.lua file
function editor:getthemes()
	local files = love.filesystem.getDirectoryItems( "themes/" )
	local themes = {}
	for i,f in ipairs(files) do
		table.insert(themes, f:match("^(.+).lua$"))
	end

	return themes
end
editor.themes = editor:getthemes()


editor.help = {
	{
		editor.binds.edittoggle,
		"toggle editmode"
	},
	{
		editor.binds.camera .. " + scroll",
		"set camera zoom level"
	},
	{
		editor.binds.up..", "..editor.binds.left..", "..editor.binds.down..", "..editor.binds.right,
		"move"
	},
	{
		"left mouse",
		"place entity"
	},
	{
		"right mouse",
		"remove entity"
	},
	{
		"mouse wheel",
		"scroll entity type"
	},
	{
		editor.binds.rotate .." + scroll",
		"rotate entity"
	},
	{
		editor.binds.moveup..", "..editor.binds.moveleft..", "..editor.binds.movedown..", "..editor.binds.moveright,
		"adjust entity position"
	},
	{
		editor.binds.respawn,
		"reset camera"
	},
	{
		editor.binds.showinfo,
		"toggle entity coordinate information"
	},
	{
		editor.binds.decmovedist,
		"increase entity move distance / angle"
	},
	{
		editor.binds.incmovedist,
		"decrease entity move distance / angle"
	},
	{
		editor.binds.texturesel .. " + scroll",
		"change entity texture"
	},
	{
		editor.binds.musicnext  .. ", " .. editor.binds.musicprev,
		"set world music"
	},
	{
		editor.binds.themecycle,
		"set the world theme"
	},
	{
		editor.binds.backgroundtoggle,
		"toggle display of parallax background"
	},
	{
		editor.binds.entcopy,
		"copy entity to clipboard"
	},
	{
		editor.binds.entpaste,
		"paste entity from clipboard"
	},
	{
		editor.binds.savemap,
		"save the map"
	},
	{
		editor.binds.guidetoggle,
		"toggle grid"
	},
	{
		editor.binds.maptoggle,
		"toggle minimap"
	},
	{
		editor.binds.helptoggle,
		"help menu"
	},
	{
		binds.screenshot,
		"take a screenshot"
	},
	{
		binds.savefolder,
		"open local data directory"
	},
	{
		binds.exit,
		"exit to title"
	},
	{
		binds.console,
		"toggle console"
	}

}

function editor:showtexmenu(textures)
	--make the texture browser display visible
	self.texlist = textures
	self.texmenutimer = self.texmenuduration
	self.texmenuopacity = 1
end


function editor:showmusicmenu()
	--make the music menu display visible
	self.musicmenuopacity = 1
	self.musicmenutimer = self.musicmenuduration
end


function editor:settexture(dy)

	if self.selname == "platform" then
		--update the texture value
		for _,platform in ripairs(world.entities.platform) do
			if platform.selected then
				self:showtexmenu(platforms.textures)
				self.texturesel = math.max(1,math.min(#self.texlist,self.texturesel - dy))
				--TODO, change platforms to polygons, shouldn't need this function when fixed
				platforms:settexture(platform,self.texturesel)
				break
			end
		end

	elseif self.selname == "decal" then

		for _,decal in ripairs(world.entities.decal) do
			if decal.selected then
				self:showtexmenu(decals.textures)
				self.texturesel = math.max(1,math.min(#self.texlist,self.texturesel - dy))
				decal.texture = self.texturesel
				break
			end
		end
	else
		--empty list
		self:showtexmenu({ nil })
		self.texturesel = 1
	end

end


function editor:update(dt)
	--update world before anything else
	if self.paused then
		--only update these when paused
		camera:update(dt)
		player:update(dt)
		camera:follow(player.x+player.w/2, player.y+player.h/2)
	else
		world:update(dt)
	end

	--update active entity selection
	self:selection()

	--adjust mmap scale
	self.mmapscale = camera.scale/4

	--texture browser display
	self.texmenutimer = math.max(0, self.texmenutimer - dt)

	if self.texmenutimer == 0 then
		if self.texmenuopacity > 0 then
			self.texmenuopacity = math.max(0,self.texmenuopacity - self.texmenufadespeed * dt)
		end
	end

	--music browser display
	self.musicmenutimer = math.max(0, self.musicmenutimer - dt)

	if self.musicmenutimer == 0 then
		if self.musicmenuopacity > 0 then
			self.musicmenuopacity = math.max(0,self.musicmenuopacity - self.musicmenufadespeed * dt)
		end
	end

	if love.mouse.isDown(1) then self.placing = true else self.placing = false end
end


function editor:settheme()
	world.theme = self.themes[self.themesel]
	world:settheme(world.theme)

	self.themesel = self.themesel +1
	if self.themesel > #self.themes then self.themesel = 1 end
end


function editor:warn(func)
	if not func then
		console:print("action cannot be performed on selected entity")
	end
end



function editor:clearsel()
	-- clear selection on active entities
	for _, i in ipairs(self.entorder) do
		for n,e in ipairs(world.entities[i]) do
			e.selected = false
		end
	end

	self.is_selected = false
	self.entity_selected = {}

end

function editor:keypressed(key)

	if key == self.binds.edittoggle then
		editing = not editing
		player.xvel = 0
		player.yvel = 0
		player.angle = 0
		player.jumping = false
		player.xvelboost = 0

		self:clearsel()

	end

	if key == self.binds.helptoggle then self.showhelpmenu = not self.showhelpmenu end
	if key == self.binds.maptoggle then self.showmmap = not self.showmmap end

	--free roaming
	if editing then
		if key == self.binds.entselup then self.entsel = self.entsel +1 end
		if key == self.binds.entseldown then self.entsel = self.entsel -1 end
		if key == self.binds.pause then self.paused = not self.paused end
		if key == self.binds.delete then self:remove() end
		if key == self.binds.entcopy then self:copy() end
		if key == self.binds.entpaste then self:paste() end
		if key == self.binds.backgroundtoggle then world.parallax.enabled = not world.parallax.enabled end
		if key == self.binds.entmenutoggle then self.showentmenu = not self.showentmenu end
		if key == self.binds.flip then self:flip() end
		if key == self.binds.guidetoggle then self.showgrid = not self.showgrid end
		if key == self.binds.respawn then self:sendtospawn() end
		if key == self.binds.showinfo then self.showinfo = not self.showinfo end
		if key == self.binds.showid then self.showid = not self.showid end
		if key == self.binds.savemap then mapio:savemap(world.map) end

		if key == self.binds.musicprev then
			if world.mapmusic == 0 then
				world.mapmusic = #sound.music
			else
				world.mapmusic = world.mapmusic -1
			end

			self:showmusicmenu()
			sound:playbgm(world.mapmusic)
			sound:playambient(world.mapambient)
		end

		if key == self.binds.musicnext then
			if world.mapmusic == #sound.music then
				world.mapmusic = 0
			else
				world.mapmusic = world.mapmusic +1
			end

			self:showmusicmenu()
			sound:playbgm(world.mapmusic)
			sound:playambient(world.mapambient)
		end


		if key == self.binds.themecycle then self:settheme() end


		if (self.is_selected ==true ) then
			if love.keyboard.isDown(self.binds.moveup) then
				--weird bug, needs to be "11" to actually save to proper position?
				--maybe it's being rounded down? So that expected "10" becomes "9" ?

				self.entity_selected.y = math.round(self.entity_selected.y - 11,-1) --up
				self.mouse.y = self.mouse.y -10

				if(self.entity_selected.yorigin~=nil) then self.entity_selected.yorigin = self.entity_selected.yorigin - 10 end
			end
			if love.keyboard.isDown(self.binds.movedown) then
				self.entity_selected.y = math.round(self.entity_selected.y + 10,-1) --down
				if(self.entity_selected.yorigin~=nil) then self.entity_selected.yorigin = self.entity_selected.yorigin + 10 end

				self.mouse.y = self.mouse.y +10
			end
			if love.keyboard.isDown(self.binds.moveleft) then
				self.entity_selected.x = math.round(self.entity_selected.x - 10,-1) --left
				self.entity_selected.xorigin = self.entity_selected.x
				self.mouse.x = self.mouse.x -10
			end
			if love.keyboard.isDown(self.binds.moveright) then
				self.entity_selected.x = math.round(self.entity_selected.x + 10,-1)  --right
				self.entity_selected.xorigin = self.entity_selected.x
				self.mouse.x = self.mouse.x+10
			end

			return true

		end

		--[[

		for _, i in ipairs(self.entorder) do
			for _,e in ipairs(world.entities[i]) do
				--fix this for moving platform (yorigin,xorigin etc)
				if e.selected then
					if love.keyboard.isDown(self.binds.moveup) then
						--weird bug, needs to be "11" to actually save to proper position?
						--maybe it's being rounded down? So that expected "10" becomes "9" ?

						e.y = math.round(e.y - 11,-1) --up
						self.mouse.y = self.mouse.y -10
						if(e.yorigin~=nil) then e.yorigin = e.yorigin - 10 end
					end
					if love.keyboard.isDown(self.binds.movedown) then
						e.y = math.round(e.y + 10,-1) --down
						if(e.yorigin~=nil) then e.yorigin = e.yorigin + 10 end

						self.mouse.y = self.mouse.y +10
					end
					if love.keyboard.isDown(self.binds.moveleft) then
						e.x = math.round(e.x - 10,-1) --left
						e.xorigin = e.x
						self.mouse.x = self.mouse.x -10
					end
					if love.keyboard.isDown(self.binds.moveright) then
						e.x = math.round(e.x + 10,-1)  --right
						e.xorigin = e.x
						self.mouse.x = self.mouse.x+10
					end

					return true

				end
			end
		end
		--]]

	end
end


function editor:checkkeys(dt)
	if console.active then return end
	if love.keyboard.isDown(self.binds.right)  then
		player.x = player.x + self.floatspeed /camera.scale *dt
	end
	if love.keyboard.isDown(self.binds.left)  then
		player.x = player.x - self.floatspeed /camera.scale *dt
	end
	if love.keyboard.isDown(self.binds.up) then
		player.y = player.y - self.floatspeed /camera.scale *dt
	end
	if love.keyboard.isDown(self.binds.down) then
		player.y = player.y + self.floatspeed /camera.scale *dt
	end

	if love.keyboard.isDown(self.binds.decmovedist) then
		self:setattribute(-1,dt)
	end
	if love.keyboard.isDown(self.binds.incmovedist) then
		self:setattribute(1,dt)
	end
end


function editor:setattribute(dir,dt)
	--horizontal size adjustment
	local should_break = false

	for _,type in pairs(world.entities) do
		if should_break then break end
		for _,e in ipairs(type) do
			if e.selected then

				if e.swing then
					e.angleorigin = math.max(0,math.min(math.pi,e.angle - dir*2 *dt))
					e.angle = e.angleorigin

				elseif e.movex then
					e.movedist = math.round(e.movedist + dir*2,1)
					if e.movedist < e.w then e.movedist = e.w end

				elseif e.movey then

					e.movedist = math.round(e.movedist + dir*2,1)

					if e.movedist < e.h then
						if(e.type=="crusher") then
							e.movedist = e.movedist + dir * 2
						else
							e.movedist = e.h
						end
					end

				elseif e.scrollspeed then
					e.scrollspeed = math.round(e.scrollspeed + dir*2,1)

				end

					should_break = true
					break
			end
		end
	end
end


function editor:wheelmoved(dx, dy)
    if love.keyboard.isDown(self.binds.camera) then
		--camera zoom
		camera.scale = math.max(self.mincamerascale,math.min(self.maxcamerascale,camera.scale + dy/25))

	elseif love.keyboard.isDown(self.binds.texturesel) then
		--change entity texture
		self:settexture(dy)

	elseif love.keyboard.isDown(self.binds.rotate) then
		--rotate an entity
		self:rotate(dy)
	else
		--entmenu selection
		self.entsel = math.max(1,math.min(#self.entities,self.entsel - dy))

	end
end


function editor:mousepressed(x,y,button)
	if not editing then return end

	self.mouse.pressed.x = math.round(camera.x-(love.graphics.getWidth()/2/camera.scale)+x/camera.scale,-1)
	self.mouse.pressed.y = math.round(camera.y-(love.graphics.getHeight()/2/camera.scale)+y/camera.scale,-1)
	--self.mouse.pressed.x, self.mouse.pressed.y = camera:toWorldCoords(x,y)
	--local x = math.round(self.mouse.pressed.x,-1)
	--local y = math.round(self.mouse.pressed.y,-1)
end


function editor:mousereleased(x,y,button)
	--check if we have selected draggable entity, then place if neccesary
	if not editing then return end

	self.mouse.released.x = math.round(camera.x-(love.graphics.getWidth()/2/camera.scale)+x/camera.scale,-1)
	self.mouse.released.y = math.round(camera.y-(love.graphics.getHeight()/2/camera.scale)+y/camera.scale,-1)

	--self.mouse.released.x, self.mouse.released.y = camera:toWorldCoords(x,y)
	--self.mouse.released.x = math.round(self.mouse.released.x,-1)
	--self.mouse.released.y = math.round(self.mouse.released.y,-1)

	self.drawsel = false

	if button == 1 then
		for _,entity in pairs(self.draggable) do
			if self.entities[self.entsel][1] == entity then
				self:placedraggable(self.mouse.pressed.x, self.mouse.pressed.y, self.mouse.released.x, self.mouse.released.y)
			end
		end

		if self.mouse.pressed.x == self.mouse.released.x
		and self.mouse.pressed.y == self.mouse.released.y then

			local selection = self.entities[self.entsel][1]
			if selection == "spawn" then
				self:removeall("portal", "spawn")
				portals:add(self.mouse.released.x,self.mouse.released.y,"spawn")
			end
			if selection == "goal" then
				self:removeall("portal", "goal")
				portals:add(self.mouse.released.x,self.mouse.released.y,"goal")
			end

			for i,ent in pairs(self.entities) do
				if ent[1] == selection then
					if ent[2] == "prop" then
						props:add(self.mouse.released.x,self.mouse.released.y,self.entdir,false,ent[1])
					elseif
						ent[2] == "crate" then
						crates:add(self.mouse.released.x,self.mouse.released.y,"gem")
					elseif
						ent[2] == "pickup" then
						pickups:add(self.mouse.released.x,self.mouse.released.y,ent[1])
					elseif
						ent[2] == "coin" then
						coins:add(self.mouse.released.x,self.mouse.released.y)
					elseif
						ent[2] == "checkpoint" then
						checkpoints:add(self.mouse.released.x,self.mouse.released.y)
					elseif
						ent[2] == "trap" then
						traps:add(self.mouse.released.x,self.mouse.released.y,ent[1])
					elseif
						ent[2] == "spring" then
						springs:add(self.mouse.released.x,self.mouse.released.y,self.entdir,ent[1])
					elseif
						ent[2] == "bumper" then
						bumpers:add(self.mouse.released.x,self.mouse.released.y)
					elseif
						ent[2] == "tip" then
						tips:add(self.mouse.released.x,self.mouse.released.y,"this is a multi line text test to see how everything can fit nicely in the frame")
					elseif
						ent[2] == "enemy" then
						-- movespeed/movedist shouldn't be hardcoded here
						enemies:add(self.mouse.released.x,self.mouse.released.y,100,100,self.entdir,ent[1])
					end
				end
			end

			if selection == "platform_s" then platforms:add(self.mouse.released.x,self.mouse.released.y,0,20,false,false,false,1.5,0,true,0,self.texturesel) end

			return true
		end
	end

	if button == 2 then
		self:remove()
		return true
	end
	--reorder entity (sendtoback)
	if button == 3 then
		for _,i in ipairs(self.entorder) do
			for n,e in ripairs(world.entities[i]) do
				if e.selected then
					world:sendtoback(world.entities[i],n)
					return true
				end
			end
		end
	end
end


function editor:sendtospawn()
	-- find the spawn entity
	for _, portal in ipairs(world.entities.portal) do
		if portal.type == "spawn" then
			player.x = portal.x
			player.y = portal.y
		end
	end
	camera.scale = 1
end


function editor:placedraggable(x1,y1,x2,y2)
	-- do not place entity if a selection is active
	if self.is_selected then return false end

	-- this function is used for placing entities which
	-- can be dragged/resized when placing
	local ent = self.entities[self.entsel][1]

	--we must drag down and right
	if not (x2 < x1 or y2 < y1) then
		--min sizes (we don't want impossible to select/remove platforms)
		if x2-x1 < self.entsizemin  then x2 = x1 + self.entsizemin end
		if y2-y1 < self.entsizemin  then y2 = y1 + self.entsizemin end

		local x = math.round(x1,-1)
		local y = math.round(y1,-1)
		local w = (x2-x1)
		local h = (y2-y1)

		--place the platform
		-- TODO should be moved to entities/init.lua as function
		if ent == "platform" then platforms:add(x,y,w,h,true,false,false,0,0,false,0,self.texturesel) end
		if ent == "platform_b" then platforms:add(x,y,w,h,false,false,false,0,0,false,0,self.texturesel) end
		if ent == "platform_x" then platforms:add(x,y,w,h,false,true,false,100,200,false,0,self.texturesel) end
		if ent == "platform_y" then platforms:add(x,y,w,h,false,false,true,100,200,false,0,self.texturesel) end

		if ent == "decal" then decals:add(x,y,w,h,100,1) end

		if ent == "death" then materials:add(x,y,w,h,"death") end
	end
end


function editor:drawgrid()
	--draw crosshairs/grid

	if self.showgrid then

		--grid
		love.graphics.setColor(1,1,1,0.09)
		-- horizontal
		for x=camera.x-love.graphics.getWidth()/2/camera.scale,
			camera.x+love.graphics.getWidth()/2/camera.scale,10 do
			love.graphics.line(
				math.round(x,-1), camera.y-love.graphics.getHeight()/2/camera.scale,
				math.round(x,-1), camera.y+love.graphics.getHeight()/2/camera.scale
			)
		end
		-- vertical
		for y=camera.y-love.graphics.getHeight()/2/camera.scale,
			camera.y+love.graphics.getHeight()/2/camera.scale,10 do
			love.graphics.line(
				camera.x-love.graphics.getWidth()/2/camera.scale, math.round(y,-1),
				camera.x+love.graphics.getWidth()/2/camera.scale, math.round(y,-1)
			)
		end

		--crosshair
		love.graphics.setColor(0.78,0.78,1,0.3)
		--vertical
		love.graphics.line(
			math.round(self.mouse.x,-1),
			math.round(self.mouse.y+love.graphics.getHeight()/camera.scale,-1),
			math.round(self.mouse.x,-1),
			math.round(self.mouse.y-love.graphics.getHeight()/camera.scale,-1)
		)
		--horizontal
		love.graphics.line(
			math.round(self.mouse.x-love.graphics.getWidth()/camera.scale,-1),
			math.round(self.mouse.y,-1),
			math.round(self.mouse.x+love.graphics.getWidth()/camera.scale-1),
			math.round(self.mouse.y,-1)
		)


	end
end


function editor:drawcursor()
--[[ -- old cursor
	--draw the cursor
	love.graphics.setColor(255,255,255,255)
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
	--]]

	-- detach camera so cursor doesn't scale in size
	camera:detach()

	local x,y = camera:toCameraCoords(self.mouse.x,self.mouse.y)

	-- draw the cursor
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.mouse.cursors[self.mouse.cur], x-self.mouse.hotspotx,y-self.mouse.hotspoty)

	-- print active entity selection info
	self:drawinfo(x+40,y+60)

	camera:attach()

end


function editor:drawmusicmenu()
	if self.musicmenuopacity > 0 then
		love.graphics.setCanvas(self.musicmenu)
		love.graphics.clear()

		local x = self.musicmenupadding
		local y = self.musicmenupadding

		love.graphics.setColor(0,0,0,0.58)
		love.graphics.rectangle("fill",0,0,self.musicmenu:getWidth(), self.musicmenu:getHeight(),10)

		love.graphics.setColor(1,1,1,1)

		local oldfont = love.graphics.getFont()
		love.graphics.setFont(fonts.hud)

		local str = "bgm track: " .. (world.mapmusic or "0")

		-- center the text within canvas
		love.graphics.printf(
			str,
			self.musicmenu:getWidth()/2-love.graphics.getFont():getWidth(str)/2,
			self.musicmenu:getHeight()/2-love.graphics.getFont():getHeight(str)/2,
			love.graphics.getFont():getWidth(str)
		)
		love.graphics.setFont(oldfont)
		love.graphics.setCanvas()

		love.graphics.setColor(1,1,1,self.musicmenuopacity)
		love.graphics.draw(self.musicmenu, love.graphics.getWidth()/2-self.musicmenu:getWidth()/2, 20)
	end
end


function editor:drawtexturesel()

	-- temporary fix... whitelist entity types that can be textured above^^^^
	if self.selname ~= ("platform" or "decal") then return false end

	if self.texmenuopacity > 0 then

		love.graphics.setCanvas(self.texmenu)
		love.graphics.clear()

		local x = self.texmenupadding
		local y = self.texmenupadding
		local n = 0

		love.graphics.setColor(0,0,0,0.5)
		love.graphics.rectangle("fill",0,0,self.texmenu:getWidth(), self.texmenu:getHeight(),0)

		local lw = love.graphics.getLineWidth()
		love.graphics.setLineWidth(5)
		love.graphics.setColor(1,1,1,0.5)
		love.graphics.rectangle("line",0,0,self.texmenu:getWidth(), self.texmenu:getHeight(),0)
		love.graphics.setLineWidth(lw)

		--[[
			this loop fails (crash) when changing texture of decal or platform,
			then moving mouse over an enemy entity, whilst texture menu is visible...
			fix this...
		--]]


		for i = math.max(-self.texmenuoffset,self.texturesel-self.texmenuoffset),
			math.min(#self.texlist+self.texmenuoffset,self.texturesel+self.texmenuoffset) do

			if type(self.texlist[i]) == "userdata" then

				love.graphics.setColor(1,1,1,1)
				love.graphics.draw(
					self.texlist[i],
					x,
					y+(n*self.texmenutexsize)+n*(self.texmenupadding),
					0,
					self.texmenutexsize/self.texlist[i]:getWidth(),
					self.texmenutexsize/self.texlist[i]:getHeight()
				)

				if self.texturesel == i then
					local lw = love.graphics.getLineWidth()
					love.graphics.setLineWidth(3)
					love.graphics.setColor(0,1,0,1)
					love.graphics.rectangle(
						"line",
						x,
						y+(n*self.texmenutexsize)+n*(self.texmenupadding),
						self.texmenutexsize,self.texmenutexsize
					)
					love.graphics.setLineWidth(lw)
				end

				love.graphics.setColor(0,0,0,1)
				love.graphics.print(i,x+5,y+(n*self.texmenutexsize)+n*(self.texmenupadding)+5)

			else

				love.graphics.setColor(1,1,1,0.5)

				love.graphics.draw(
					self.errortex,
					x,
					y+(n*self.texmenutexsize)+n*(self.texmenupadding),
					0,
					self.texmenutexsize/self.errortex:getWidth(),
					self.texmenutexsize/self.errortex:getHeight()
				)

			end

			n = n + 1
		end

		love.graphics.setCanvas()

		love.graphics.setColor(1,1,1,self.texmenuopacity)
		love.graphics.draw(self.texmenu, 10, 10)
	end
end


function editor:draw()

	--editor hud
	love.graphics.setColor(0,0,0,0.49)
	love.graphics.rectangle("fill", love.graphics.getWidth() -130, 10, 120,(editing and 120 or 70),10)
	love.graphics.setFont(fonts.large)
	love.graphics.setColor(1,1,1,0.68)
	love.graphics.print("editing",love.graphics.getWidth()-120, 20,0,1,1)
	love.graphics.setFont(fonts.default)
	love.graphics.print("press [h] for help",love.graphics.getWidth()-120, 50,0,1,1)


	--interactive editing
	if editing then

		camera:attach()
			self:drawgrid()
			self:drawselbox()
			self:drawcursor()
		camera:detach()


		if world.collision == 0 then
			--notify keybind for camera reset when
			--no entities are in view
			love.graphics.setColor(1,1,1,1)
			love.graphics.setFont(fonts.menu)
			love.graphics.print("(Tip: press \"".. self.binds.respawn .. "\" to reset camera)", 200, love.graphics.getHeight()-50,0,1,1)
			love.graphics.setFont(fonts.default)
		end

		love.graphics.setFont(fonts.console)
		love.graphics.setColor(1,1,1,2155)
		love.graphics.print("selection:",love.graphics.getWidth()-115, 65,0,1,1)

		love.graphics.setColor(1,0.60,0.21,1)
		love.graphics.print(editor.selname or "",love.graphics.getWidth()-115, 80,0,1,1)

		love.graphics.setColor(1,1,1,1)
		love.graphics.print("theme:",love.graphics.getWidth()-115, 95,0,1,1)

		love.graphics.setColor(1,0.60,0.21,1)
		love.graphics.print(world.theme or "default",love.graphics.getWidth()-115, 110,0,1,1)
		--love.graphics.setFont(fonts.default)

		if self.showentmenu then self:drawentmenu() end
		self:drawmusicmenu()
		self:drawtexturesel()
	end

	if self.showmmap then self:drawmmap() end
	if self.showhelpmenu then self:drawhelpmenu() end


end


function editor:drawselbox()
	--draw an outline when dragging mouse if
	-- entsel is one of these types
	if self.drawsel and not self.is_selected then
		for _,entity in ipairs(self.draggable) do
			if self.entities[self.entsel][1] == entity then
				love.graphics.setColor(0,1,1,1)
				love.graphics.rectangle(
					"line",
					self.mouse.pressed.x,self.mouse.pressed.y,
					self.mouse.x-self.mouse.pressed.x, self.mouse.y-self.mouse.pressed.y
				)
			end
		end

		else

			--draw box  for actively selected entity
			if self.selbox then
			local lw = love.graphics.getLineWidth()
			love.graphics.setLineWidth(3)
			--frame
			love.graphics.setColor(0,0.9,0,1)
			love.graphics.rectangle("line", self.selbox.x, self.selbox.y, self.selbox.w, self.selbox.h)

			--corner markers
			local size = 5
			love.graphics.setColor(0,1,0,1)
			--top left
			love.graphics.rectangle("fill", self.selbox.x-size/2, self.selbox.y-size/2, size, size)
			--top right
			love.graphics.rectangle("fill", self.selbox.x+self.selbox.w-size/2, self.selbox.y-size/2, size, size)
			--bottom left
			love.graphics.rectangle("fill", self.selbox.x-size/2, self.selbox.y+self.selbox.h-size/2, size, size)
			--bottom right
			love.graphics.rectangle("fill", self.selbox.x+self.selbox.w-size/2, self.selbox.y+self.selbox.h-size/2, size, size)
			love.graphics.setLineWidth(lw)
		end
	end


end


function editor:formathelp(t)
	local s = 20 -- vertical spacing
	love.graphics.setFont(fonts.menu)
	for i,item in ipairs(t) do
		love.graphics.setColor(0.60,1,1,0.60)
		love.graphics.print(string.upper(item[1]),10,s*i+s);
		love.graphics.setColor(1,1,1,0.60)
		love.graphics.printf(item[2],160,s*i+s,fonts.menu:getWidth(item[2]),"left")
		--print("| " ..item[1].." | "..item[2] .. "|")
	end
	love.graphics.setFont(fonts.default)
end


function editor:drawhelpmenu()

	love.graphics.setCanvas(self.helpmenu)
	love.graphics.clear()

	--frame
	love.graphics.setColor(0,0,0,0.78)
	love.graphics.rectangle("fill",0,0, self.helpmenu:getWidth(), self.helpmenu:getHeight(),10)
	--border
	love.graphics.setColor(1,1,1,0.58)
	love.graphics.rectangle("fill",0,0, self.helpmenu:getWidth(), 5)
	--title
	love.graphics.setColor(1,1,1,1)
	love.graphics.print("Editor Help",10,10)

	--hrule
	love.graphics.setColor(1,1,1,0.58)
	love.graphics.rectangle("fill",10,25, self.helpmenu:getWidth()-10, 1)


	--menu title
	love.graphics.setColor(1,1,1,0.58)
	love.graphics.printf("["..self.binds.helptoggle.."] to close",self.helpmenu:getWidth()-110,10,100,"right")

	--loop bind/key description and format it
	self:formathelp(self.help)

	love.graphics.setCanvas()

	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.helpmenu, love.graphics.getWidth()/2-self.helpmenu:getWidth()/2, love.graphics.getHeight()/2-self.helpmenu:getHeight()/2 )
end


function editor:drawentmenu()
	--gui scrolling list for entity selection
	if not editing then return end

	love.graphics.setFont(fonts.menu)
	love.graphics.setCanvas(self.entmenu)
	love.graphics.clear()

	--frame
	love.graphics.setColor(0,0,0,0.58)
	love.graphics.rectangle(
		"fill",0,0, self.entmenu:getWidth(), self.entmenu:getHeight(),10
	)

	--border
	love.graphics.setColor(1,1,1,0.58)
	love.graphics.rectangle(
		"fill",0,0, self.entmenu:getWidth(), 5
	)

	love.graphics.setColor(1,1,1,1)
	love.graphics.print("entity selection",10,10)

	--hrule
	love.graphics.setColor(1,1,1,0.58)
	love.graphics.rectangle(
		"fill",10,25, self.entmenu:getWidth()-10, 1
	)

	local s = 20 -- vertical spacing
	local empty = "*"
	local padding = 2


	local n = 1
	for i=-5,15 do
		if self.entities[self.entsel+i] and self.entities[self.entsel+i][1] then
			n = n +1
			local texture = self.bullettex --placeholder
			love.graphics.setColor(1,1,1,1)
			love.graphics.draw(texture,10,s*n,0,s/texture:getWidth(), s/texture:getHeight())

			if i == 0 then
				love.graphics.setColor(0.58,0.58,0.58,1)

				love.graphics.rectangle(
					"fill",s/texture:getWidth()+s*2,-padding+s*n, self.entmenu:getWidth()-20+padding*2, 15+padding*2
				)

				love.graphics.setColor(0,0,0,1)
				love.graphics.print(self.entities[self.entsel+i][1],s/texture:getWidth()+s*2,s*n)
			else
				love.graphics.setColor(0.58,0.58,0.58,1)
				love.graphics.print(self.entities[self.entsel+i][1],s/texture:getWidth()+s*2,s*n)
			end
		end
	end

	love.graphics.setFont(fonts.default)
	love.graphics.setCanvas()

	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.entmenu, 10, love.graphics.getHeight()-self.entmenu:getHeight()-10 )
end


function editor:selection()
	if not editing then return false end

	-- no need to find a selection if we are placing a new entity
	if self.placing then return end

	self:clearsel()

	-- this let's us break nested loops below
	-- and not have multiple entities selected, resulting in a crash
	local break_entities = false
	local break_entorder = false

	for _, i in ipairs(self.entorder) do
		if break_entorder then break end
		--reverse loop
		for n,e in ripairs(world.entities[i]) do
			if break_entities then break end
			if world:inview(e) then
				self.selname = (e.type or e.group)
				self.id = n

				if e.movex then
					--collision area for moving entity
					if collision:check(self.mouse.x,self.mouse.y,1,1,e.xorigin, e.y, e.movedist+e.w, e.h) then
						self.selbox = {
							x = e.xorigin,
							y = e.y,
							w = e.movedist+e.w,
							h = e.h
						}
						e.selected = true
						self.is_selected = true
						self.entity_selected = e
					end
				elseif e.movey then
					--collision area for moving entity
					if collision:check(self.mouse.x,self.mouse.y,1,1,e.xorigin, e.yorigin, e.w, e.h+e.movedist) then
						self.selbox = {
							x = e.xorigin ,
							y = e.yorigin ,
							w = e.w ,
							h = e.h + e.movedist
						}
						e.selected = true
						self.is_selected = true
						self.entity_selected = e
					end
				elseif e.swing then
					--collision area for swinging entity
					if collision:check(self.mouse.x,self.mouse.y,1,1,
						e.xorigin-chainlink.textures["origin"]:getWidth()/2, e.yorigin-chainlink.textures["origin"]:getHeight()/2,
						chainlink.textures["origin"]:getWidth(),chainlink.textures["origin"]:getHeight()) then
						self.selbox = {
							x = e.xorigin-chainlink.textures["origin"]:getWidth()/2,
							y = e.yorigin-chainlink.textures["origin"]:getHeight()/2,
							w = chainlink.textures["origin"]:getWidth(),
							h = chainlink.textures["origin"]:getHeight()
						}
						e.selected = true
						self.is_selected = true
						self.entity_selected = e
					end
				elseif collision:check(self.mouse.x,self.mouse.y,1,1,e.x,e.y,e.w,e.h) then
					--collision area for static entities
					self.selbox = {
						x = e.x,
						y = e.y,
						w = e.w,
						h = e.h
					}
					e.selected = true
					self.is_selected = true
					self.entity_selected = e
				else
					self.selbox = nil
					self.selname = "null"
				end


				if e.selected then
					-- selection cursor
					self.mouse.cur = 2

					-- update texture selection (platforms only for now)
					-- temporary, until other entities use numeric texture id slot
					-- otherwise enemy texture = nil and causes crashing
					if e.group == "platform" then
						self.texturesel = e.texture
					end

					-- exit both loops
					break_entities = true
					break_entorder = true

					return
				else
					-- default cursor
					self.mouse.cur = 1

				end

			end
		end
	end
end


function editor:removeall(group,type)
	--removes all entity types of given entity
	for _, enttype in pairs(world.entities) do
		for i, e in ripairs(enttype) do
			if e.group == group and e.type == type then
				table.remove(enttype,i)
			end
		end
	end
end


function editor:remove()
	--removes the currently selected entity from the world
	local should_break = false
	for _, i in ipairs(self.entorder) do
		if should_break then break end
		for n,e in ipairs(world.entities[i]) do
			if e.selected then
				table.remove(world.entities[i],n)
				console:print( e.group .. " (" .. n .. ") removed" )
				self.selbox = nil
				should_break = true

				self.is_selected = false
				self.entity_selected = {}

				break
			end
		end
	end
end


function editor:flip()
	local should_break = false
	for _, i in ipairs(self.entorder) do
		if should_break then break end
		for n,e in ipairs(world.entities[i]) do
			if e.selected and e.editor_canflip then
				e.flip = not e.flip
				console:print( e.group .. " (" .. n .. ") flipped" )
				e.selected = false
				should_break = true

				self.is_selected = false
				self.entity_selected = {}
				break
			end
		end
	end
end


function editor:rotate(dy)
	--set rotation value for the entity
	--four directions, 0,1,2,3 at 90degree angles
	local should_break = false
	for _, i in ipairs(self.entorder) do
		if should_break then break end
		for n,e in ipairs(world.entities[i]) do
			if e.selected and e.editor_canrotate then

				e.dir = e.dir + dy
				if e.dir > 3 then
					e.dir = 0
				elseif e.dir < 0 then
					e.dir = 3
				end

				local w = e.w
				local h = e.h

				e.w = h
				e.h = w

				console:print( e.group .. " (" .. n .. ") rotated, direction = "..e.dir)
				e.selected = false
				should_break = true

				self.is_selected = false
				self.entity_selected = {}
				break

			end
		end
	end
end


function editor:copy()
	for _,type in pairs(world.entities) do
		for i, e in ipairs(type) do
			if e.selected then
				console:print("copied "..e.group.."("..i..")")
				self.clipboard = e
				return true
			end
		end
	end
end


function editor:paste()
	local x = math.round(self.mouse.x,-1)
	local y = math.round(self.mouse.y,-1)

	--paste the cloned entity
	local p = table.deepcopy(self.clipboard)
	if type(p) == "table" then
		p.x = x
		p.y = y
		p.xorigin = x + (p.x-x)
		p.yorigin = y + (p.y-y)
		table.insert(world.entities[p.group],p)
		console:print("paste "..p.group.."("..#world.entities[p.group]..")")
	end
end


function editor:drawmmap()
	-- TODO define a mmap colour for each entity in its own file,
	-- then loop over world.entities and apply colour, so that
	-- editor does not specify actual entity names
	love.graphics.setCanvas(self.mmapcanvas)
	love.graphics.clear()

	love.graphics.setColor(0,0,0,0.58)
	love.graphics.rectangle("fill", 0,0,self.mmapw,self.mmaph)

	for i, platform in ipairs(world.entities.platform) do
		if platform.clip then
			love.graphics.setColor(
				platform_r,
				platform_g,
				platform_b,
				1
			)
		else
			love.graphics.setColor(
				platform_behind_r,
				platform_behind_g,
				platform_behind_b,
				1
			)
		end
		love.graphics.rectangle(
			"fill",
			(platform.x*self.mmapscale)-(camera.x*self.mmapscale)+self.mmapw/2,
			(platform.y*self.mmapscale)-(camera.y*self.mmapscale)+self.mmaph/2,
			platform.w*self.mmapscale,
			platform.h*self.mmapscale
		)
	end

	love.graphics.setColor(0,1,1,1)
	for i, crate in ipairs(world.entities.crate) do
		love.graphics.rectangle(
			"fill",
			(crate.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2,
			(crate.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2,
			crate.w*self.mmapscale,
			crate.h*self.mmapscale
		)
	end

	love.graphics.setColor(1,0.19,0.19,1)
	for i, enemy in ipairs(world.entities.enemy) do
		love.graphics.rectangle(
			"fill",
			(enemy.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2,
			(enemy.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2,
			enemy.w*self.mmapscale,
			enemy.h*self.mmapscale
		)
	end

	love.graphics.setColor(0.58,1,0.58,1)
	for i, pickup in ipairs(world.entities.pickup) do
		love.graphics.rectangle(
			"fill",
			(pickup.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2,
			(pickup.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2,
			pickup.w*self.mmapscale,
			pickup.h*self.mmapscale
		)
	end

	love.graphics.setColor(0,1,1,1)
	for i, checkpoint in ipairs(world.entities.checkpoint) do
		love.graphics.rectangle(
			"fill",
			(checkpoint.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2,
			(checkpoint.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2,
			checkpoint.w*self.mmapscale,
			checkpoint.h*self.mmapscale
		)
	end

	love.graphics.setColor(1,0.11,1,1)
	for i, spring in ipairs(world.entities.spring) do
		love.graphics.rectangle(
			"fill",
			(spring.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2,
			(spring.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2,
			spring.w*self.mmapscale,
			spring.h*self.mmapscale
		)
	end

	love.graphics.setColor(1,0.58,0,1)
	for i, bumper in ipairs(world.entities.bumper) do
		love.graphics.rectangle(
			"fill",
			(bumper.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2,
			(bumper.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2,
			bumper.w*self.mmapscale,
			bumper.h*self.mmapscale
		)
	end

	love.graphics.setColor(1,1,1,1)
	for i, trap in ipairs(world.entities.trap) do
		love.graphics.rectangle(
			"fill",
			(trap.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2,
			(trap.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2,
			trap.w*self.mmapscale,
			trap.h*self.mmapscale
		)
	end

	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle(
		"line",
		(player.x*self.mmapscale)-(camera.x*self.mmapscale)+self.mmapw/2,
		(player.y*self.mmapscale)-(camera.y*self.mmapscale)+self.mmaph/2,
		player.w*self.mmapscale,
		player.h*self.mmapscale
	)

	love.graphics.setCanvas()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.mmapcanvas, love.graphics.getWidth()-10-self.mmapw,love.graphics.getHeight()-10-self.mmaph )

end


function editor:drawinfo(x,y)
	if self.showinfo then
		love.graphics.setFont(fonts.console)

		for _, t in pairs(world.entities) do
			for i, e in pairs(t) do
				if e.selected and world:inview(e) then
					local info = "x ".. math.round(e.x) ..", y " .. math.round(e.y)
					local padding = 5
					love.graphics.setColor(0.1,0.1,0.1,0.75)
					love.graphics.rectangle("fill", x-20-padding,y-40-padding,love.graphics.getFont():getWidth(info)+padding*2,50,5)
					love.graphics.setColor(0,1,0,1)
					love.graphics.print(e.group .. "(" .. i .. ")", x-20, y-40, 0)
					love.graphics.setColor(1,1,1,0.5)
					love.graphics.print(info, x-20,y-20,0)

					return
				end
			end
		end
	end
end


function editor:mouse_move_entity()

	local x_move = self.mouse.x - self.mouse.old_pos.x
	local y_move = self.mouse.y - self.mouse.old_pos.y

	self.entity_selected.x = self.entity_selected.x + x_move
	if(self.entity_selected.xorigin~=nil) then self.entity_selected.xorigin = self.entity_selected.xorigin + x_move  end

	self.entity_selected.y = self.entity_selected.y + y_move
	if(self.entity_selected.yorigin~=nil) then self.entity_selected.yorigin = self.entity_selected.yorigin + y_move end

end

function editor:mousemoved(x,y,dx,dy)
	if not editing then return end

	self.mouse.old_pos.x = self.mouse.x
	self.mouse.old_pos.y = self.mouse.y

	self.mouse.x = math.round(camera.x-(love.graphics.getWidth()/2/camera.scale)+x/camera.scale,-1)
	self.mouse.y = math.round(camera.y-(love.graphics.getHeight()/2/camera.scale)+y/camera.scale,-1)

	if love.mouse.isDown(1) then
		self.drawsel = true
		if self.is_selected then
			self:mouse_move_entity()
		end
	else
		self.drawsel = false
	end

end
