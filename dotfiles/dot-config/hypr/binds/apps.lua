local settings = require("settings")
local mod = settings.mod

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(settings.terminal))
hl.bind(mod .. " + e", hl.dsp.exec_cmd(settings.terminal .. " -e yazi"))

hl.bind(mod .. " + space", hl.dsp.exec_cmd(settings.rofi .. " drun"))
hl.bind(mod .. " + Tab", hl.dsp.exec_cmd(settings.rofi .. " window"))
hl.bind(mod .. " + r", hl.dsp.exec_cmd(settings.rofi .. " run"))

hl.bind(
  mod .. " + SHIFT + s",
  hl.dsp.exec_cmd(
    "hyprshot -m output -o " .. settings.screenshots
      .. " -f '%Y-%m-%d_%H-%M-%S_hyprshot.png'"
  )
)
