world.gravity = 2000
world.mapmusic = 0
world.mapambient = 0
world.maptitle = "Spikes enemy test"
world.nextmap = "title"
world.deadzone = 2000
world:settheme("sunny")
platforms:add(-370,-3700,2770,380,true,false,false,0,0,false,0,1)
platforms:add(580,-4040,260,150,true,false,false,0,0,false,0,2)
platforms:add(1220,-3880,160,560,true,false,false,0,0,false,0,9)
enemies:add(0,-4040,0,0,0,"spike")
enemies:add(110,-4040,0,0,1,"spike")
enemies:add(190,-4040,0,0,2,"spike")
enemies:add(300,-4040,0,0,3,"spike")
enemies:add(600,-3890,0,0,2,"spike_timer")
enemies:add(240,-3750,0,0,0,"spike_timer")
enemies:add(1170,-3820,0,0,3,"spike_timer")
enemies:add(0,-4280,0,0,0,"spike_large")
enemies:add(0,-4200,0,0,2,"spike_large")
enemies:add(180,-4290,0,0,3,"spike_large")
enemies:add(260,-4290,0,0,1,"spike_large")
enemies:add(0,-4720,0,0,0,"spike_timer")
enemies:add(140,-4720,0,0,3,"spike_timer")
enemies:add(140,-4610,0,0,2,"spike_timer")
enemies:add(0,-4610,0,0,1,"spike_timer")
portals:add(-190,-3760,"spawn")
decals:add(-1290,-3670,920,350,100,3)
