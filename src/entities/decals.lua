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


 -- NOTE these are now drawn above player.
 -- implement a decal_b entity for decals that should be on the rear layer behind everything else

require("shader")
decals = {}
decals.textures = textures:load("data/images/decals/")
decals.waterfall_texture = love.graphics.newImage("data/images/tiles/waterfall.png")
decals.waterfall_spin = 0

--make sure the texture repeats
for _,texture in pairs(decals.textures) do
	texture:setWrap("repeat", "repeat")
end

table.insert(editor.entities, {"decal", "decal"})


function decals:add(x,y,w,h,scrollspeed,texture)
	table.insert(world.entities.decal, {
		--position
		x = x or 0,
		y = y or 0,
		w = w or 10,
		h = h or 10,

		--properties
		scroll = 0,
		scrollspeed = scrollspeed or 100,
		texture = texture or 1,
		group = "decal",
		quad = love.graphics.newQuad( x,y,w,h, self.textures[texture]:getDimensions()),
		shader = love.graphics.newShader(shader.decal)
	})
end


function decals:update(dt)
	for i, decal in ipairs(world.entities.decal) do
		if world:inview(decal) then
			decal.shader:send("millis", love.timer.getTime())
			decal.shader:send("speed", decal.scrollspeed)
		end
	end

	if world.decals and world.decals > 0 then
		self.waterfall_spin = self.waterfall_spin + dt * 10
		self.waterfall_spin = self.waterfall_spin % (2*math.pi)
	end
end


function decals:draw()
	local count = 0
	for i, decal in ipairs(world.entities.decal) do
		if world:inview(decal) then
			count = count + 1
			love.graphics.setShader(decal.shader)
			local texture = self.textures[decal.texture]
			love.graphics.setColor(1,1,1,0.6)
			love.graphics.draw(texture, decal.quad, decal.x,decal.y)
			love.graphics.setShader()
			self:drawwaterfall(decal)
		end
	end
	world.decals = count
end


function decals:drawwaterfall(decal)
	local texture = self.waterfall_texture

	local x,y = camera:toCameraCoords(decal.x,decal.y)
	love.graphics.setScissor(
		x,
		y-texture:getHeight()*camera.scale,
		decal.w*camera.scale,
		texture:getHeight()*camera.scale*2
	)

	if decal.texture == 1 then
		love.graphics.setColor(0.74,0.94,1,1)
	elseif decal.texture == 2 then
		love.graphics.setColor(0.61,0.74,0.59,1)
	elseif decal.texture == 3 then
		love.graphics.setColor(0.50,0.15,0.15,1)
	elseif decal.texture == 4 then
		love.graphics.setColor(0.67,0.32,0.05,1)
	end

	for i=0, decal.w+1, texture:getWidth()/2 do
		love.graphics.draw(texture, decal.x+i,decal.y,
			(love.math.random(0,1) == 1 and self.waterfall_spin or -self.waterfall_spin),
			1,1,texture:getWidth()/2,texture:getHeight()/2
		)
	end

	love.graphics.setScissor()
end
