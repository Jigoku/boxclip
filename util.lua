util = {}


function util:round(num, idp)
	-- round integer to decimal places
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function util:ripairs(t)
	local function ripairs_it(t,i)
		i=i-1
		local v=t[i]
		if v==nil then return v end
		return i,v
	end
	return ripairs_it, t, #t+1
end


function util:drawCoordinates(object)
	if editor.showpos then
		-- co-ordinates
		love.graphics.setColor(255,255,255,100)
		love.graphics.print("(X:".. self:round(object.x,0) ..",Y:" .. self:round(object.y,0) ..")" , object.x-20,object.y-20,0, 0.9*camera.scaleX, 0.9*camera.scaleY)  
	end
end


function util:drawConsole()
	if debug == 1 then
	
		--console info
		love.graphics.setColor(0,0,0,100)
		love.graphics.rectangle("fill", 1, 1, 500, 80)	
		love.graphics.setColor(100,100,100,100)
		love.graphics.rectangle("line", 1, 1, 500, 80)	
		
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("FPS: " .. love.timer.getFPS(), 5,5)
		love.graphics.print(
			"X: " .. self:round(player.x,0) .. 
			" | Y: " .. self:round(player.y,0) .. 
			" | dir: " .. player.dir .. 
			" | xvel: " .. self:round(player.xvel,0) .. 
			" | yvel: " .. self:round(player.yvel,0) .. 
			" | jumping: " .. player.jumping ,
			5, 20
		)
		love.graphics.print(
			"pickups: " .. world:count(pickups) .. "(".. world.pickups .. ")" ..
			" | enemies: " .. world:count(enemies) .. "(".. world.enemies .. ")" ..
			" | platforms: " .. world:count(platforms) .. "(".. world.platforms .. ")" ..
			" | crates: " .. world:count(crates) .. "("..world.crates .. ")" ..
			" | camera scale: " .. camera.scaleX, 
			5, 35
		)
		
		love.graphics.setColor(255,100,40,255)
		love.graphics.print(
			"[life: " .. player.life .. "][score: " .. player.score .. "][time: " .. 
			world:gettime() .. "][alive: " .. player.alive .."]", 
			5,50
		)
		love.graphics.setColor(255,255,255,255)
		love.graphics.print('Memory (kB): ' .. util:round(collectgarbage('count')) .. " entsel: " .. editor.entsel, 5,65)
		

	end
end

function util:drawid(entity,i)
	if editor.showid then
		love.graphics.setColor(255,255,0,100)       
		love.graphics.print(entity.name .. "(" .. i .. ")", entity.x-20, entity.y-40, 0, 0.9*camera.scaleX, 0.9*camera.scaleY)
	end
end

function util:dprint(out)
	-- add this to a console buffer maybe
	if debug == 1 then
		print(out)
	end
end


