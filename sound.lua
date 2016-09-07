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

-- add menu / keybind to toggle this
sound.enabled = true

-- sound data paths
local sfx     = "data/sounds/effect/" 
local music   = "data/sounds/music/"  
local ambient = "data/sounds/ambient/"

-- place effect filepaths here
sound.jump = love.audio.newSource(sfx .. "jump.ogg", "static")
sound.gem = love.audio.newSource(sfx .. "gem.ogg", "static")
sound.hit = love.audio.newSource(sfx .. "hit.ogg", "static")
sound.beep = love.audio.newSource(sfx .. "beep.ogg", "static")
sound.die = love.audio.newSource(sfx .. "die.ogg", "static")
sound.crate = love.audio.newSource(sfx .. "crate.ogg", "static")
sound.lifeup = love.audio.newSource(sfx .. "lifeup.ogg", "static")
sound.kill = love.audio.newSource(sfx .. "kill.ogg", "static")
sound.checkpoint = love.audio.newSource(sfx .. "checkpoint.ogg", "static")
sound.goal = love.audio.newSource(sfx .. "goal.ogg", "static")
sound.spring = love.audio.newSource(sfx .. "spring.ogg", "static")
sound.blip = love.audio.newSource(sfx .. "blip.ogg", "static")
sound.magnet = love.audio.newSource(sfx .. "magnet.ogg", "static")
sound.shield = love.audio.newSource(sfx .. "shield.ogg", "static")
sound.creak = love.audio.newSource(sfx .. "creak.ogg", "static")


function sound:playbgm(id)
	if not sound.enabled then return true end
	
	--set by "mapmusic=N" within a map file
	if id == 0 then  sound.bgm = nil end
	if id == 1 then  sound.bgm = love.audio.newSource(music .. "jungle.ogg") end
	if id == 2 then  sound.bgm = love.audio.newSource(music .. "underwater.ogg") end
	if id == 3 then  sound.bgm = love.audio.newSource(music .. "walking.ogg") end
	if id == 4 then  sound.bgm = love.audio.newSource(music .. "intense.ogg") end
	if id == 5 then  sound.bgm = love.audio.newSource(music .. "busy.ogg") end
	if id == 6 then  sound.bgm = love.audio.newSource(music .. "tropics.ogg") end
	
	love.audio.stop()

	if id ~= 0 then
		sound.bgm:setLooping(true)
		sound.bgm:setVolume(0.5)
		sound.bgm:play()
	end
end

function sound:playambient(id)
	if not sound.enabled then return true end
	
	if id == 0 then  sound.ambient = nil end
	if id == 1 then  sound.ambient = love.audio.newSource(ambient .. "swamp.ogg") end
	if id == 2 then  sound.ambient = love.audio.newSource(ambient .. "stream.ogg") end
	if id == 3 then  sound.ambient = love.audio.newSource(ambient .. "drip.ogg") end
	if id == 4 then  sound.ambient = love.audio.newSource(ambient .. "storm.ogg") end

	if id ~= 0 then
		sound.ambient:setLooping(true)
		sound.ambient:setVolume(1)
		sound.ambient:play()
	end
end


function sound:play(effect)
	if not sound.enabled then return true end
	
	--improve this (temporary fix)
	--allows sound to be played in quick succession
	if effect:isPlaying() then
		effect:stop()
	end
	effect:play()
end

