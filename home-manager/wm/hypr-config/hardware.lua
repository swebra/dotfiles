----------------
--- Monitors ---
----------------
-- (Explicit) Fallback
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- Desktop
hl.monitor({
    output   = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M34WQ 0x0000013B",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
    vrr      = 1
})

-- Laptop
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = "1.5",
    vrr      = 1
})

---------------------
--- Input Devices ---
---------------------
-- General
hl.config({
    input = {
        accel_profile = "flat",
        sensitivity = -0.5, -- With 800 DPI, options are [-1, 1]
        touchpad = {
            natural_scroll = true,
        },
        kb_layout = "us",
    }
})

--- Framework trackpad
hl.device({
    name = "pixa3854:00-093a:1343-touchpad",
    sensitivity = 0,
})
