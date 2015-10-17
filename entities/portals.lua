portals = {}

goal = love.graphics.newImage("graphics/portals/goal.png")
goal_activated = love.graphics.newImage("graphics/portals/goal_activated.png")

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
	elseif type == "goal" then
		table.insert(portals, {
			--dimensions
			x = x or 0, -- xco-ord
			y = y or 0, -- yco-ord
			w = 60, -- width
			h = 60, -- height
			--properties
			name = "goal",
			activated = false,
			gfx = goal
		})
		print("goal added @  X:"..x.." Y: "..y)
	end
end

function portals:draw()
	local count = 0
	
	for i, portal in ipairs(portals) do
		if world:inview(portal) then
		count = count + 1
				
			if portal.name == "goal" then
				love.graphics.setColor(255,255,255,255)
				if not portal.activated then	
					love.graphics.draw(portal.gfx, portal.x, portal.y, 0,1,1)
				else
					love.graphics.draw(goal_activated, portal.x, portal.y, 0,1,1)
				end
			end				
				
			if editing then
				--don't need to see spawn outside of editing
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
