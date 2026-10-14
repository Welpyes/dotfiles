-- Tiling: focus, swap, resize, window cycling.
--
-- Port of the "Focus Swap" and "Move/Resize" blocks of sxhkdrc, rebound from
-- `alt`/`ctrl` onto the single ALT modifier.
--
-- Deliberately absent: sxhkdrc's *Preselect* block (`bspc node -p` / `-o`).
-- Hyprland's dwindle layout keeps no preselect state, so those bindings would
-- have nothing to drive.

local settings = require("settings")
local mod = settings.mod

local FOCUS = {
    { key = "h", direction = "left" },  -- bspc node -f west
    { key = "j", direction = "down" },  -- bspc node -f south
    { key = "k", direction = "up" },    -- bspc node -f north
    { key = "l", direction = "right" }, -- bspc node -f east
}

-- ctrl + {h,j,k,l} -> bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}
local RESIZE = {
    { key = "h", x = -20, y = 0 },
    { key = "j", x = 0, y = 20 },
    { key = "k", x = 0, y = -20 },
    { key = "l", x = 20, y = 0 },
}

for _, entry in ipairs(FOCUS) do
    -- alt + {h,j,k,l}
    hl.bind(mod .. " + " .. entry.key, hl.dsp.focus({ direction = entry.direction }))
    -- alt + shift + {h,j,k,l} -> bspc node -s
    hl.bind(mod .. " + SHIFT + " .. entry.key, hl.dsp.window.swap({ direction = entry.direction }))
end

for _, entry in ipairs(RESIZE) do
    hl.bind(
        mod .. " + CTRL + " .. entry.key,
        hl.dsp.window.resize({ x = entry.x, y = entry.y, relative = true })
    )
end

-- alt + {_,shift + }c -> bspc node -f {next,prev}
hl.bind(mod .. " + c", hl.dsp.window.cycle_next({ next = true }))
hl.bind(mod .. " + SHIFT + c", hl.dsp.window.cycle_next({ next = false }))

-- alt + o -> bspc node -f last
hl.bind(mod .. " + o", hl.dsp.focus({ last = true }))

-- alt + shift + Return -> togglesplit (dwindle only)
hl.bind(mod .. " + SHIFT + Return", hl.dsp.layout("togglesplit"))