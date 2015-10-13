sound = {}

local fx = "sounds/effect/"
local mt = "sounds/music/"

-- place sound filepaths here
sound.jump = love.audio.newSource(fx .. "jump.ogg", "static")
sound.gem = love.audio.newSource(fx .. "gem.ogg", "static")
sound.hit = love.audio.newSource(fx .. "hit.ogg", "static")
sound.beep = love.audio.newSource(fx .. "beep.ogg", "static")
sound.die = love.audio.newSource(fx .. "die.ogg", "static")
sound.crate = love.audio.newSource(fx .. "crate.ogg", "static")
sound.lifeup = love.audio.newSource(fx .. "lifeup.ogg", "static")
sound.kill = love.audio.newSource(fx .. "kill.ogg", "static")
sound.checkpoint = love.audio.newSource(fx .. "checkpoint.ogg", "static")

-------------
-- map music specific test
sound.music01 = love.audio.newSource(mt .. "jungle.ogg")
sound.music02 = love.audio.newSource(mt .. "underwater.ogg")
sound.music03 = love.audio.newSource(mt .. "walking.ogg")
sound.music04 = love.audio.newSource(mt .. "intense.ogg")
sound.music05 = love.audio.newSource(mt .. "busy.ogg")




function sound:play(effect)
	--improve this (temporary fix)
	if effect:isPlaying() then
		effect:stop()
	end
	effect:play()
end

function sound:decide(source)
	if source.name == "platform" then
		self:play(sound.hit)
	elseif source.name == "crate" then
		self:play(sound.crate)
	elseif source.name == "death" then
		self:play(sound.die)
	elseif source.name == "checkpoint" then
		self:play(sound.checkpoint)
	end
end
