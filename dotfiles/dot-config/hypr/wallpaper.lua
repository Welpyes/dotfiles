-- Wallpaper.
--
-- Hyprland has no native wallpaper setter, so the wallpaper itself lives in
-- hyprpaper.conf (stowed alongside this file). This module does the two things
-- the compositor needs: kill its own default background, and start the daemon.
--
-- Without the daemon running, `hyprctl hyprpaper ...` has no handler and the
-- request is silently dropped. Combined with disable_hyprland_logo that shows up
-- as a black screen rather than as an error.

hl.config({
    misc = {
        -- Disables the random Hyprland logo / anime girl background. With no
        -- wallpaper drawn, the screen falls back to misc.background_color,
        -- which is near-black -- so this must be paired with hyprpaper running.
        disable_hyprland_logo = true,
    },
})

hl.on("hyprland.start", function()
    -- Reads ~/.config/hypr/hyprpaper.conf, which carries the wallpaper path.
    hl.exec_cmd("hyprpaper")
end)