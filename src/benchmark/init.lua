--[[
 * Copyright (C) 2018 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 --]]

benchmark = {}

benchmark.ticks = {}
benchmark.total = 300 --width of widget / number of ticks in history
benchmark.multiplier = 10
benchmark.canvas = love.graphics.newCanvas(benchmark.total,80)

function benchmark.start()
	benchmark.tick_start = love.timer.getTime()*1000
end

function benchmark.finish()
	-- don't exceed benchmark.total 
	if #benchmark.ticks > benchmark.total then
		table.remove(benchmark.ticks,1)
	end

	-- calculate average latency
	local average = 0
		for i=1,#benchmark.ticks do
		average = average + benchmark.ticks[i]
	end

	benchmark.average = average/#benchmark.ticks

	-- add the most recent tick
	table.insert(benchmark.ticks,
		love.timer.getTime( )*1000 - benchmark.tick_start
	)

end

function benchmark.draw()
	love.graphics.setCanvas(benchmark.canvas)
	love.graphics.setColor(0,0,0,255)
	local font = love.graphics.getFont()
	love.graphics.setFont(love.graphics.newFont(10))

	-- fill background
	love.graphics.rectangle(
		"fill",
		0,
		0,
		benchmark.canvas:getWidth(),
		benchmark.canvas:getHeight()
	)
	
	-- draw the ticks as lines
	love.graphics.setColor(0,255,0,255)
	for i=1,#benchmark.ticks do
		love.graphics.line(
			0+i,
			benchmark.canvas:getHeight(), 
			0+i,
			benchmark.canvas:getHeight()-benchmark.ticks[i]*benchmark.multiplier
		)
	end		

	-- print average ms
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(love.graphics.newFont(10))
	love.graphics.print("avg: "..string.format("%.2f",math.round(benchmark.average,2)).."ms\tcur: "..string.format("%.2f",math.round(benchmark.ticks[#benchmark.ticks],2)).."ms",5,5)
	love.graphics.print("fps: " .. love.timer.getFPS(),5,15)
	love.graphics.print("mem: " .. gcinfo() .."kB",5,25)
	love.graphics.print(string.format("vram: %.2fMB", love.graphics.getStats().texturememory / 1024 / 1024),5,35)
	--]]

	love.graphics.setFont(font)

	love.graphics.setCanvas()

	love.graphics.setColor(255,255,255,255)
	-- draw benchmark widget
	love.graphics.draw(	
		benchmark.canvas, 
		love.graphics.getWidth()-benchmark.canvas:getWidth()-10,
		10
	)
end

return benchmark
