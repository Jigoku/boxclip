checkpoints = {}

function checkpoints:add(x,y)
	table.insert(checkpoints, {
		x = x or 0,
		y = y or 0,
		w = 5,
		h = 50,
		name = "checkpoint",
		activated = false
	})
	print( "checkpoint added @  X:"..x.." Y: "..y)
end

function checkpoints:draw()
	local count = 0
	
	local i, checkpoint
	for i, checkpoint in ipairs(checkpoints) do
		if world:inview(checkpoint) then
		count = count + 1

			if not checkpoint.activated then
				love.graphics.setColor(255,255,255,100)
			else 
				love.graphics.setColor(200,200,200,255)
			end
			love.graphics.rectangle("fill", checkpoint.x, checkpoint.y, checkpoint.w, checkpoint.h)	
			
			if editing then
				self:drawDebug(checkpoint, i)
			end
		end
	end
	world.checkpoints = count
end


function checkpoints:drawDebug(checkpoint, i)

	-- collision area
	love.graphics.setColor(255,0,0,100)
	love.graphics.rectangle("line", checkpoint.x, checkpoint.y, checkpoint.w, checkpoint.h)
	
	util:drawid(checkpoint,i)
	util:drawCoordinates(checkpoint)
	
end
