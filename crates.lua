crates = {}
crate = love.graphics.newImage("graphics/crate.png")

function crates:add(x,y,item)
	table.insert(crates, {
		x = x or 0,
		y = y or 0,
		w = 50,
		h = 50,
		name = "crate",
		item = item or nil,
		gfx = crate,
	})
end

function crates:destroy(crate, i)
	--add the contents of destroyable to world if any
	if crate.item == "gem" then
		pickups:add(crate.x+crate.w/2-pickups.w/2, crate.y+crate.h/2-pickups.h/2, "gem")
	elseif crate.item == "life" then
		pickups:add(crate.x+crate.w/2-pickups.w/2, crate.y+crate.h/2-pickups.h/2, "life")
	end
	--remove the destroyable
	table.remove(crates, i)
end


function crates:draw()
	local count = 0
	
	local i, crate
	for i, crate in ipairs(crates) do
		if world:inview(crate) then
			count = count + 1
		
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(crate.gfx,crate.x, crate.y, 0, 1, 1)
		
			if editing then
				self:drawDebug(crate, i)
			end
		end
	end
	world.crates = count
end

function crates:drawDebug(crate, i)
	love.graphics.setColor(0,255,255,100)
	love.graphics.rectangle("line", crate.x, crate.y, crate.w, crate.h)

	util:drawid(crate,i)
	util:drawCoordinates(crate)
end
