scenery = {}


flower = love.graphics.newImage("graphics/scenery/flower.png")

function scenery:add(x,y,type)
	if type == "flower" then
		table.insert(scenery, {
			--dimensions
			x = x or 0, -- xco-ord
			y = y or 0, -- yco-ord
			w = 20, -- width
			h = 40, -- height
			--properties
			name = "flower",
			gfx = flower,
		})
		print("flower added @  X:"..x.." Y: "..y)
	end
end

function scenery:draw()
	local count = 0
	
	for i, object in ipairs(scenery) do
		if world:inview(object) then
		count = count + 1
				
			if object.name == "flower" then
				love.graphics.setColor(255,255,255,255)
				love.graphics.draw(object.gfx, object.x,object.y,0, 1, 1)
			end

			if editing then
				pickups:drawDebug(object, i)
			end

		end
	end
	world.scenery = count
end

function scenery:drawDebug(object, i)
	--requires graphic, implement all pickups as graphics/image
	love.graphics.setColor(255,0,155,100)
	love.graphics.rectangle(
		"line", 
		object.x, 
		object.y, 
		object.gfx:getWidth(), 
		object.gfx:getHeight()
	)
	util:drawid(object, i)
	util:drawCoordinates(object)
end
