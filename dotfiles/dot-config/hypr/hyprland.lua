local theme = require("theme")
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
})

hl.env("XCURSOR_THEME", theme.cursor_theme)
hl.env("XCURSOR_SIZE", tostring(theme.cursor_size))
hl.env("HYPRCURSOR_SIZE", tostring(theme.cursor_size))
hl.env("XCURSOR_FONT", theme.font)

hl.config({
  general = {
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
      xray = true,
      new_optimizations = true,
      size = 8,
      passes = 3,
      vibrancy = 0.1696,
      noise = 0.0117,
    },
  },
})

hl.config({
  dwindle = {
    preserve_split = true,
    force_split = 2,
  },
})

hl.config({
  master = {
    new_status = "master",
  },
})

hl.config({
  scrolling = {
    fullscreen_on_one_column = true,
  },
})

require("animations")
require("wallpaper")
require("input")
require("rules")
require("binds.tiling")
require("binds.windows")
require("binds.workspaces")
require("binds.apps")

hl.on("hyprland.start", function()
  hl.exec_cmd("~/.config/fabric/venv/bin/python ~/.config/fabric/config.py")
end)
