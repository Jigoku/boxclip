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



enemies = {}

-- TODO, split this up into seperate entities...
-- eg; floater.lua, walker.lua, etc

-- List of enemies 
enemies.list = {}

enemies.textures = {["icicle_d"] = { love.graphics.newImage( "data/images/enemies/icicle_d.png"),},}	

table.insert(editor.entities, {"spikeball", "enemy"})


function enemies:add(x,y,movespeed,movedist,dir,name)
	print("name ent:"..name)
	_G[name].worldInsert(x,y,movespeed,movedist,dir,name)
	print( name .. " added @  X:"..x.." Y: "..y)
end


function enemies:update(dt)
	for i, enemy in ipairs(world.entities.enemy) do
	
		--animate frames if given
		if #self.textures[enemy.type] > 1 then
			enemy.framecycle = math.max(0, enemy.framecycle - dt)
			
			if enemy.framecycle <= 0 then
				enemy.frame = enemy.frame + 1
				
				if enemy.frame > #self.textures[enemy.type] then
					enemy.frame = 1
				end
			
				enemy.framecycle = enemy.framedelay
			end
			
			enemy.texture = self.textures[enemy.type][math.min(enemy.frame, #self.textures[enemy.type])]

			--update bounds
			enemy.w = enemy.texture:getWidth()
			enemy.h = enemy.texture:getHeight()

		end
		
		if enemy.alive then
			enemy.carried = false
		
			if enemy.type == "walker" or enemy.type == "blob" or enemy.type == "goblin" or enemy.type == "shadow" then
				_G[enemy.type].checkCollision(enemy, dt)
			end	
			
			if enemy.type == "crusher" then
				_G[enemy.type].checkCollision(enemy, dt)
			end

			if enemy.type == "hopper" then
				_G[enemy.type].checkCollision(enemy, dt)
			end	
			
			if enemy.type == "bee" or enemy.type == "bird" then
				_G[enemy.type].checkCollision(enemy, dt)
			end
			
			if enemy.type == "spike" or enemy.type == "spike_large" and enemy.alive then
				_G[enemy.type].checkCollision(enemy, dt)
			end
			
			if enemy.type == "spike_timer" then
				_G[enemy.type].checkCollision(enemy, dt)
			end
			
			if enemy.type == "icicle" then
				_G[enemy.type].checkCollision(enemy, dt)
			end
			
			if enemy.type == "spikeball" then
				_G[enemy.type].checkCollision(enemy, dt)
			end
	
		end
			
	end	
end


function enemies:draw()
	local count = 0

	for i, enemy in ipairs(world.entities.enemy) do
		if world:inview(enemy) then
		
			count = count + 1
			if enemy.alive then
			
				local texture = self.textures[enemy.type][1]
				
				if enemy.type == "bee" or enemy.type == "bird" or enemy.type == "walker" or enemy.type =="hopper" or enemy.type == "blob" or enemy.type == "goblin" or enemy.type == "shadow" then
					love.graphics.setColor(1,1,1,1)
					if enemy.movespeed < 0 then
						love.graphics.draw(enemy.texture, enemy.x, enemy.y, 0, 1, 1)
					elseif enemy.movespeed > 0 then
						love.graphics.draw(enemy.texture, enemy.x+enemy.w, enemy.y, 0, -1, 1)
					end
				end
				
					
				if enemy.type == "spike" or enemy.type == "spike_large" and enemy.alive then
					love.graphics.setColor(1,1,1,1)
					if enemy.dir == 1 then
						love.graphics.draw(texture, enemy.x, enemy.y, math.rad(90),1,(enemy.flip and -1 or 1),0,(enemy.flip and 0 or enemy.w))
					elseif enemy.dir == 2 then
						love.graphics.draw(texture, enemy.x, enemy.y, 0,(enemy.flip and 1 or -1),-1,(enemy.flip and 0 or enemy.w),enemy.h)	
					elseif enemy.dir == 3 then
						love.graphics.draw(texture, enemy.x, enemy.y, math.rad(-90),1,(enemy.flip and -1 or 1),enemy.h,(enemy.flip and enemy.w or 0))
					else
						love.graphics.draw(texture, enemy.x, enemy.y, 0,(enemy.flip and -1 or 1),1,(enemy.flip and enemy.w or 0),0,0)
					end
				end
			
				if enemy.type == "spike_timer" then
					love.graphics.setColor(1,1,1,1)
					local x,y = camera:toCameraCoords(enemy.xorigin, enemy.yorigin)
					love.graphics.setScissor( x,y,enemy.w*camera.scale,enemy.h*camera.scale)
					love.graphics.draw(texture, enemy.x, enemy.y, 0,1,1)
					love.graphics.setScissor()
				end
			
				if enemy.type == "icicle" or enemy.type == "icicle_d" or enemy.type == "crusher" then
					love.graphics.setColor(1,1,1,1)
					love.graphics.draw(texture, enemy.x, enemy.y, 0,1,1)
				end
			
				if enemy.type == "spikeball" then
					love.graphics.setColor(1,1,1,1)
					chainlink:draw(enemy)
					
					--spin
					love.graphics.draw(texture, enemy.x, enemy.y, -enemy.angle*2,1,1,enemy.w/2,enemy.h/2)
					
					--no spin
					--love.graphics.draw(texture, enemy.x, enemy.y, 0,1,1,enemy.w/2,enemy.h/2)
				end
			
			end
			
			if editing or debug then
				enemies:drawdebug(enemy, i)
			end
		end
	end
	world.enemies = count
end


function enemies:drawdebug(enemy, i)
	local texture = self.textures[enemy.type]

	if enemy.type == "spikeball" then
		--bounds
		love.graphics.setColor(1,0,0,1)
		love.graphics.rectangle("line", enemy.x-texture[(enemy.frame or 1)]:getWidth()/2+5, enemy.y-texture[(enemy.frame or 1)]:getHeight()/2+5, texture[(enemy.frame or 1)]:getWidth()-10, texture[(enemy.frame or 1)]:getHeight()-10)
		--hitbox
		love.graphics.setColor(1,0.78,0.39,1)
		love.graphics.rectangle("line", enemy.x-texture[(enemy.frame or 1)]:getWidth()/2, enemy.y-texture[(enemy.frame or 1)]:getHeight()/2, texture[(enemy.frame or 1)]:getWidth(), texture[(enemy.frame or 1)]:getHeight())

		--waypoint
		love.graphics.setColor(1,0,1,0.39)
		love.graphics.line(enemy.xorigin,enemy.yorigin,enemy.x,enemy.y)	
		love.graphics.circle("line", enemy.xorigin,enemy.yorigin, enemy.radius,enemy.radius)	
		
		--selectable area in editor
		love.graphics.setColor(1,0,0,0.39)
		love.graphics.rectangle("line", 
			enemy.xorigin-chainlink.textures["origin"]:getWidth()/2,enemy.yorigin-chainlink.textures["origin"]:getHeight()/2,
			chainlink.textures["origin"]:getWidth(),chainlink.textures["origin"]:getHeight()
		)

	elseif enemy.type == "spike_timer" then
		--bounds
		love.graphics.setColor(1,0,0,1)
		love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
		--hitbox
		love.graphics.setColor(1,0.78,0.39,1)
		love.graphics.rectangle("line", enemy.xorigin, enemy.yorigin, enemy.w, enemy.h*2)
	
	else
	--all other enemies
		--bounds
		love.graphics.setColor(1,0,0,1)
		love.graphics.rectangle("line", enemy.x+5, enemy.y+5, enemy.w-10, enemy.h-10)
		--hitbox
		love.graphics.setColor(1,0.78,0.39,1)
		love.graphics.rectangle("line", enemy.x, enemy.y, enemy.w, enemy.h)
	end

	--waypoint	
	if enemy.type == "walker" or enemy.type == "bee" or enemy.type == "bird" or enemy.type == "hopper" or enemy.type == "blob" or enemy.type == "goblin" or enemy.type == "shadow" then
		
		love.graphics.setColor(1,0,1,0.19)
		love.graphics.rectangle("fill", enemy.xorigin, enemy.y, enemy.movedist+texture[(enemy.frame or 1)]:getWidth(), texture[(enemy.frame or 1)]:getHeight())
		love.graphics.setColor(1,0,1,1)
		love.graphics.rectangle("line", enemy.xorigin, enemy.y, enemy.movedist+texture[(enemy.frame or 1)]:getWidth(), texture[(enemy.frame or 1)]:getHeight())
	end

end






