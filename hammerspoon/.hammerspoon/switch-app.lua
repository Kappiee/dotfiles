-- Define the keyboard shortcut to switch to Chrome
local hyperKey = { "shift", "alt", "ctrl", "cmd" }
local shortcuts = {
	["wezTerm"] = "t",
	["Obsidian"] = "o",
	["Visual Studio Code"] = "v", -- this is Visual Studio Code
	["微信"] = "w",
	["Microsoft Edge"] = "e",
	["Google Chrome"] = "g",
	["ChatGPT"] = "c",
	["Rider"] = "r",
	-- ["ChatGPT"] = "c",
}

local function switchTo(appName)
	local appRunning = hs.application.get(appName)

	if appRunning then
		-- If App is running, activate it
		appRunning:activate()
	else
		-- If App is not running, launch it
		hs.application.launchOrFocus(appName)
	end
end

for appName, shortcut in pairs(shortcuts) do
	hs.hotkey
		.new(hyperKey, shortcut, function()
			switchTo(appName)
		end)
		:enable()
end
