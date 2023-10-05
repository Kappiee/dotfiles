local hyperKey = { "shift", "alt", "ctrl", "cmd" }

-- Toggle a window between its normal size, and being maximized
local function toggle_window_full_screen()
	local win = hs.window.focusedWindow()
	if win ~= nil then
		win:setFullScreen(not win:isFullScreen())
	end
end

-- 切换到左侧应用程序的函数
local function switchToLeftApp()
    hs.eventtap.keyStroke({ "cmd", "tab" }, "tab", 0)
end

-- 切换到右侧应用程序的函数
local function switchToRightApp()
    hs.eventtap.keyStroke({ "cmd", "tab" ,"shift"}, "tab", 0)
end
-- 定义程序切换的触摸板手势
local function swipeLeftToRight()
	-- 模拟触摸板三指从左到右滑动手势
	hs.eventtap.event.newGesture("beginSwipeRight")
	  :setProperty(hs.eventtap.event.properties["gestureFingers"], 3)
	  :post()
	hs.eventtap.event.newGesture("endSwipeRight")
	  :setProperty(hs.eventtap.event.properties["gestureFingers"], 3)
	  :post()
end
local function swipeRightToLeft()
	-- 模拟触摸板三指从左到右滑动手势
	hs.eventtap.event.newGesture("beginSwipeLeft")
	  :setProperty(hs.eventtap.event.properties["gestureFingers"], 3)
	  :post()
	hs.eventtap.event.newGesture("endSwipeLeft")
	  :setProperty(hs.eventtap.event.properties["gestureFingers"], 3)
	  :post()
end


--
hs.hotkey.bind(hyperKey, "a", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 0.5, 1 })
end)
hs.hotkey.bind(hyperKey, "d", function()
	hs.window.focusedWindow():moveToUnit({ 0.5, 0, 0.5, 1 })
end)
hs.hotkey.bind(hyperKey, "w", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 0.5 })
end)
hs.hotkey.bind(hyperKey, "s", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0.5, 1, 0.5 })
end)

-- full screen
hs.hotkey.bind(hyperKey, "z", function()
	hs.window.focusedWindow():moveToUnit({ 0, 0, 1, 1 })
end)

-- move to another screen
hs.hotkey.bind(hyperKey, "r", function()
	-- get the focused window
	local win = hs.window.focusedWindow()
	-- get the screen where the focused window is displayed, a.k.a. current screen
	local screen = win:screen()
	-- compute the unitRect of the focused window relative to the current screen
	-- and move the window to the next screen setting the same unitRect
	win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end)


hs.hotkey.bind(hyperKey, "e", toggle_window_full_screen)

-- 触摸板模拟三指从左滑到右的手势
local hsEventTap = require("hs.eventtap")

local function simulateThreeFingerSwipe(direction)
    local event = hsEventTap.event.newGesture("swipe", {
        touches = {
            { x = 0, y = 0 },
            { x = direction, y = 0 },
            { x = 2 * direction, y = 0 }
        },
        duration = 0.1
    })
    event:post()
end


-- -- 切换到下一个窗口
-- hs.hotkey.bind(hyperKey, "l", function()
--     hs.window.switcher.nextWindow()
-- end)

-- -- 切换到上一个窗口
-- hs.hotkey.bind(hyperKey, "h", function()
--     hs.window.switcher.previousWindow()
-- end)
-- -- quarter of screen
-- --[[
--     u i
--     j k
-- --]]
-- hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'u', function() hs.window.focusedWindow():moveToUnit({0, 0, 0.5, 0.5}) end)
-- hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'k', function() hs.window.focusedWindow():moveToUnit({0.5, 0.5, 0.5, 0.5}) end)
-- hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'i', function() hs.window.focusedWindow():moveToUnit({0.5, 0, 0.5, 0.5}) end)
-- hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'j', function() hs.window.focusedWindow():moveToUnit({0, 0.5, 0.5, 0.5}) end)
