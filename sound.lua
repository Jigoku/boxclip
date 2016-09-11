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
sound.slice = love.audio.newSource(sfx .. "slice.ogg", "static")

sound.music = {
	[0] = nil,
	[1] = love.audio.newSource("data/sounds/music/jungle.ogg"),
	[2] = love.audio.newSource("data/sounds/music/underwater.ogg"),
	[3] = love.audio.newSource("data/sounds/music/walking.ogg"),
	[4] = love.audio.newSource("data/sounds/music/intense.ogg"),
	[5] = love.audio.newSource("data/sounds/music/busy.ogg"),
	[6] = love.audio.newSource("data/sounds/music/tropics.ogg")

}

sound.ambience = {
	[0] = nil,
	[1] = love.audio.newSource("data/sounds/ambient/swamp.ogg"),
	[2] =love.audio.newSource("data/sounds/ambient/stream.ogg"),
	[3] =love.audio.newSource("data/sounds/ambient/drip.ogg"),
	[4] =love.audio.newSource("data/sounds/ambient/storm.ogg")
}


function sound:playbgm(id)
	if not sound.enabled then return true end
	
	sound.bgm = sound.music[id]
	
	for _,bgm in ipairs(sound.music) do
		bgm:stop()
	end
	love.audio.rewind( )
	
	if id ~= 0 then
		sound.bgm:setLooping(true)
		sound.bgm:setVolume(0.5)
		sound.bgm:play()
	end
end



function sound:playambient(id)
	if not sound.enabled then return true end

	sound.ambient = sound.ambience[id]

	for _,ambient in ipairs(sound.ambience) do
		ambient:stop()
	end
	love.audio.rewind( )
	
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

