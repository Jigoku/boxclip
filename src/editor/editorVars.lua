
--editor settings
editor.entdir = 0				--rotation placement 0,1,2,3 = up,right,down,left
editor.entsel = 1				--current entity id for placement
editor.themesel = 1				--world theme/pallete
editor.texturesel = 1			--texture slot to use for platforms
editor.showinfo = true			--display coordinates of entities
editor.showmmap = true			--show minimap
editor.showgrid = true			--show guidelines/grid
editor.showentmenu = true		--show entmenu
editor.drawsel = false			--draw selection area
editor.floatspeed = 1000		--editing floatspeed
editor.maxcamerascale = 6		--maximum zoom
editor.mincamerascale = 0.1		--minimum zoom
editor.placing = false			--check if an entity is being placed
editor.entsizemin = 20			--minimum grid size per draggable entity

-- Editor selection save
editor.isSelected = false 
editor.entitySelected = {}

--misc textures
editor.errortex = love.graphics.newImage("data/images/editor/error.png")
editor.bullettex = love.graphics.newImage("data/images/editor/bullet.png")

-- minimap
editor.mmapw = love.graphics.getWidth()/3
editor.mmaph = love.graphics.getHeight()/3
editor.mmapscale = camera.scale/2
editor.mmapcanvas = love.graphics.newCanvas( editor.mmapw, editor.mmaph )

-- entity selection menu
editor.entmenuw = 150    
editor.entmenuh = 300	
editor.entmenu = love.graphics.newCanvas(editor.entmenuw,editor.entmenuh)
	

-- texture preview
editor.texmenutexsize = 75
editor.texmenupadding = 10
editor.texmenuoffset = 2
editor.texmenutimer = 0
editor.texmenuduration = 2
editor.texmenuopacity = 0
editor.texmenufadespeed = 5
editor.texmenuw = editor.texmenutexsize+(editor.texmenupadding*2)
editor.texmenuh = (editor.texmenutexsize*(editor.texmenuoffset*2+1))+(editor.texmenupadding*(editor.texmenuoffset*2))+(editor.texmenupadding*2)
editor.texmenu = love.graphics.newCanvas(editor.texmenuw,editor.texmenuh)
editor.texlist = {}

-- music track preview
editor.musicmenu = love.graphics.newCanvas(150,50)
editor.musicmenupadding = 10
editor.musicmenuopacity = 0
editor.musicmenufadespeed = 5
editor.musicmenutimer = 0
editor.musicmenuduration = 4

--placable entities listed in entmenu
--these are defined at top of entities/*.lua
editor.entities = {}

-- entity priority for selection / hover mouse
-- TODO should be moved to entities/init.lua
editor.entorder = {
	"tip",
	"material",
	"trap",
	"enemy",
	"pickup",
	"coin",
	"portal",
	"crate",
	"checkpoint",
	"bumper",
	"spring",
	"platform",
	"prop",
	"decal"
 }


--entities which are draggable (size placement)
-- TODO should be moved to entities/init.lua
editor.draggable = {
	"platform", "platform_b", "platform_x", "platform_y", 
	"decal",
	"death" 
}