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


chainlink = {}

chainlink.textures = {
	["link"]   = love.graphics.newImage("data/images/tiles/link.png"),
	["origin"] = love.graphics.newImage("data/images/tiles/link_origin.png"),
}

function chainlink:draw(entity)
	--origin
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.textures["origin"], entity.xorigin-self.textures["origin"]:getWidth()/2, entity.yorigin-self.textures["origin"]:getHeight()/2, 0,1,1)

	local r = 0

	--link
	while r < entity.radius do
		r = r + self.textures["link"]:getHeight()
		local x = r * math.cos(entity.angle) + entity.xorigin
		local y = r * math.sin(entity.angle) + entity.yorigin

		love.graphics.draw(self.textures["link"], x-self.textures["link"]:getWidth()/2, y-self.textures["link"]:getHeight()/2, 0,1,1)
	end

end
