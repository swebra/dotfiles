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
        kb_layout    = "us",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",

        follow_mouse = 1,

        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad     = {
            natural_scroll = true,
        },
    },
})

--- Framework trackpad
hl.device({
    name        = "pixa3854:00-093a:1343-touchpad",
    sensitivity = 0,
})

-- Why is the razer unaffected?
