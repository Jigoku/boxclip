
require("camera")
require("sound")
require("physics")
require("collision")
require("world")
require("util")
require("structures")
require("pickups")
require("enemies")
require("player")
require("input")
require("editor")

debug = 1
mode = 1

math.randomseed(os.time())
function love.load()
	
	world:init()
	player:init()
	world:loadMap("maps/test.map")

end

function love.draw()

	-- draw world
	if mode == 1 then
		world:draw()
		-- debug info
		util:drawConsole()
	end
	
end

function love.update(dt)

	-- process keyboard events
	input:check(dt)
	
	-- run world
	if mode == 1 then
		world:run(dt)
	end
	

end

