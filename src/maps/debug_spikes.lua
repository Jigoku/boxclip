world.gravity = 2000
world.mapmusic = 0
world.mapambient = 0
world.maptitle = "Spikes enemy test"
world.nextmap = "title"
world.deadzone = 2000
world:settheme("autumn")
platforms:add(-370,-3700,2770,380,true,false,false,0,0,false,0,20)
platforms:add(1220,-3880,160,560,true,false,false,0,0,false,0,9)
platforms:add(50,-4000,320,110,true,false,false,0,0,false,0,14)
platforms:add(530,-4000,90,20,false,false,true,100,200,false,0,5)
enemies:add(210,-3750,0,0,0,"spike_timer")
enemies:add(130,-3750,0,0,0,"spike_timer")
enemies:add(70,-4080,100,236,1,"walker")
enemies:add(840,-4140,0,0,0,"spikeball")
enemies:add(760,-3830,100,100,1,"floater")
portals:add(-190,-3780,"spawn")
decals:add(-1290,-3670,920,350,100,3)
