local home = os.getenv("HOME") or "~"

return {
  mod = "ALT",

  terminal = "foot",

  rofi = home .. "/.config/rofi/launch.sh",

  screenshots = home .. "/Pictures/screenshots",
}
