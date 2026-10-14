local settings = require("settings")
local mod = settings.mod

local FOCUS = {
  { key = "h", direction = "left" },
  { key = "j", direction = "down" },
  { key = "k", direction = "up" },
  { key = "l", direction = "right" },
}

local RESIZE = {
  { key = "h", x = -20, y = 0 },
  { key = "j", x = 0, y = 20 },
  { key = "k", x = 0, y = -20 },
  { key = "l", x = 20, y = 0 },
}

for _, entry in ipairs(FOCUS) do
  hl.bind(mod .. " + " .. entry.key, hl.dsp.focus({ direction = entry.direction }))
  hl.bind(mod .. " + SHIFT + " .. entry.key, hl.dsp.window.swap({ direction = entry.direction }))
end

for _, entry in ipairs(RESIZE) do
  hl.bind(
    mod .. " + CTRL + " .. entry.key,
    hl.dsp.window.resize({ x = entry.x, y = entry.y, relative = true })
  )
end

hl.bind(mod .. " + c", hl.dsp.window.cycle_next({ next = true }))
hl.bind(mod .. " + SHIFT + c", hl.dsp.window.cycle_next({ next = false }))

hl.bind(mod .. " + o", hl.dsp.focus({ last = true }))

hl.bind(mod .. " + SHIFT + Return", hl.dsp.layout("togglesplit"))
