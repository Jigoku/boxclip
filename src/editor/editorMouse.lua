editorMouse = {}

editorMouse.mouse = {
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

function editorMouse:wheelmoved(dx, dy)
    if love.keyboard.isDown(editor.binds.camera) then
		--camera zoom
		camera.scale = math.max(editor.mincamerascale,math.min(editor.maxcamerascale,camera.scale + dy/25))
		
	elseif love.keyboard.isDown(editor.binds.texturesel) then
		--change entity texture
		editor:settexture(dy)
		
	elseif love.keyboard.isDown(editor.binds.rotate) then
		--rotate an entity
		editor:rotate(dy)
	else
		--entmenu selection
		editor.entsel = math.max(1,math.min(#editor.entities,editor.entsel - dy))

	end
end


function editorMouse:mousepressed(x,y,button)
	if not editing then return end
	
	--this function is used to place entities which are not resizable. 


	--self.mouse.pressed.x, self.mouse.pressed.y = camera:toWorldCoords(x,y)
	--local x = math.round(self.mouse.pressed.x,-1)
	--local y = math.round(self.mouse.pressed.y,-1)


	self.mouse.pressed.x = math.round(camera.x-(love.graphics.getWidth()/2/camera.scale)+x/camera.scale,-1)
	self.mouse.pressed.y = math.round(camera.y-(love.graphics.getHeight()/2/camera.scale)+y/camera.scale,-1)
	local x = self.mouse.pressed.x
	local y = self.mouse.pressed.y
	
	if(editor.isSelected) then return true end
	
	if button == 1 then
		local selection = editor.entities[editor.entsel][1]
		-- TODO should be moved to entities/init.lua as function
		
		if selection == "spawn" then
			editor:removeall("portal", "spawn")
			portals:add(x,y,"spawn")
		end
		if selection == "goal" then
			editor:removeall("portal", "goal")
			portals:add(x,y,"goal")
		end

		for i,ent in pairs(editor.entities) do
			if ent[1] == selection then
				if ent[2] == "prop" then
					props:add(x,y,editor.entdir,false,ent[1])	
				elseif
					ent[2] == "crate" then
					crates:add(x,y,"gem")
				elseif
					ent[2] == "pickup" then
					pickups:add(x,y,ent[1])
				elseif
					ent[2] == "coin" then
					coins:add(x,y)
				elseif
					ent[2] == "checkpoint" then
					checkpoints:add(x,y)
				elseif
					ent[2] == "trap" then
					traps:add(x,y,ent[1])
				elseif
					ent[2] == "spring" then
					springs:add(x,y,editor.entdir,ent[1])
				elseif
					ent[2] == "bumper" then
					bumpers:add(x,y) 
				elseif
					ent[2] == "tip" then
					tips:add(x,y,"this is a multi line text test to see how everything can fit nicely in the frame")
				elseif
					ent[2] == "enemy" then
					enemies:add(x,y,100,100,editor.entdir,ent[1])

				end
				
			end
			
		end
		
		-- this should be moved outside of platforms.lua eventually
		if selection == "platform_s" then platforms:add(x,y,0,20,false,false,false,1.5,0,true,0,editor.texturesel) end
		
	elseif button == 2 then
		editor:remove()
	end
end


function editorMouse:mousereleased(x,y,button)
	--check if we have selected draggable entity, then place if neccesary
	if not editing then return end
	
	self.mouse.released.x = math.round(camera.x-(love.graphics.getWidth()/2/camera.scale)+x/camera.scale,-1)
	self.mouse.released.y = math.round(camera.y-(love.graphics.getHeight()/2/camera.scale)+y/camera.scale,-1)
	
	--self.mouse.released.x, self.mouse.released.y = camera:toWorldCoords(x,y)
	--self.mouse.released.x = math.round(self.mouse.released.x,-1)
	--self.mouse.released.y = math.round(self.mouse.released.y,-1)
	
	editor.drawsel = false

	if button == 1 then 
		for _,entity in pairs(editor.draggable) do
			if editor.entities[editor.entsel][1] == entity then
				editor:placedraggable(self.mouse.pressed.x,self.mouse.pressed.y,self.mouse.released.x,self.mouse.released.y)
			end
		end
		return
	end
	
	--reorder entity (sendtoback)
	if button == 3 then
		for _,i in ipairs(editor.entorder) do
			for n,e in ripairs(world.entities[i]) do
				if e.selected then
					world:sendtoback(world.entities[i],n)
					return true
				end
			end
		end
	end
end


function editorMouse:mousemoved(x,y,dx,dy)
	if not editing then return end
	
	self.mouse.old_pos.x = self.mouse.x
	self.mouse.old_pos.y = self.mouse.y 
	
	self.mouse.x = math.round(camera.x-(love.graphics.getWidth()/2/camera.scale)+x/camera.scale,-1)
	self.mouse.y = math.round(camera.y-(love.graphics.getHeight()/2/camera.scale)+y/camera.scale,-1)
	
	if love.mouse.isDown(1) then
		editor.drawsel = true 
		console:print("Mouse move from (" .. self.mouse.old_pos.x .. "," .. self.mouse.old_pos.y  ..") to (" .. self.mouse.x .. "," .. self.mouse.y  ..")")
		
		if (editor.isSelected ) then
			
			console:print("move entity mouse");
			
			local x_move = editorMouse.mouse.x - editorMouse.mouse.old_pos.x
			local y_move = editorMouse.mouse.y - editorMouse.mouse.old_pos.y
			
			editor.entitySelected.x = math.round(editor.entitySelected.x + x_move,-1)
			editor.entitySelected.xorigin = editor.entitySelected.x
			
			editor.entitySelected.y = math.round(editor.entitySelected.y + y_move,-1) --up
			if(editor.entitySelected.yorigin~=nil) then editor.entitySelected.yorigin = editor.entitySelected.yorigin + y_move end 
			
		end
	else
		editor.drawsel = false
	end
end

