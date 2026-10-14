-- Application launchers.
--
-- Port of the "Applications" block of sxhkdrc, minus the sxhkd-specific
-- bindings (reload sxhkd / reload picom, which have no analogue here).
--
-- Rofi goes through the existing ~/.config/rofi/launch.sh helper rather than
-- repeating the -theme argument sxhkdrc spelled out by hand.

local settings = require("settings")
local mod = settings.mod

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(settings.terminal))
hl.bind(mod .. " + e", hl.dsp.exec_cmd(settings.terminal .. " -e yazi"))

-- alt + space / alt + Tab / alt + r
hl.bind(mod .. " + space", hl.dsp.exec_cmd(settings.rofi .. " drun"))
hl.bind(mod .. " + Tab", hl.dsp.exec_cmd(settings.rofi .. " window"))
hl.bind(mod .. " + r", hl.dsp.exec_cmd(settings.rofi .. " run"))

-- alt + shift + s -> fullscreen screenshot.
-- hyprshot has no plain "fullscreen" mode; `-m output` is the full-screen one
-- (bare `hyprshot` prints help and exits 2, a mode is always required). It also
-- copies the image to the clipboard via wl-copy. -o keeps the destination where
-- the old scrot bind put it; drop it to fall back to $XDG_PICTURES_DIR.
hl.bind(
    mod .. " + SHIFT + s",
    hl.dsp.exec_cmd(
        "hyprshot -m output -o " .. settings.screenshots
            .. " -f '%Y-%m-%d_%H-%M-%S_hyprshot.png'"
    )
)