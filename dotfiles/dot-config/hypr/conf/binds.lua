local vars = require("conf/vars")
local term = vars.term

-- Applications
hl.bind("ALT + Return",         hl.dsp.exec_cmd(term))
hl.bind("ALT + Shift + Return", hl.dsp.exec_cmd(term))

hl.bind("ALT + space", hl.dsp.exec_cmd(vars.menuDrun))
hl.bind("ALT + Tab",   hl.dsp.exec_cmd(vars.menuWindow))
hl.bind("ALT + r",     hl.dsp.exec_cmd(vars.menuRun))

hl.bind("ALT + e", hl.dsp.exec_cmd(vars.fileManager))

-- Window management
hl.bind("ALT + q",         hl.dsp.window.close())
hl.bind("ALT + Shift + r", hl.dsp.reload_config())
hl.bind("ALT + Shift + q", hl.dsp.exit())

hl.bind("ALT + f",         hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("ALT + s",         hl.dsp.window.float({ action = "toggle" }))
hl.bind("ALT + Shift + m", hl.dsp.layout("togglesplit"))

-- sway: bindsym Print exec grim ~/Pictures/Screenshots/<date>.png
hl.bind("Print", hl.dsp.exec_cmd("grim ~/Pictures/Screenshots/$(date '+%d%m%y-%H%M%s').png"))

-- Focus
hl.bind("ALT + h", hl.dsp.focus({ direction = "left" }))
hl.bind("ALT + j", hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + k", hl.dsp.focus({ direction = "up" }))
hl.bind("ALT + l", hl.dsp.focus({ direction = "right" }))

-- Move windows
hl.bind("ALT + Shift + h", hl.dsp.window.move({ direction = "left" }))
hl.bind("ALT + Shift + j", hl.dsp.window.move({ direction = "down" }))
hl.bind("ALT + Shift + k", hl.dsp.window.move({ direction = "up" }))
hl.bind("ALT + Shift + l", hl.dsp.window.move({ direction = "right" }))

hl.bind("ALT + c",         hl.dsp.window.cycle_next())
hl.bind("ALT + Shift + c", hl.dsp.window.cycle_next({ next = false }))

hl.bind("ALT + bracketleft",  hl.dsp.focus({ workspace = "prev" }))
hl.bind("ALT + bracketright", hl.dsp.focus({ workspace = "next" }))

-- Workspaces 1-10: sway used $mod+<n> and $mod+Shift+<n>
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key "0"
    hl.bind("ALT + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind("ALT + Shift + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Resize (sway: resize grow/shrink <axis> 20px).
-- Hyprland 0.57.2: dsp.window.resize takes a table { x, y, relative?, window? }.
hl.bind("CTRL + ALT + h", hl.dsp.window.resize({ x = 20,  y = 0, relative = true }))
hl.bind("CTRL + ALT + j", hl.dsp.window.resize({ x = 0,  y = -20, relative = true }))
hl.bind("CTRL + ALT + k", hl.dsp.window.resize({ x = 0,  y = 20,  relative = true }))
hl.bind("CTRL + ALT + l", hl.dsp.window.resize({ x = -20, y = 0, relative = true }))

-- sway: move left/right/up/down 20px. Hyprland direction-move shifts by
-- window size; for pixel moves use window.move({ x = -20, relative = true }).
hl.bind("ALT + Left",  hl.dsp.window.move({ direction = "left" }))
hl.bind("ALT + Down",  hl.dsp.window.move({ direction = "down" }))
hl.bind("ALT + Up",    hl.dsp.window.move({ direction = "up" }))
hl.bind("ALT + Right", hl.dsp.window.move({ direction = "right" }))

-- Multimedia keys (pactl understands @DEFAULT_SINK@ / @DEFAULT_SOURCE@)
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("pactl set-sink-mute   @DEFAULT_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),      { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"),      { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true })
