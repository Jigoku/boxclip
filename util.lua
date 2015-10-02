util = {}


function util:round(num, idp)
	-- round integer to decimal places
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end


function util:drawCoordinates(object)
	-- co-ordinates
	love.graphics.setColor(255,255,255,100)
	love.graphics.print("X:".. self:round(object.x,0) ..",Y:" .. self:round(object.y,0)  , object.x-20,object.y-20)  
end


function util:drawConsole()
	if debug == 1 then
	
		--console info
		love.graphics.setColor(0,0,0,100)
		love.graphics.rectangle("fill", 1, 1, 500, 80)	
		love.graphics.setColor(100,100,100,100)
		love.graphics.rectangle("line", 1, 1, 500, 80)	
		
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("FPS: " .. love.timer.getFPS(), 2,2)
		love.graphics.print(
			"X: " .. self:round(player.x,0) .. 
			" | Y: " .. self:round(player.y,0) .. 
			" | dir: " .. player.dir .. 
			" | xvel: " .. self:round(player.xvel,0) .. 
			" | yvel: " .. self:round(player.yvel,0) .. 
			" | jumping: " .. player.jumping .. 
			" | pickups: " .. pickups:count(), 
			2, 20
		)
		love.graphics.print("SCORE: " .. player.score .. "| TIME: " .. world:time() .. " | ALIVE: " .. player.alive , 2,40)
	end
end


function util:dprint(out)
	-- add this to a console buffer maybe
	if debug == 1 then
		print(out)
	end
end
