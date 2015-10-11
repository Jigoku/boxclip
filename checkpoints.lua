checkpoints = {}

function checkpoints:add(x,y)
	table.insert(platforms, {
		x = x or 0,
		y = y or 0,
		w = 5,
		h = 50,
		name = "checkpoint",
	})
end

function checkpoints:draw()
	local count = 0
	
	local i, checkpoint
	for i, checkpoint in ipairs(checkpoints) do
		if world:inview(checkpoint) then
		count = count + 1

			if checkpoint.name == "checkpoint" then
				love.graphics.setColor(255,255,255,100)
				love.graphics.rectangle("fill", checkpoint.x, checkpoint.y, checkpoint.w, checkpoint.h)	
			end
			if debug == 1 then
				self:drawDebug(checkpoint, i)
			end
		end
	end
	world.checkpoints = count
end


function checkpoints:drawDebug(checkpoint, i)

	-- collision area
	if platform.name == "platform" then
		love.graphics.setColor(255,0,0,100)
		love.graphics.rectangle("line", checkpoint.x, checkpoint.y, checkpoint.w, checkpoint.h)
	end
	
	util:drawid(checkpoint,i)
	util:drawCoordinates(checkpoint)
	
end


