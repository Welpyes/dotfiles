"""Shared, non-visual preferences.

Kept in its own leaf module so the key/layout modules can import from it without
circular-importing ``config.py``.
"""

# Primary modifier. `alt` is mod1, which is what sxhkdrc used, so the bspwm
# bindings land on the same physical key.
mod = "mod1"

# Wayland terminal. Previously `guess_terminal()`, which infers the terminal from
# $TERMINAL and so silently changes behaviour depending on the environment qtile
# happened to be launched from.
terminal = "foot"