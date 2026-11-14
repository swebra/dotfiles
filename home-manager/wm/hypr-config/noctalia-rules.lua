-- https://docs.noctalia.dev/noctalia/compositor-settings/hyprland/

-- Start Noctalia on startup
hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
end)

-- Styling
hl.layer_rule({
    name = "noctalia",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
    },
    no_anim = true,
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true,
})

-- Use Noctalia's template-provided colors if they exist
local status, noctalia = pcall(require, "noctalia")
if status then
    noctalia.apply_theme()
end
