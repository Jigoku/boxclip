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


function sound:playbgm(id)
	if id == "1" then  sound.bgm = love.audio.newSource(mt .. "jungle.ogg") end
	if id == "2" then  sound.bgm = love.audio.newSource(mt .. "underwater.ogg") end
	if id == "3" then  sound.bgm = love.audio.newSource(mt .. "walking.ogg") end
	if id == "4" then  sound.bgm = love.audio.newSource(mt .. "intense.ogg") end
	if id == "5" then  sound.bgm = love.audio.newSource(mt .. "busy.ogg") end

	sound.bgm:setLooping(true)
	sound.bgm:setVolume(0.5)
	sound.bgm:play()
end

function sound:play(effect)
	--improve this (temporary fix)
	if effect:isPlaying() then
		effect:stop()
	end
	effect:play()
end

