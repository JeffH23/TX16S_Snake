--simple snake game for the TX16s

local snakeHead = { x = 0, y = 0 }
local snakeDir = { x = 0, y = 0 }
local snakeLength = 0
local applePos = { x = math.random(10, LCD_W - 10), y = math.random(10, LCD_H - 10) }
local commandDir = { x = 1, y = 0 }
local clearFlag = 1
local deadZone = 50
--local input_table = { { "Ail", Ail }, { "Ele", Ele }, { "Thr", Thr } }

local function init_func()
	print("init executed!")
end

local function drawDirection()
	lcd.clear()
	lcd.drawFilledRectangle(LCD_W / 2 - 10, LCD_H / 2 - 10, 20, 20, LIGHTGREY)
	if commandDir.x ~= 0 then
		if commandDir.x == 1 then
			lcd.drawFilledRectangle(LCD_W / 2 + 10, LCD_H / 2 - 10, 20, 20, DARKBLUE)
		else
			lcd.drawFilledRectangle(LCD_W / 2 - 30, LCD_H / 2 - 10, 20, 20, DARKBLUE)
		end
	end
	if commandDir.y ~= 0 then
		if commandDir.y == 1 then
			lcd.drawFilledRectangle(LCD_W / 2 - 10, LCD_H / 2 + 10, 20, 20, DARKBLUE)
		else
			lcd.drawFilledRectangle(LCD_W / 2 - 10, LCD_H / 2 - 30, 20, 20, DARKBLUE)
		end
	end
end

local function gameUpdate()
	local invertedEle = 2048 - (getValue("ele") + 1024)
	local stickPos = { x = getValue("ail") + 1024, y = invertedEle }
	lcd.clear(COLOR_THEME_PRIMARY1)
	if math.abs(stickPos.x - 1024) > deadZone or math.abs(stickPos.y - 1024) > deadZone then
		if math.max(math.abs(stickPos.x), math.abs(stickPos.y)) == math.abs(stickPos.x) then
			if commandDir.x == 0 then
				commandDir.y = 0
				if stickPos.x > 1024 then
					commandDir.x = 1
				else
					commandDir.x = -1
				end
			end
		else
			if commandDir.y == 0 then
				commandDir.x = 0
				if stickPos.y > 1024 then
					commandDir.y = 1
				else
					commandDir.y = -1
				end
			end
		end
	end
	drawDirection()
	print("X", commandDir.x, ":Y", commandDir.y)
end

local function run_func(event, touchState)
	if clearFlag then
		clearFlag = nil
		lcd.clear(BLUE)
	end
	local applePos =
		{ x = math.modf(math.random(0, LCD_W - 10) / 10) * 10, y = math.modf(math.random(0, LCD_H - 10) / 10) * 10 }
	--	lcd.drawFilledRectangle(applePos.x, applePos.y, 10, 10, RED)
	gameUpdate()
	if touchState then
		if event == EVT_TOUCH_SLIDE then
			local touchPoint = touchState
			lcd.drawFilledCircle(touchPoint.x, touchPoint.y, 10, GREEN)
		end
	end
	return 0
end

return { init = init_func, run = run_func }
