local deadZone = 500
local commandDir = { x = 1, y = 0 }
local snekSpeed = 1
local snakeHead = { x = 200, y = 200 }
local canvasSize = { x = math.modf(LCD_W / 20) * 20, y = math.modf(LCD_H / 20) * 20 }
local canvasPos = { x = (LCD_W - canvasSize.x) / 2, y = (LCD_H - canvasSize.y) / 2 }
local alignedSnekHead = { x = snakeHead.x + canvasPos.x, y = snakeHead.y + canvasPos.y }
local snekTail = {}
local snekLength = 0
local applePos = {
	x = math.modf(math.random(canvasPos.x, (canvasPos.x + canvasSize.x) - 20) / 20) * 20,
	y = math.modf(math.random(canvasPos.y, (canvasPos.y + canvasSize.y) - 20) / 20) * 20,
}
local gameOver = 0

local function drawSnake(stickPos)
	local CurrentSnappedSnekHead =
		{ x = math.modf(alignedSnekHead.x / 20) * 20, y = math.modf(alignedSnekHead.y / 20) * 20 }
	lcd.clear()
	lcd.drawFilledRectangle(LCD_W / 2 - 10, LCD_H / 2 - 10, 20, 20, LIGHTGREY)
	lcd.drawFilledRectangle(
		(LCD_W - canvasSize.x) / 2,
		(LCD_H - canvasSize.y) / 2,
		canvasSize.x,
		canvasSize.y,
		DARKBROWN
	)
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

	lcd.drawFilledCircle((LCD_W / 2048) * stickPos.x, (LCD_H / 2048) * stickPos.y, 5, ORANGE)

	snakeHead.x, snakeHead.y = snakeHead.x + commandDir.x * snekSpeed, snakeHead.y + commandDir.y * snekSpeed
	alignedSnekHead.x = snakeHead.x + canvasPos.x
	alignedSnekHead.y = snakeHead.y + canvasPos.y
	if
		(alignedSnekHead.x > canvasPos.x and alignedSnekHead.x <= canvasPos.x + canvasSize.x)
		and (alignedSnekHead.y > canvasPos.y and alignedSnekHead.y <= canvasPos.y + canvasSize.y)
	then
		local SnappedSnekHead =
			{ x = math.modf(alignedSnekHead.x / 20) * 20, y = math.modf(alignedSnekHead.y / 20) * 20 }
		if not (SnappedSnekHead.x == CurrentSnappedSnekHead.x and SnappedSnekHead.y == CurrentSnappedSnekHead.y) then
			table.insert(snekTail, 1, CurrentSnappedSnekHead)
			if #snekTail > snekLength then
				table.remove(snekTail)
			end
			if SnappedSnekHead.x == applePos.x and SnappedSnekHead.y == applePos.y then
				snekLength = snekLength + 1
				applePos = {
					x = math.modf(math.random(canvasPos.x, (canvasPos.x + canvasSize.x) - 20) / 20) * 20,
					y = math.modf(math.random(canvasPos.y, (canvasPos.y + canvasSize.y) - 20) / 20) * 20,
				}
			end
		end
		lcd.drawFilledRectangle(applePos.x, applePos.y, 20, 20, RED)
		lcd.drawFilledRectangle(SnappedSnekHead.x, SnappedSnekHead.y, 20, 20, DARKGREEN)
		for i = 1, #snekTail do
			lcd.drawFilledRectangle(snekTail[i].x, snekTail[i].y, 20, 20, DARKGREEN)
		end
	else
		gameOver = 1
	end
end

local function gameUpdate()
	local invertedEle = 2048 - (getValue("ele") + 1024)
	local stickPos = { x = getValue("ail") + 1024, y = invertedEle }
	snekSpeed = (getValue("thr") + 1220) / 196
	local absX = math.abs(stickPos.x - 1024)
	local absY = math.abs(stickPos.y - 1024)
	if absX > deadZone or absY > deadZone then
		if math.max(absX, absY) == absX then
			if commandDir.x == 0 then
				commandDir.y = 0
				if stickPos.x > 1024 then
					commandDir.x = 1
				else
					commandDir.x = -1
				end
			end
		end
		if math.max(absX, absY) == absY then
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
	drawSnake(stickPos)
end
local function run_func(event, touchState)
	if touchState then
		if event == EVT_TOUCH_SLIDE then
			local touchPoint = touchState
			lcd.drawFilledCircle(touchPoint.x, touchPoint.y, 10, GREEN)
		end
	end
	gameUpdate()
	return 0
end

return { run = run_func }
