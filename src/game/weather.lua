--[[
 * Copyright (C) 2015 - 2022 Ricky K. Thomson
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

weather = {}
weather.particles = {}
weather.maxparticles = 300

function weather:populate()
	if #self.particles < 1 then
		while #self.particles < self.maxparticles do
			local x = love.math.random(camera.x-love.graphics.getWidth()/2/camera.scale,camera.x+love.graphics.getWidth()/2/camera.scale)
			local y = love.math.random(camera.y-love.graphics.getHeight()/2/camera.scale,camera.y+love.graphics.getHeight()/2/camera.scale)
			table.insert(self.particles,{
				x = x,
				y = y,
				radius = love.math.random(2,3),
				segments = 10,
				r = love.math.random(200,255)/255,
				g = love.math.random(200,255)/255,
				b = love.math.random(200,255)/255,
				o = love.math.random(0,255)/255,
				yvel = love.math.random(10,120),
				xvel = love.math.random(0,-50)
			})
		end
	end
end


function weather:update(dt)
	if editing then
		weather.particles = {}
		return
	end

	weather:populate()

	if world.theme == "frost" then

		while #self.particles < self.maxparticles do

			local x,y
			local rand = love.math.random(1,4)
			--top
			if rand == 1 then
				x = love.math.random(camera.x-love.graphics.getWidth()/2/camera.scale,camera.x+love.graphics.getWidth()/2/camera.scale)
				y = camera.y-love.graphics.getHeight()/2/camera.scale
			--right
			elseif rand == 2 then
				x = camera.x+love.graphics.getWidth()/2/camera.scale
				y = love.math.random(camera.y-love.graphics.getHeight()/2/camera.scale,camera.y+love.graphics.getHeight()/2/camera.scale)
			--bottom
			elseif rand == 3 then
				x = love.math.random(camera.x-love.graphics.getWidth()/2/camera.scale,camera.x+love.graphics.getWidth()/2/camera.scale)
				y = camera.y+love.graphics.getHeight()/2/camera.scale
			--left
			elseif rand == 4 then
				x = camera.x-love.graphics.getWidth()/2/camera.scale
				y = love.math.random(camera.y-love.graphics.getHeight()/2/camera.scale,camera.y+love.graphics.getHeight()/2/camera.scale)
			end


			table.insert(self.particles,{
				x = x,
				y = y,
				radius = love.math.random(2,3),
				segments = 10,
				r = love.math.random(200,255)/255,
				g = love.math.random(200,255)/255,
				b = love.math.random(200,255)/255,
				o = love.math.random(0,255)/255,
				yvel = love.math.random(10,120),
				xvel = love.math.random(0,-50)
			})
		end


		for i,snow in ipairs(self.particles) do
			snow.y = snow.y + snow.yvel * dt
			snow.x = snow.x + snow.xvel * dt

			snow.y = snow.y + player.yvel/10 * dt
			snow.x = snow.x - player.xvel/10 * dt

			snow.o = snow.o - 0.075 *dt


			if snow.y > camera.y+love.graphics.getHeight()/2/camera.scale
			or snow.y < camera.y-love.graphics.getHeight()/2/camera.scale
			or snow.x > camera.x+love.graphics.getWidth()/2/camera.scale
			or snow.x < camera.x-love.graphics.getWidth()/2/camera.scale
			or snow.o < 0 then table.remove(self.particles,i)
			end
		end
	else
		self.particles = {}
	end
end



function weather:draw()
	if editing then return end

	if world.theme == "frost" then
		for i,particle in ipairs(self.particles) do
			love.graphics.setColor(particle.r,particle.g,particle.b,particle.o)
			love.graphics.circle("fill", particle.x,particle.y,particle.radius,particle.segments)
		end
	end
end
