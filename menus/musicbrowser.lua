musicbrowser = {}

musicbrowser.w = 400
musicbrowser.h = 150
musicbrowser.x = love.graphics.getWidth()/2
musicbrowser.y = love.graphics.getHeight()/2

musicbrowser.canvas = love.graphics.newCanvas(musicbrowser.x,musicbrowser.y)

musicbrowser.buttons = {
	["prev"] = love.graphics.newImage("data/images/buttons/prev.png"),
	["next"] = love.graphics.newImage("data/images/buttons/next.png"),
	["prev_x"] = 40,
	["next_x"] = 80,
}

function musicbrowser:draw()
	love.graphics.setColor(255,255,255,155)
	love.graphics.setCanvas(self.canvas)
	self.canvas:clear()

	love.graphics.setColor(0,0,0,150)
	love.graphics.rectangle("fill", 0,0,self.w,self.h)
	
	love.graphics.setColor(255,255,255,255)
	
	love.graphics.setFont(fonts.menu)
	love.graphics.print("mapmusic: " .. (world.mapmusic or "0"),10,10)
	love.graphics.setFont(fonts.default)
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.buttons["prev"],self.buttons["prev_x"],40)
	love.graphics.draw(self.buttons["next"],self.buttons["next_x"] ,40)
	
	love.graphics.setCanvas()
	love.graphics.draw(self.canvas, self.x-self.w/2,self.y-self.h/2)
end
