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

		end
	end
	world.scenery = count
end
