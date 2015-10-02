
-- round integer to decimal places
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end




-- dbeug drawing

function drawCoordinates(object)
	-- co-ordinates
	love.graphics.setColor(255,255,255,100)
	love.graphics.print("X:".. round(object.x,0) ..",Y:" .. round(object.y,0)  , object.x-20,object.y-20)  
end

function drawConsole()
	if debug == 1 then
		--console info
		love.graphics.setColor(0,0,0,100)
		love.graphics.rectangle("fill", 1, 1, 500, 80)	
		love.graphics.setColor(100,100,100,100)
		love.graphics.rectangle("line", 1, 1, 500, 80)	
		
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("FPS: " .. love.timer.getFPS(), 2,2)
		love.graphics.print(
			"X: " .. round(player.x,0) .. 
			" | Y: " .. round(player.y,0) .. 
			" | dir: " .. player.dir .. 
			" | xvel: " .. round(player.xvel,0) .. 
			" | yvel: " .. round(player.yvel,0) .. 
			" | jumping: " .. player.jumping .. 
			" | pickups: " .. countPickups(), 
			2, 20
		)
		love.graphics.print("SCORE: " .. player.score .. "| TIME: " .. worldTime() .. " | ALIVE: " .. player.alive , 2,40)
	end
end

function dprint(out)
	if debug == 1 then
		print(out)
	end
end
