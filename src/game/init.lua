game = {}
game.w, game.h, game.flags = love.window.getMode()
game.max_fps = game.flags.refreshrate
game.min_dt = 1/game.max_fps
game.next_time = love.timer.getTime()
game.icon = love.image.newImageData("data/images/icon.png")
game.runtime = os.time()
game.ticks = 0
game.utick_time = 0
game.dtick_time = 0

Camera = require("game/STALKER-X/Camera")
camera = Camera() -- initialise a dummy camera
	
require("game/physics")
require("game/collision")
require("game/weather")
require("game/world")
require("game/player")
require("game/popups")
