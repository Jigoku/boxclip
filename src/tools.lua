--global functions
tools = {}

function math.round(num, idp)
	-- round integer to decimal places
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end


function ripairs(t)
	--same as ipairs, but itterate from last to first
	local function ripairs_it(t,i)
		i=i-1
		local v=t[i]
		if v==nil then return v end
		return i,v
	end
	return ripairs_it, t, #t+1
end


function split(s, delimiter)
	--split string into a table
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end


function tableconcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end


function table.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value)
        end
        setmetatable(copy, table.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


--[[
function get_cpuusage()
	-- return cpu usage of process as percentage
	if love.system.getOS() == "Linux" then
		local handle = io.popen("ps -p $(pidof love) -o %cpu | tail -n1 | tr -d '\n'")
		local result = handle:read("*a")
		handle:close()	
		return result
	end
end
--]]

-- this function redefines love.graphics.newImage( ), so all images are
-- not put through linear filter, which makes things more crisp on the
-- pixel level (less blur)... should this be used?
-- possibly add as an option in graphics settings when implemented

--[[
local _newImage = love.graphics.newImage
function love.graphics.newImage(...)
	local img = _newImage(...)
	img:setFilter('nearest', 'nearest')
	return img
end
--]]

