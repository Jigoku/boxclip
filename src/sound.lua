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

sound = {}

-- add menu / keybind to toggle this
sound.enabled = true
sound.volume = 80

function sound:init()
	if sound.enabled then
		love.audio.setVolume( sound.volume/100 )
	else
		love.audio.setVolume( 0 )
	end
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
	["bumper"] = love.audio.newSource("data/sounds/effect/bumper.ogg", "static"),
	["brick"] = love.audio.newSource("data/sounds/effect/brick.ogg", "static"),
	["start"] = love.audio.newSource("data/sounds/music/start.ogg", "static"),
	["bounce"] = love.audio.newSource("data/sounds/effect/bounce.ogg", "static"),
	["slide"] = love.audio.newSource("data/sounds/effect/slide.ogg", "static"),
	["crush"] = love.audio.newSource("data/sounds/effect/crush.ogg", "static"),
}

sound.music = {
	[0] = nil,
	[1] = love.audio.newSource("data/sounds/music/jungle.ogg", "stream"),
	[2] = love.audio.newSource("data/sounds/music/underwater.ogg", "stream"),
	[3] = love.audio.newSource("data/sounds/music/walking.ogg", "stream"),
	[4] = love.audio.newSource("data/sounds/music/intense.ogg", "stream"),
	[5] = love.audio.newSource("data/sounds/music/busy.ogg", "stream"),
	[6] = love.audio.newSource("data/sounds/music/intro.ogg", "stream"),
	[7] = love.audio.newSource("data/sounds/music/riverside.ogg", "stream"),
	[8] = love.audio.newSource("data/sounds/music/exploration.ogg", "stream"),
	[9] = love.audio.newSource("data/sounds/music/rainbow.ogg", "stream"),
	[10] = love.audio.newSource("data/sounds/music/level_complete.ogg", "stream"),
	[11] = love.audio.newSource("data/sounds/music/fight.ogg", "stream"),
	[12] = love.audio.newSource("data/sounds/music/paradise.ogg", "stream"),
	[13] = love.audio.newSource("data/sounds/music/happy.ogg", "stream"),
	[14] = love.audio.newSource("data/sounds/music/grasslands.ogg", "stream"),
	[15] = love.audio.newSource("data/sounds/music/raspberry_jam.ogg", "stream"),
	[16] = love.audio.newSource("data/sounds/music/happysynth.ogg", "stream"),
}

sound.ambience = {
	[0] = nil,
	[1] = love.audio.newSource("data/sounds/ambient/swamp.ogg", "stream"),
	[2] = love.audio.newSource("data/sounds/ambient/stream.ogg", "stream"),
	[3] = love.audio.newSource("data/sounds/ambient/drip.ogg", "stream"),
	[4] = love.audio.newSource("data/sounds/ambient/storm.ogg", "stream")
}


function sound:toggle()
	sound.enabled = not sound.enabled
	if sound.enabled then
		love.audio.setVolume( sound.volume/100 )
	else
		love.audio.setVolume( 0 )
	end
end


function sound:playbgm(id)
	self.bgm = self.music[id]
	self:stoplooping(self.music)

	if id ~= 0 then
		self.bgm:setLooping(true)
		self.bgm:setVolume(0.5)
		self.bgm:play()
	end
end


function sound:playambient(id)
	self.ambient = self.ambience[id]
	self:stoplooping(self.ambience)

	if id ~= 0 then
		self.ambient:setLooping(true)
		self.ambient:setVolume(1)
		self.ambient:play()
	end
end


function sound:play(fx)
	-- sound restarts each time this is called
	fx:stop()
	fx:play()
end


function sound:playloop(fx)
	-- sound only restarts if current sample has finished
	if not fx:isPlaying() then
		fx:play()
	end
end


function sound:stoplooping(type)
	for _,t in ipairs(type) do
		t:stop()
	end
end

