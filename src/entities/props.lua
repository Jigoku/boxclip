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

props = {}
props.path = "data/images/props/"

props.list = {}
for _,prop in ipairs(love.filesystem.getDirectoryItems(props.path)) do
	--possibly merge this into shared function ....
	--get file name without extension
	local name = prop:match("^(.+)%..+$")
	--store list of prop names
	table.insert(props.list, name)
	--insert into editor menu
	table.insert(editor.entities, {name, "prop"})
end

--load the textures
props.textures = textures:load(props.path)


function props:add(x,y,dir,flip,type)

	for i,prop in ipairs(props.list) do
		--maybe better way to do this?
		--loop over entity.list, find matching name
		-- then only insert when a match is found
		if prop == type then
			local w,h
			if dir == 0 or dir == 2 then
				w = self.textures[i]:getWidth()
				h = self.textures[i]:getHeight()
				end
			if dir == 3 or dir == 1 then
				w = self.textures[i]:getHeight()
				h = self.textures[i]:getWidth()
			end

			table.insert(world.entities.prop, {
				x = x or 0,
				y = y or 0,
				w = w,
				h = h,
				dir = dir,
				flip = flip,
				slot = i,
				group = "prop",
				type = type,

				editor_canrotate = true,
				editor_canflip = true
			})
			print(type .. " added @  X:"..x.." Y: "..y)
			return
		end
	end
end


function props:draw()
	local count = 0

	for i, prop in ipairs(world.entities.prop) do
		if world:inview(prop) then
			count = count +1

			if prop.type == "arch" or prop.type == "arch2" or prop.type == "arch3"
			or prop.type == "arch3_end" or prop.type == "arch3_pillar"
			then
				love.graphics.setColor(
					platform_r,
					platform_g,
					platform_b,
					1
				)
			elseif prop.type == "porthole" or prop.type == "arch1_r" then
				love.graphics.setColor(
					platform_behind_r,
					platform_behind_g,
					platform_behind_b,
					1
				)
			else
				love.graphics.setColor(1,1,1,1)
			end

			local texture = props.textures[prop.slot]

			if prop.dir == 1 then
				love.graphics.draw(texture, prop.x, prop.y, math.rad(90),1,(prop.flip and -1 or 1),0,(prop.flip and 0 or prop.w))
			elseif prop.dir == 2 then
				love.graphics.draw(texture, prop.x, prop.y, 0,(prop.flip and 1 or -1),-1,(prop.flip and 0 or prop.w),prop.h)
			elseif prop.dir == 3 then
				love.graphics.draw(texture, prop.x, prop.y, math.rad(-90),1,(prop.flip and -1 or 1),prop.h,(prop.flip and prop.w or 0))
			else
				love.graphics.draw(texture, prop.x, prop.y, 0,(prop.flip and -1 or 1),1,(prop.flip and prop.w or 0),0,0)
			end

			if editing or debug then
				props:drawdebug(prop, i)
			end

		end
	end

	world.props = count
end


function props:drawdebug(prop, i)
	love.graphics.setColor(1,0,0.60,0.39)
	love.graphics.rectangle(
		"line",
		prop.x,
		prop.y,
		prop.w,
		prop.h
	)
end
