local settings = require("settings")
local mod = settings.mod

hl.bind(mod .. " + q", hl.dsp.window.close())

hl.bind(mod .. " + t", hl.dsp.window.float({ action = "unset" }))
hl.bind(mod .. " + SHIFT + t", hl.dsp.window.pseudo({ action = "toggle" }))
hl.bind(mod .. " + s", hl.dsp.window.float({ action = "set" }))
hl.bind(mod .. " + f", hl.dsp.window.fullscreen())

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

hl.bind(mod .. " + SHIFT + q", hl.dsp.exec_cmd("hyprshutdown"))
hl.bind(mod .. " + SHIFT + r", hl.dsp.exec_cmd("hyprctl reload"))

local BASE_LAYOUT = "dwindle"
hl.bind(mod .. " + SHIFT + m", function()
  local current = hl.get_config("general.layout")
  hl.config({ general = { layout = (current == "monocle") and BASE_LAYOUT or "monocle" } })
end)
