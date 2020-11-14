world.gravity = 2000
world.mapmusic = 0
world.mapambient = 0
world.maptitle = "Spikes enemy test"
world.nextmap = "title"
world.deadzone = 2000
world:settheme("sunny")
platforms:add(-370,-3700,2770,380,true,false,false,0,0,false,0,20)
platforms:add(1220,-3880,160,560,true,false,false,0,0,false,0,9)
platforms:add(50,-4000,320,110,true,false,false,0,0,false,0,14)
platforms:add(530,-4000,90,20,false,false,true,-100,200,false,0,5)
platforms:add(-350,-4000,360,130,true,false,false,0,0,false,0,3)
platforms:add(-870,-3660,410,180,true,false,false,0,0,false,0,2)
enemies:add(210,-3750,0,0,0,"spike_timer")
enemies:add(130,-3750,0,0,0,"spike_timer")
enemies:add(70,-4080,100,236,1,"walker")
enemies:add(840,-4140,0,0,0,"spikeball")
enemies:add(-230,-4060,0,0,0,"spike_timer")
props:add(-960,-4160,0,false,"tree2")
props:add(-360,-3750,0,false,"rock")
props:add(200,-3930,0,false,"mesh")
props:add(-300,-3720,0,false,"grass")
props:add(-70,-3800,0,false,"log_fence")
props:add(160,-3790,0,false,"log_fence")
props:add(350,-3760,0,false,"log_fence")
props:add(-370,-3760,0,false,"post")
props:add(-260,-3740,0,false,"rock")
portals:add(-190,-3780,"spawn")
decals:add(-1290,-3630,920,350,100,2)
