--[[
 * Copyright (C) 2015 - 2018 Ricky K. Thomson
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

joystick = {}

--set default gamepad/joystick as first device if available
--TODO, implement selecting active joystick device in game settings/menu
joystick.active = love.joystick.getJoysticks()[1] or false

function joystick:isDown(button)
	--make sure a joypad is connected before testing button presses
	if not joystick.active then return end
	return joystick.active:isGamepadDown(button)
end

function joystick:vibrate(left,right,dur)
	if not joystick.active then return end
	print("joystick:vibrate(".. left,right,dur ..")")
	return joystick.active:setVibration(left,right,dur)
end

function joystick:getName()
	if not joystick.active then return "disconnected" end
	return joystick.active:getName()
end
