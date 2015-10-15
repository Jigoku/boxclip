util = {}
console = false

function math.round(num, idp)
	-- round integer to decimal places
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function ripairs(t)
	--same as ipairs, but reversed order
	local function ripairs_it(t,i)
		i=i-1
		local v=t[i]
		if v==nil then return v end
		return i,v
	end
	return ripairs_it, t, #t+1
end


function split(s, delimiter)
	--split string into a table
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end


function util:drawCoordinates(object)
	if editor.showpos then
		-- co-ordinates
		love.graphics.setColor(255,255,255,100)
		love.graphics.print("X:".. math.round(object.x,0) ..",Y:" .. math.round(object.y,0) , object.x-20,object.y-20,0, 0.9*camera.scaleX, 0.9*camera.scaleY)  
	end
end


function util:drawConsole()
	if console then
	
		--console info
		love.graphics.setColor(0,0,0,100)
		love.graphics.rectangle("fill", 1, 1, 700, 80)	
		love.graphics.setColor(100,100,100,100)
		love.graphics.rectangle("line", 1, 1, 700, 80)	
		
		love.graphics.setColor(100,255,100,255)
		love.graphics.print("FPS: " .. love.timer.getFPS(), 5,5)
		
		if not (mode == "title") then
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(
			"X: " .. math.round(player.x,0) .. 
			" | Y: " .. math.round(player.y,0) .. 
			" | dir: " .. player.dir .. 
			" | xvel: " .. math.round(player.xvel,0) .. 
			" | yvel: " .. math.round(player.yvel,0) .. 
			" | jumping: " .. player.jumping ..
			" | camera scale: " .. camera.scaleX, 
			5, 20
		)
		

		love.graphics.setColor(255,100,255,255)
		love.graphics.print(
			"pickups: " .. world:count(pickups) .. "(".. world.pickups .. ")" ..
			" | enemies: " .. world:count(enemies) .. "(".. world.enemies .. ")" ..
			" | platforms: " .. world:count(platforms) .. "(".. world.platforms .. ")" ..
			" | crates: " .. world:count(crates) .. "("..world.crates .. ")" ..
			" | checkpoints: " .. world:count(checkpoints) .. "("..world.checkpoints .. ")" ..
			" | total: " ..world:count(pickups)+world:count(enemies)+world:count(platforms)+world:count(crates)+world:count(checkpoints) .. "(" .. world.pickups+world.enemies+world.platforms+world.crates+world.checkpoints .. ")",
			5, 35
		)

		
		love.graphics.setColor(255,100,40,255)
		love.graphics.print(
			"[lives: " .. player.lives .. "][score: " .. player.score .. "][time: " .. 
			world:gettime() .. "][alive: " .. player.alive .."]", 
			5,50
		)
		end
		love.graphics.setColor(255,255,255,255)
		love.graphics.print('Memory (kB): ' .. math.round(collectgarbage('count')) .. " entsel: " .. editor.entsel .. " entdir: " .. editor.entdir, 5,65)
		

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
	if console then
		print(out)
	end
end


