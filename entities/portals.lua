portals = {}

function portals:add(x,y,type)
	if type == "spawn" then
		table.insert(portals, {
			--dimensions
			x = x or 0, -- xco-ord
			y = y or 0, -- yco-ord
			w = player.w, -- width
			h = player.h, -- height
			--properties
			name = "spawn",
		})
		print("spawn added @  X:"..x.." Y: "..y)
	end
end

function portals:draw()
	local count = 0
	
	for i, portal in ipairs(portals) do
		if world:inview(portal) then
		count = count + 1
				
			if editing then
				if portal.name == "spawn" then
					love.graphics.setColor(255,100,0,100)
					love.graphics.rectangle("fill", portal.x,portal.y,portal.w,portal.h)
					love.graphics.setColor(255,0,0,255)
					love.graphics.rectangle("line", portal.x,portal.y,portal.w,portal.h)
				end
				portals:drawDebug(portal, i)
			end

		end
	end
	world.portals = count
end

function portals:drawDebug(portal, i)
	--requires graphic, implement all pickups as graphics/image
	util:drawid(portal, i)
	util:drawCoordinates(portal)
end
