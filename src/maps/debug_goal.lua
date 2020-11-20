world.gravity = 2000
world.mapmusic = 10
world.mapambient = 0
world.maptitle = "debug: goal entity"
world.nextmap = "title"
world.deadzone = 2000
world:settheme("sunny")
platforms:add(-800,-1490,460,130,true,false,false,0,0,false,0,1)
checkpoints:add(-620,-1590)
portals:add(-710,-1570,"spawn")
portals:add(-410,-1550,"goal")
