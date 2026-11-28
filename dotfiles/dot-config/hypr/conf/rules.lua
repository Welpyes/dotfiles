hl.window_rule({
  name = "launcher",
  match = { class = "^(launcher)$" },
  float = true,
  size = { 300, 500 },
  center = true,
})

hl.window_rule({
  name = "sane-floating-size",
  match = { float = true },
  max_size = { "monitor_w * 0.7", "monitor_h * 0.7" },
})
