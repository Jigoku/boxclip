--[[
 * Copyright (C) 2015 - 2018 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 --]]
 
coins = {}
coins.magnet_power = 200

coins.textures = {
	["rotate"] = textures:load("data/images/coin/rotate/"),
	["blink" ] = textures:load("data/images/coin/blink/" ),
	["shine" ] = textures:load("data/images/coin/shine/" ),
}

table.insert(editor.entities, {"coin", "coin"})

		
		
function coins:add(x,y)

	table.insert(world.entities.coin, {
		x = x or 0,
		y = y or 0,
		w = self.textures["rotate"][1]:getWidth(),
		h = self.textures["rotate"][1]:getHeight(),
		group = "coins",
		collected = false,
		attract = false,
		bounce = true,	
		state = "rotate",
		xvel = 0,
		yvel = 0,
		score = 100,
		frame = 1,
		framecycle = 0,
		framedelay = 0.03,
	})	

	print( "coin added @  X:"..x.." Y: "..y)
		
end


function coins:update(dt)
	for i, coin in ipairs(world.entities.coin) do		
		if world:inview(coin) then
			if coin.bounce then 
				coin.state = "rotate"
				coin.framedelay = 0.03
			else
				coin.state = "shine"
				coin.framedelay = 0.05
			end
	
			if #self.textures[coin.state] > 1 then
				coin.framecycle = math.max(0, coin.framecycle - dt)
			
				if coin.framecycle <= 0 then
					coin.frame = coin.frame + 1
				
					if coin.frame > #self.textures[coin.state] then
						coin.frame = 1
					end
			
					coin.framecycle = coin.framedelay
				end
				
				coin.texture = self.textures[coin.state][math.min(coin.frame, #self.textures[coin.state])]

				--update bounds
				coin.w = coin.texture:getWidth()
				coin.h = coin.texture:getHeight()
			end
		end
	
		
		if not coin.collected then
			--pulls all coins to player when attract = true
			if coin.attract then
				coin.state = "rotate"
				coin.speed = coin.speed + (coins.magnet_power*2) *dt
				if player.alive then
					local angle = math.atan2(player.y+player.h/2 - coin.h/2 - coin.y, player.x+player.w/2 - coin.w/2 - coin.x)
					coin.newX = coin.x + (math.cos(angle) * coin.speed * dt)
					coin.newY = coin.y + (math.sin(angle) * coin.speed * dt)
				end
			else
				coin.speed = 100
				physics:applyGravity(coin, dt)
				physics:applyVelocity(coin,dt)
				physics:traps(coin,dt)
				physics:platforms(coin, dt)
				physics:crates(coin, dt)			
			end
			
			physics:update(coin)
			
			if mode == "game" and not coin.collected then	
				if player.hasmagnet then
					if collision:check(player.x-coins.magnet_power,player.y-coins.magnet_power,
						player.w+(coins.magnet_power*2),player.h+(coins.magnet_power*2),
						coin.x-coin.w/2, coin.y,coin.w,coin.h) then

						if not coin.attract then
							coin.attract = true
						end
					end
				end
			
				if player.alive and collision:check(player.x,player.y,player.w,player.h,
					coin.x-coin.w/2, coin.y,coin.w,coin.h) then
					
					--collect coin
					sound:play(sound.effects["gem"])
					player.score = player.score + coin.score
					coin.collected = true
					popups:add(coin.x+coin.w/2,coin.y+coin.h/2,"+"..coin.score)
					console:print(coin.group.."("..i..") collected")	
					
				end
			end	
		end
	end
end



function coins:draw()
	local count = 0
	for i, coins in ipairs(world.entities.coin) do
		if not coins.collected and world:inview(coins) then
			count = count + 1
			
			local texture = self.textures[coins.state][coins.frame]
			
			love.graphics.setColor(1,1,1,1)	
			love.graphics.draw(texture, coins.x-coins.w/2, coins.y, 0, 1, 1)

			if editing or debug then
				love.graphics.setColor(0.39,1,0.39,0.39)
				love.graphics.rectangle(
					"line", 
					coins.x-coins.w/2, 
					coins.y, 
					coins.w,
					coins.h
				)
			end
		end
	end
	world.coins = count
end


