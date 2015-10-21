--[[
 * Copyright (C) 2015 Ricky K. Thomson
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
 
 sound = {}

local fx = "sounds/effect/" --effects path
local mt = "sounds/music/"  --music tracks path

-- place effect filepaths here
sound.jump = love.audio.newSource(fx .. "jump.ogg", "static")
sound.gem = love.audio.newSource(fx .. "gem.ogg", "static")
sound.hit = love.audio.newSource(fx .. "hit.ogg", "static")
sound.beep = love.audio.newSource(fx .. "beep.ogg", "static")
sound.die = love.audio.newSource(fx .. "die.ogg", "static")
sound.crate = love.audio.newSource(fx .. "crate.ogg", "static")
sound.lifeup = love.audio.newSource(fx .. "lifeup.ogg", "static")
sound.kill = love.audio.newSource(fx .. "kill.ogg", "static")
sound.checkpoint = love.audio.newSource(fx .. "checkpoint.ogg", "static")
sound.goal = love.audio.newSource(fx .. "goal.ogg", "static")
sound.spring = love.audio.newSource(fx .. "spring.ogg", "static")

sound.bgm = nil

function sound:playbgm(id)
	--set by "mapmusic=N" within a map file
	if id == "1" then  sound.bgm = love.audio.newSource(mt .. "jungle.ogg") end
	if id == "2" then  sound.bgm = love.audio.newSource(mt .. "underwater.ogg") end
	if id == "3" then  sound.bgm = love.audio.newSource(mt .. "walking.ogg") end
	if id == "4" then  sound.bgm = love.audio.newSource(mt .. "intense.ogg") end
	if id == "5" then  sound.bgm = love.audio.newSource(mt .. "busy.ogg") end
	
	love.audio.stop()

	sound.bgm:setLooping(true)
	sound.bgm:setVolume(0.5)
	sound.bgm:play()
end

function sound:play(effect)
	--improve this (temporary fix)
	--allows sound to be played in quick succession
	if effect:isPlaying() then
		effect:stop()
	end
	effect:play()
end

