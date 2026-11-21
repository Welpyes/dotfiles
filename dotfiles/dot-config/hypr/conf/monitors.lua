-- sway: `output * mode 1366x768@60Hz bg ... fill`
-- Hyprland has no per-output background. The wallpaper is set with hyprpaper
-- (hyprpaper.conf, see above) or root color via misc.background_color
-- (needs misc.disable_hyprland_logo).
hl.monitor({
    output   = "*",
    mode     = "1366x768@60",
    position = "auto",
    scale    = "auto",
})
