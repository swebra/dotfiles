-- Helper vars/functions
local mod = "SUPER + "
local modShift = mod .. "SHIFT + "
local function noctalia(action)
    return hl.dsp.exec_cmd("noctalia msg " .. action)
end

-- Mouse window move/resize
hl.bind(mod .. "mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspace movement
local alpha_workspace_keys = { "tab", "q", "w", "e", "r", "t", "y", "u" }
for i, alpha_key in pairs(alpha_workspace_keys) do
    local num_key = i
    -- Focus workspace
    hl.bind(mod .. num_key, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. alpha_key, hl.dsp.focus({ workspace = i }))
    -- Move to workspace
    hl.bind(modShift .. num_key, hl.dsp.window.move({ workspace = i }))
    hl.bind(modShift .. alpha_key, hl.dsp.window.move({ workspace = i }))
end

-- Window movement
local window_keys = { h = "left", j = "down", k = "up", l = "right" }
for key, direction in pairs(window_keys) do
    hl.bind(mod .. key, hl.dsp.focus({ direction = direction }))
    hl.bind(modShift .. key, hl.dsp.window.move({ direction = direction }))
end
hl.bind(mod .. "F", hl.dsp.window.float())

-- Programs
hl.bind(mod .. "SUPER_L", noctalia("panel-toggle launcher"), { release = true })
hl.bind(mod .. "x", hl.dsp.window.close())
hl.bind(mod .. "return", hl.dsp.exec_cmd("alacritty"))

-- Other panels
hl.bind("ALT + Tab", noctalia("window-switcher"))
hl.bind("Print", noctalia("screenshot-region"))
hl.bind(mod .. "V", noctalia("panel-toggle clipboard"))

-- Function/power keys
locked = { locked = true }
locked_repeating = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume", noctalia("volume-up"), locked_repeating)
hl.bind("XF86AudioLowerVolume", noctalia("volume-down"), locked_repeating)
hl.bind("XF86AudioMute", noctalia("volume-mute"), { locked = true })

hl.bind("XF86AudioPrev", noctalia("media previous"))
hl.bind("XF86AudioPlay", noctalia("media toggle"))
hl.bind("XF86AudioNext", noctalia("media next"))

hl.bind("XF86MonBrightnessUp", noctalia("brightness-up"), locked_repeating)
hl.bind("XF86MonBrightnessDown", noctalia("brightness-down"), locked_repeating)

hl.bind("XF86PowerOff", noctalia("panel-toggle session")) -- power button
hl.bind(mod .. "escape", noctalia("session lock"))
