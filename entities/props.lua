props = {}


flower = love.graphics.newImage("graphics/props/flower.png")
rock = love.graphics.newImage("graphics/props/rock.png")
spring = love.graphics.newImage("graphics/props/spring.png")

function props:add(x,y,type)
	if type == "flower" then
		table.insert(props, {
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
	if type == "rock" then
		table.insert(props, {
			--dimensions
			x = x or 0, -- xco-ord
			y = y or 0, -- yco-ord
			w = 80, -- width
			h = 50, -- height
			--properties
			name = "rock",
			gfx = rock,
		})
		print("rock added @  X:"..x.." Y: "..y)
	end
	if type == "spring" then
		table.insert(props, {
			--dimensions
			x = x or 0, -- xco-ord
			y = y or 0, -- yco-ord
			w = 40, -- width
			h = 30, -- height
			--properties
			name = "spring",
			gfx = spring,
			vel = 1500,
		})
		print("spring added @  X:"..x.." Y: "..y)
	end
	
end

function props:draw()
	local count = 0
	
	for i, object in ipairs(props) do
		if world:inview(object) then
			count = count +1
				

			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(object.gfx, object.x,object.y,0, 1, 1)


			if editing then
				props:drawDebug(object, i)
			end

		end
	end

	world.props = count
end

function props:drawDebug(prop, i)
	--requires graphic, implement all pickups as graphics/image
	love.graphics.setColor(255,0,155,100)
	love.graphics.rectangle(
		"line", 
		prop.x, 
		prop.y, 
		prop.gfx:getWidth(), 
		prop.gfx:getHeight()
	)
	
	if prop.name == "spring" then
		love.graphics.setColor(155,255,55,200)
		love.graphics.rectangle(
			"line", 
			prop.x+10, 
			prop.y+10, 
			prop.gfx:getWidth()-20, 
			prop.gfx:getHeight()-20
		)
	end
	
	util:drawid(prop, i)
	util:drawCoordinates(prop)
end
