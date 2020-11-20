world.gravity = 2000
world.mapmusic = 14
world.mapambient = 0
world.maptitle = "unnamed map"
world.nextmap = "title"
world.deadzone = 2000
world:settheme("mist")
platforms:add(-350,-560,1770,280,true,false,false,0,0,false,0,1)
platforms:add(-670,-1310,350,1030,true,false,false,0,0,false,0,1)
platforms:add(1390,-1310,350,1030,true,false,false,0,0,false,0,1)
platforms:add(10,-690,120,30,false,false,false,0,0,false,0,1)
platforms:add(10,-810,120,30,false,false,false,0,0,false,0,1)
platforms:add(10,-920,120,30,false,false,false,0,0,false,0,1)
enemies:add(220,-980,-100,100,0,"crusher")
enemies:add(580,-910,-100,100,0,"crusher")
enemies:add(880,-910,-100,100,0,"crusher")
springs:add(1090,-590,0,"spring_s")
portals:add(-80,-640,"spawn")
