world.gravity = 2000
world.mapmusic = 0
world.mapambient = 0
world.maptitle = "unnamed map"
world.nextmap = "title"
world.deadzone = 2000
world:settheme("dust")
platforms:add(-1890,-2840,500,80,false,false,false,0,0,false,0,1)
platforms:add(-1970,-2570,670,130,true,false,false,0,0,false,0,1)
platforms:add(-900,-2160,170,150,true,false,false,0,0,false,0,6)
platforms:add(-360,-2160,170,150,true,false,false,0,0,false,0,6)
platforms:add(-900,-2160,170,40,true,false,false,0,0,false,0,5)
platforms:add(-360,-2160,170,40,true,false,false,0,0,false,0,5)
enemies:add(-1220,-2640,100,128,1,"floater")
enemies:add(-930,-2710,100,128,1,"floater")
enemies:add(-660,-2800,-100,128,0,"floater")
props:add(-1860,-2760,0,false,"arch3_pillar")
props:add(-1480,-2760,0,false,"arch3_pillar")
props:add(-1950,-2440,0,false,"arch3_pillar")
props:add(-1380,-2440,0,false,"arch3_pillar")
props:add(-1380,-2250,0,false,"arch3_pillar")
props:add(-1950,-2250,0,false,"arch3_pillar")
props:add(-1660,-2440,0,false,"arch3_pillar")
props:add(-1660,-2250,0,false,"arch3_pillar")
portals:add(-1700,-2650,"spawn")
decals:add(-3090,-2060,3110,850,100,4)
