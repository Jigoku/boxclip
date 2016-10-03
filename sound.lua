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
sound.enabled = false
sound.volume = 100

if not sound.enabled then
	love.audio.setVolume( sound.volume/100 )
end

sound.effects = {
	["jump"] = love.audio.newSource("data/sounds/effect/jump.ogg", "static"),
	["gem"] = love.audio.newSource("data/sounds/effect/gem.ogg", "static"),
	["hit"] = love.audio.newSource("data/sounds/effect/hit.ogg", "static"),
	["beep"] = love.audio.newSource("data/sounds/effect/beep.ogg", "static"),
	["die"] = love.audio.newSource("data/sounds/effect/die.ogg", "static"),
	["crate"] = love.audio.newSource("data/sounds/effect/crate.ogg", "static"),
	["lifeup"] = love.audio.newSource("data/sounds/effect/lifeup.ogg", "static"),
	["kill"] = love.audio.newSource("data/sounds/effect/kill.ogg", "static"),
	["checkpoint"] = love.audio.newSource("data/sounds/effect/checkpoint.ogg", "static"),
	["goal"] = love.audio.newSource("data/sounds/effect/goal.ogg", "static"),
	["spring"] = love.audio.newSource("data/sounds/effect/spring.ogg", "static"),
	["blip"] = love.audio.newSource("data/sounds/effect/blip.ogg", "static"),
	["magnet"] = love.audio.newSource("data/sounds/effect/magnet.ogg", "static"),
	["shield"] = love.audio.newSource("data/sounds/effect/shield.ogg", "static"),
	["creek"] = love.audio.newSource("data/sounds/effect/creak.ogg", "static"),
	["slice"] = love.audio.newSource("data/sounds/effect/slice.ogg", "static"),
	["start"] = love.audio.newSource("data/sounds/music/start.ogg", "static"),
}


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
	[2] = love.audio.newSource("data/sounds/ambient/stream.ogg"),
	[3] = love.audio.newSource("data/sounds/ambient/drip.ogg"),
	[4] = love.audio.newSource("data/sounds/ambient/storm.ogg")
}


function sound:playbgm(id)

	self.bgm = self.music[id]
	self:stoplooping(self.music)
	
	love.audio.rewind( )
	
	if id ~= 0 then
		self.bgm:setLooping(true)
		self.bgm:setVolume(0.5)
		self.bgm:play()
	end
end



function sound:playambient(id)

	self.ambient = self.ambience[id]
	self:stoplooping(self.ambience)
		
	love.audio.rewind( )
	
	if id ~= 0 then
		self.ambient:setLooping(true)
		self.ambient:setVolume(1)
		self.ambient:play()
	end
end


function sound:play(effect)
	
	--improve this (temporary fix)
	--allows sound to be played in quick succession
	if effect:isPlaying() then
		effect:stop()
	end
	effect:play()
end

function sound:stoplooping(type)
	for _,t in ipairs(type) do
		t:stop()
	end
end

