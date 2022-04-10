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

collision = {}

function collision:checkWorld(dt)
	if not editing and player.alive then
		self:bounds()
	end
end


function collision:check(x1,y1,w1,h1, x2,y2,w2,h2)
	world.collision = world.collision +1
	return x1 < x2+w2 and
		 x2 < x1+w1 and
		 y1 < y2+h2 and
		 y2 < y1+h1
end


function collision:inside(a,b)
	--if( (a.newX  + a.w > b.x and and a.x+a.w > b.x) and (a.newX < b.x+b.w and a.x > b.x+b.w))
end

function collision:right(a,b)
	world.collision = world.collision +1
	return a.newX < b.x+b.w and a.x > b.x+b.w
end


function collision:left(a,b)
	world.collision = world.collision +1
	return a.newX+a.w > b.x and a.x+a.w < b.x
end


function collision:top(a,b)
	world.collision = world.collision +1
	return a.newY+a.h > b.y and a.y+a.h-10 < b.y

end


function collision:bottom(a,b)
	world.collision = world.collision +1
	return a.newY < b.y+b.h and a.y > b.y+b.h
end


function collision:above(a,b)
	--use this for a bigger intersect, eg; attacking a small enemy from above
	world.collision = world.collision +1
	return a.newY+a.h > b.y and a.y-a.h < b.y
end


function collision:bounds()
	-- we might not need these, if map size can be unlimited?
	--if player.x < 0 then
	--	player.x = 0
	--	player.xvel = 0
	--end
end

