-- Hyprland configuration.
--
-- Split into modules so this file stays a thin entry point. Each require is a
-- separate Lua scope in Hyprland, so a runtime error in one module does not
-- stop the others -- but a require of a *missing* file throws into this file
-- and kills the whole config, so keep the list below in sync with the tree.
--
--   settings.lua          mod key, terminal, rofi helper
--   theme.lua             palette parsed from ~/.Xresources
--   input.lua             libinput port of xorg.conf.d/*.conf
--   rules.lua             window rules
--   animations.lua        curves and per-leaf animation timings
--   wallpaper.lua         kills the default background, starts hyprpaper
--   binds/tiling.lua      focus / swap / resize / cycle
--   binds/windows.lua     window state, WM control
--   binds/workspaces.lua  workspaces
--   binds/apps.lua        rofi + terminal launchers

local theme = require("theme")

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Monitors/
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Variables/
hl.env("XCURSOR_THEME", theme.cursor_theme)
hl.env("XCURSOR_SIZE", tostring(theme.cursor_size))
hl.env("HYPRCURSOR_SIZE", tostring(theme.cursor_size))
hl.env("XCURSOR_FONT", theme.font)

-----------------------
----- PERMISSIONS ----
-----------------------

-- Requires a Hyprland restart; not applied on-the-fly.
-- hl.config({ ecosystem = { enforce_permissions = true } })

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Variables/
hl.config({
    general = {
        -- bspwmrc used window_gap 10 plus 10px padding on all edges.
        gaps_in = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border = theme.active_border,
            inactive_border = theme.inactive_border,
        },

        resize_on_border = false,
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        rounding_power = 2,

        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = theme.shadow,
        },

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
})

-- misc.disable_hyprland_logo is owned by wallpaper.lua.

-- Dwindle: new windows fill the master stack.
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- Master layout, reachable via the monocle-toggle bind's sibling layouts.
hl.config({
    master = {
        new_status = "master",
    },
})

-- Scrolling layout is not bound; these are its defaults, kept for reference.
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
---- MODULES ----
----------------

require("animations")
require("wallpaper")
require("input")
require("rules")
require("binds.tiling")
require("binds.windows")
require("binds.workspaces")
require("binds.apps")