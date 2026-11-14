-- Rules from default config
hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false
	},
	no_focus = true,
})


-- Workspace routing
hl.window_rule({ match = { class = "^code$" }, workspace = 1 })
hl.window_rule({ match = { class = "^zen-beta$" }, workspace = 3 })
hl.window_rule({ match = { class = "^(discord|slack)$" }, workspace = 4 })
hl.window_rule({ match = { class = "^spotify$" }, workspace = 5 })


-- Zoom conferencing
-- https://github.com/sohamch08/HyprLife/blob/0a20bc95e4cf71b573e74276a10031fec78d3dc1/hypr/modules/zoomrules.lua
hl.window_rule({
	name = "zoom-main-styling",
	match = { class = "^zoom$", xwayland = true },
	no_blur = true,
	no_shadow = true,
})

hl.window_rule({
	name = "zoom-pre-meeting-preview",
	-- Prompt to configure audio/view before opening a meeting. Note there's no complete
	-- way to match this, as window title depends on the meeting title.
	match = {
		class = "^zoom$",
		title = "^.*'s (Zoom Meeting|Personal Meeting Room)$",
		xwayland = true
	},
	-- Fixes it opening cropped (638x154 instead of 638x512)
	no_max_size = true,
})

hl.window_rule({
	name = "zoom-annotation-pencil",
	-- Green annotation pencil, can appear when screensharing or when hovering over
	-- another's screenshare
	match = { class = "^zoom$", title = "^annotate_toolbar$", xwayland = true },
	float = true,
	decorate = false,
})

hl.window_rule({
	name = "zoom-screen-sharing-toolbar",
	-- Main screen sharing toolbar, along with the small attached (green bordered)
	-- share preview when screen sharing is started
	match = { class = "^zoom$", title = "^as_(toolbar|preview)$", xwayland = true },
	-- Makes the toolbar available on all workspaces (as expected), but also seems to
	-- fix input issues where the toolbar can only be focused if you first focus the
	-- main zoom window. With that issue, the main zoom window also wants to take focus
	-- priority; where there's any window overlap, the mouse targets the main window
	-- despite the toolbar being drawn "on top".
	allows_input = true,
	pin = true,
})

hl.window_rule({
	name = "zoom-screen-sharing-mini-window",
	-- Small meeting window when screensharing showing the current speaker
	match = { class = "^zoom$", title = "^zoom_linux_float_video_window$", xwayland = true },
	pin = true,
})
