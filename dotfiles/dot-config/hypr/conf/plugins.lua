hl.config({
    plugin = {
        hyprbars = {
            bar_color = "rgb(1a1b26)",
            bar_height = 24,
            on_double_click = "hyprctl dispatch fullscreen 1",
            bar_part_of_window = true,
            bar_precedence_over_border = true,
        },
    },
})

hl.plugin.hyprbars.add_button({
    bg_color = "rgb(f7768e)",
    fg_color = "rgb(ffffff)",
    size = 13,
    icon = " ",
    action = "hyprctl dispatch 'hl.dsp.window.close()'",
})

hl.plugin.hyprbars.add_button({
    bg_color = "rgb(9ece6a)",
    fg_color = "rgb(000000)",
    size = 13,
    icon = " ",
    action = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']],
})

hl.plugin.hyprbars.add_button({
    bg_color = "rgb(e0af68)",
    fg_color = "rgb(000000)",
    size = 13,
    icon = " ",
    action = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']],
})
