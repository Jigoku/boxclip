pickups = {}

pickups.w = 40
pickups.h = 40

pickups.gem = love.graphics.newImage("graphics/pickups/gem.png")
pickups.life = love.graphics.newImage( "graphics/pickups/heart.png")

function pickups:random(path)
	--return love.graphics.newImage( path .. string.format("%04d",math.random(1, 7)) .. ".png")

end

function pickups:add(x,y,item)
	if item == "gem" then
		table.insert(pickups, {
			x =x or 0,
			y =y or 0,
			w = pickups.w,
			h = pickups.h,
			name = "gem",
			gfx = pickups.gem,
			collected = false,
			red = math.random(100,255),
			green = math.random(200,255),
			blue = math.random(100,255),
			mass = 800,
			xvel = 0,
			yvel = 0,
		})	
	elseif item =="life" then
		table.insert(pickups, {
			x =x or 0,
			y =y or 0,
			w = pickups.w,
			h = pickups.w,
			name = "life",
			gfx = pickups.life,
			collected = false,
			mass = 800,
			xvel = 0,
			yvel = 0
		})
	else
		util:dprint("error: unknown pickup type")
	end
end


function pickups:draw()
	local count = 0
	local i, pickup
	for i, pickup in ipairs(pickups) do
		if not pickup.collected and world:inview(pickup) then
			count = count + 1
			
			if pickup.name == "gem" then
				love.graphics.setColor(pickup.red,pickup.green,pickup.blue,255)	
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
		
			if editing then
				pickups:drawDebug(pickup, i)
			end
		end
	end
	world.pickups = count
end



function pickups:drawDebug(pickup, i)
	--requires graphic, implement all pickups as graphics/image
	love.graphics.setColor(100,255,100,100)
	love.graphics.rectangle(
		"line", 
		pickup.x, 
		pickup.y, 
		pickup.gfx:getWidth(), 
		pickup.gfx:getHeight()
	)
	util:drawid(pickup, i)
	util:drawCoordinates(pickup)
end

function pickups:destroy(pickups, i)
	-- fade/collect animation can be added
	table.remove(pickups, i)
end




