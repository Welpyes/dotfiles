-- Workspaces.
--
-- alt + {_,shift + }{1-9,0} -> bspc {desktop -f,node -d} '^{1-9,10}'
-- Workspaces are Hyprland's analogue of bspwm tags.

local settings = require("settings")
local mod = settings.mod

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- alt + bracket{left,right} -> bspc desktop -f {prev,next}.local
-- Unlike qtile 0.37, which has no non-interactive next/prev workspace command,
-- Hyprland accepts a relative workspace selector here.
hl.bind(mod .. " + bracketleft", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + bracketright", hl.dsp.focus({ workspace = "e+1" }))