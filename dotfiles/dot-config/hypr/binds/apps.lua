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

-- alt + shift + s -> scrot, matching sxhkdrc's screenshot script.
hl.bind(
    mod .. " + SHIFT + s",
    hl.dsp.exec_cmd(
        "scrot -Z 2 -d 1 -f '%Y-%m-%d_%H-%M-%S_scrot.png'"
            .. " -e 'mv $f ~/Pictures/screenshots/'"
    )
)