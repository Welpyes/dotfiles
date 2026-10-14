-- Window state and WM control.
--
-- From the "bspwm hotkeys" and "Wm state" blocks of sxhkdrc.
--
-- Not ported, because Hyprland has no counterpart:
--   * node -g {marked,locked,sticky,private}  -- no per-window flags
--   * node -f @{parent,brother,first,second}  -- navigation is directional
--   * node newest.marked.local -n ...          -- depends on marked nodes

local settings = require("settings")
local mod = settings.mod

-- alt + q -> bspc node -c
hl.bind(mod .. " + q", hl.dsp.window.close())

-- alt + {t,shift + t,s,f} -> bspc node -t {tiled,pseudo_tiled,floating,fullscreen}
hl.bind(mod .. " + t", hl.dsp.window.float({ action = "unset" }))
hl.bind(mod .. " + SHIFT + t", hl.dsp.window.pseudo({ action = "toggle" }))
hl.bind(mod .. " + s", hl.dsp.window.float({ action = "set" }))
hl.bind(mod .. " + f", hl.dsp.window.fullscreen())

-- alt + {Left,Down,Up,Right} -> bspc node -v, floating windows only.
local MOVE = {
    { key = "left", x = -20, y = 0 },
    { key = "down", x = 0, y = 20 },
    { key = "up", x = 0, y = -20 },
    { key = "right", x = 20, y = 0 },
}
for _, entry in ipairs(MOVE) do
    hl.bind(
        mod .. " + " .. entry.key,
        hl.dsp.window.move({ x = entry.x, y = entry.y, relative = true })
    )
end

-- alt + shift + {q,r} -> bspc {quit,wm -r}
-- The wiki documents hl.dsp.reload_config(), but that dispatcher is absent from
-- the stubs shipped with 0.56.2, so go through hyprctl directly.
hl.bind(mod .. " + SHIFT + q", hl.dsp.exec_cmd("hyprshutdown"))
hl.bind(mod .. " + SHIFT + r", hl.dsp.exec_cmd("hyprctl reload"))

-- alt + shift + m -> bspc desktop -l next, i.e. toggling tiled <-> monocle.
-- Unlike qtile's Wayland backend, Hyprland can also be restarted, but a reload
-- is the cheaper equivalent of `bspc wm -r`.
local BASE_LAYOUT = "dwindle"
hl.bind(mod .. " + SHIFT + m", function()
    local current = hl.get_config("general.layout")
    hl.config({ general = { layout = (current == "monocle") and BASE_LAYOUT or "monocle" } })
end)