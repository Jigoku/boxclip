pickups = {}



function pickups:random(path)
	return love.graphics.newImage( path .. string.format("%04d",math.random(1, 7)) .. ".png")
end

function pickups:gem(x,y)
	table.insert(pickups, {
		x =x or 0,
		y =y or 0,
		name = "gem",
		gfx = self:random("graphics/gems/"),
	})	
end

function pickups:life(x,y,w,h)
	table.insert(pickups, {
		x =x or 0,
		y =y or 0,
		w =w or 10,
		h =h or 10,
		name = "life",
		gfx = love.graphics.newImage( "graphics/gems/" .. string.format("%04d",math.random(1, 7))  .. ".png"),
	})
end

function pickups:draw()
	local i, pickup
	for i, pickup in ipairs(pickups) do
			
		if pickup.name == "gem" then
			love.graphics.setColor(255,255,255, 150)	
			love.graphics.draw(
				pickup.gfx, pickup.x-pickup.gfx:getWidth()/2, 
				pickup.y-pickup.gfx:getHeight()/2, 0, 1, 1
			)
		end
			
		if pickup.name == "life" then
			love.graphics.setColor(255,0,0, 255)	
			love.graphics.circle("fill", pickup.x, pickup.y, pickup.w, pickup.h)
			love.graphics.setColor(255,255,255,255)
			love.graphics.circle("line", pickup.x, pickup.y, pickup.w, pickup.h)
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
		pickup.x-pickup.gfx:getWidth()/2, 
		pickup.y-pickup.gfx:getHeight()/2, 
		pickup.gfx:getWidth(), 
		pickup.gfx:getHeight()
	)
	util:drawCoordinates(pickup)
end

function pickups:destroy(pickups, id)
	table.remove(pickups, i)
end


function pickups:count()
	local count = 0
	for n, pickup in pairs(pickups) do 
		if type(pickup) == "table" then
			count = count + 1 
		end
	end
	return count
end
