--simple snake game for the TX16s
local function init()
	lcd.clear()
end

local function run_func(event, touchState)
	if touchState then
		if event == EVT_TOUCH_SLIDE then
			local touchPoint = touchState
			lcd.drawFilledCircle(touchPoint.x, touchPoint.y, 10, GREEN)
		end
	end
	return 0
end

return { run = run_func }
