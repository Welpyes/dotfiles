hl.config({
  misc = {
    disable_hyprland_logo = true,
  },
})

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprpaper")
end)
