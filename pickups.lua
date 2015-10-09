pickups = {}



function pickups:random(path)
	return love.graphics.newImage( path .. string.format("%04d",math.random(1, 7)) .. ".png")
end

function pickups:gem(x,y)
	table.insert(pickups, {
		x =x or 0,
		y =y or 0,
		w = 40,
		h = 40,
		name = "gem",
		gfx = self:random("graphics/gems/"),

	})	
end

function pickups:life(x,y,w,h)
	table.insert(pickups, {
		x =x or 0,
		y =y or 0,
		w =w or 40,
		h =h or 40,
		name = "life",
		gfx = love.graphics.newImage( "graphics/gems/" .. string.format("%04d",math.random(1, 7))  .. ".png"),
	})
end

function pickups:draw()
	local i, pickup
	for i, pickup in ipairs(pickups) do
			
		if pickup.name == "gem" then
			love.graphics.setColor(255,255,255,200)	
			love.graphics.draw(
				pickup.gfx, pickup.x, 
				pickup.y, 0, 1, 1
			)
		end
			
		if pickup.name == "life" then
			love.graphics.setColor(255,0,0, 255)	
			love.graphics.draw(
				pickup.gfx, pickup.x, 
				pickup.y, 0, 1, 1
			)
		end
		
		if debug == 1 then
			pickups:drawDebug(pickup)
		end
	end
end



function pickups:drawDebug(pickup)
	--requires graphic, implement all pickups as graphics/image
	love.graphics.setColor(100,255,100,100)
	love.graphics.rectangle(
		"line", 
		pickup.x, 
		pickup.y, 
		pickup.gfx:getWidth(), 
		pickup.gfx:getHeight()
	)
	util:drawCoordinates(pickup)
end

function pickups:destroy(pickups, i)
	-- fade/collect animation can be added
	table.remove(pickups, i)
end




