-- Shared preferences.
--
-- Kept as its own leaf module so the bind modules can require it without
-- circular-importing hyprland.lua.

local home = os.getenv("HOME") or "~"

return {
    -- Main modifier. sxhkdrc used `alt`, so the bspwm bindings land on the
    -- same physical key as the qtile config.
    mod = "ALT",

    terminal = "foot",

    -- Existing rofi helper; already hardcodes the dmenu.rasi theme that
    -- sxhkdrc passed by hand. Takes the mode as $1, defaulting to drun.
    rofi = home .. "/.config/rofi/launch.sh",

    -- Where hyprshot writes. Without an explicit -o it falls back to
    -- $XDG_PICTURES_DIR, which env.zsh sets to ~/Pictures.
    screenshots = home .. "/Pictures/screenshots",
}