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

-- Programs
hl.bind(mod .. "x", hl.dsp.window.close())
hl.bind(mod .. "return", hl.dsp.exec_cmd("alacritty"))


-- Noctalia function keys
function_options = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume", noctalia("volume-up"), function_options)
hl.bind("XF86AudioLowerVolume", noctalia("volume-down"), function_options)
hl.bind("XF86AudioMute", noctalia("volume-mute"), { locked = true })

hl.bind("XF86MonBrightnessUp", noctalia("brightness-up"), function_options)
hl.bind("XF86MonBrightnessDown", noctalia("brightness-down"), function_options)


-- TODO: Not sure if this is right?
hl.bind("SUPER + SUPER_L", noctalia("panel-toggle launcher"), { release = true })
-- hl.bind("SUPER + SUPER_L", noctalia("panel-toggle control-center"), { release = true })
hl.bind("ALT + Tab", noctalia("window-switcher"))


-- IDK what this does
hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1080, 920 },
})
