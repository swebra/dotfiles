-- https://docs.noctalia.dev/noctalia/compositor-settings/hyprland/

-- Start noctalia on startup
hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
end)

-- Enable blur
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
