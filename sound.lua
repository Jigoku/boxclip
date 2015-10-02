sound = {}

local soundpath = "sounds/"

-- place sound filepaths here
sound.jump = love.audio.newSource(soundpath .. "jump.wav")
sound.coin = love.audio.newSource(soundpath .. "coin.wav")
sound.hit = love.audio.newSource(soundpath .. "hit.wav")
sound.beep = love.audio.newSource(soundpath .. "beep.wav")
sound.die = love.audio.newSource(soundpath .. "die.wav")
sound.crate = love.audio.newSource(soundpath .. "crate.wav")
