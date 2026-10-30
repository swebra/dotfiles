-- Zoom conferencing
hl.window_rule({
    name = "zoom-popups",
    match = { class = "^(zoom)$", title = "^(menu|Popup|Sharing Toolbar)$" },
    float = true,
    center = false,
})

-- This is likely overkill
hl.window_rule({
    name = "zoom-annotation-pencil",
    match = { class = "^(zoom)$", title = "^(annotate_toolbar)$" },
    float = true,
    decorate = false,
    no_initial_focus = true,
    no_shadow = true,
    no_anim = true,
    -- center = false,
    persistent_size = false,
    border_size = 0,
})

-- annotate_toolbar is the floating pencil for drawing
