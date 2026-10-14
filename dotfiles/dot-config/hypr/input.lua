hl.config({
  input = {
    kb_layout = "us",
    kb_model = "pc105",
    kb_options = "terminate:ctrl+alt+Backspace",

    accel_profile = "flat",
    sensitivity = 0,

    scroll_method = "2fg",

    follow_mouse = 1,

    touchpad = {
      tap_to_click = true,
      natural_scroll = true,
      disable_while_typing = true,
      clickfinger_behavior = true,
    },
  },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
