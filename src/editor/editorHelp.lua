
editorHelp = {}

editorHelp.helpmenuw = 460
editorHelp.helpmenuh = 600
editorHelp.helpmenu = love.graphics.newCanvas(editorHelp.helpmenuw,editorHelp.helpmenuh)
editorHelp.showhelpmenu = false		--show helpmenu


editorHelp.help = {
	{ 
		editor.binds.edittoggle, 
		"toggle editmode" 
	},
	{
		editor.binds.camera .. " + scroll",
		"set camera zoom level"
	},
	{ 
		editor.binds.up..", "..editor.binds.left..", "..editor.binds.down..", "..editor.binds.right, 
		"move"
	},
	{
		"left mouse",
		"place entity"
	},
	{
		"right mouse",
		"remove entity"
	},
	{
		"mouse wheel",
		"scroll entity type"
	},
	{
		editor.binds.rotate .." + scroll",
		"rotate entity"
	},
	{
		editor.binds.moveup..", "..editor.binds.moveleft..", "..editor.binds.movedown..", "..editor.binds.moveright,
		"adjust entity position"
	},
	{
		editor.binds.respawn,
		"reset camera"
	},
	{
		editor.binds.showinfo,
		"toggle entity coordinate information"
	},
	{	
		editor.binds.decmovedist,
		"increase entity move distance / angle"
	},
	{	
		editor.binds.incmovedist,
		"decrease entity move distance / angle"
	},
	{
		editor.binds.texturesel .. " + scroll",
		"change entity texture"
	},
	{
		editor.binds.musicnext  .. ", " .. editor.binds.musicprev,
		"set world music"
	},
	{
		editor.binds.themecycle,
		"set the world theme"
	},
	{
		editor.binds.entcopy,
		"copy entity to clipboard"
	},	
	{
		editor.binds.entpaste,
		"paste entity from clipboard"
	},
	{
		editor.binds.savemap,
		"save the map"
	},
	{
		editor.binds.guidetoggle,
		"toggle grid"
	},
	{
		editor.binds.maptoggle,
		"toggle minimap"
	},
	{
		editor.binds.helptoggle,
		"help menu"
	},
	{ 
		binds.screenshot, 
		"take a screenshot" 
	},
	{ 
		binds.savefolder, 
		"open local data directory" 
	},
	{
		binds.exit,
		"exit to title"
	},
	{
		binds.console,
		"toggle console"
	}
	
}


function editorHelp:formathelp(t)
	local s = 20 -- vertical spacing
	love.graphics.setFont(fonts.menu)
	for i,item in ipairs(t) do
		love.graphics.setColor(0.60,1,1,0.60)
		love.graphics.print(string.upper(item[1]),10,s*i+s); 
		love.graphics.setColor(1,1,1,0.60)
		love.graphics.printf(item[2],160,s*i+s,fonts.menu:getWidth(item[2]),"left")
		--print("| " ..item[1].." | "..item[2] .. "|")
	end
	love.graphics.setFont(fonts.default)
end


function editorHelp:drawhelpmenu()
		
	love.graphics.setCanvas(self.helpmenu)
	love.graphics.clear()
	
	--frame
	love.graphics.setColor(0,0,0,0.78)
	love.graphics.rectangle("fill",0,0, self.helpmenu:getWidth(), self.helpmenu:getHeight(),10)
	--border
	love.graphics.setColor(1,1,1,0.58)
	love.graphics.rectangle("fill",0,0, self.helpmenu:getWidth(), 5)
	--title
	love.graphics.setColor(1,1,1,1)
	love.graphics.print("Editor Help",10,10)
	
	--hrule
	love.graphics.setColor(1,1,1,0.58)
	love.graphics.rectangle("fill",10,25, self.helpmenu:getWidth()-10, 1)


	--menu title
	love.graphics.setColor(1,1,1,0.58)
	love.graphics.printf("["..editor.binds.helptoggle.."] to close",self.helpmenu:getWidth()-110,10,100,"right")
		
	--loop bind/key description and format it
	self:formathelp(self.help)

	love.graphics.setCanvas()
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.helpmenu, love.graphics.getWidth()/2-self.helpmenu:getWidth()/2, love.graphics.getHeight()/2-self.helpmenu:getHeight()/2 )
end
