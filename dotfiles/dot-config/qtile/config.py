"""qtile configuration.

Split into modules so this file stays a thin combiner. qtile puts the config
directory on ``sys.path`` and imports this file as a real Python module, and
``confreader._reload_config_submodules()`` re-imports every sibling module on
reload -- so edits to any module below are picked up by mod+ctrl+r.

  settings.py     mod key and terminal
  theme.py        palette read from ~/.Xresources, with fallbacks
  layout_bsp.py   the Bsp layout instance
  keys_bsp.py     focus / move / resize
  keys_apps.py    rofi launcher / window switcher / run
  keys_misc.py    window state, workspaces, WM control
"""

import os
from collections.abc import Callable

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Match, Output, Screen
from libqtile.lazy import lazy

from keys_apps import keys as app_keys
from keys_bsp import keys as bsp_keys
from keys_misc import group_keys, keys as misc_keys, vt_keys
from layout_bsp import bsp
from settings import mod
from theme import ACCENT, BACKGROUND, FOREGROUND, FONT, STATUSLINE

groups = [Group(str(i)) for i in range(1, 10)]
_group_names = [g.name for g in groups]

keys = bsp_keys + app_keys + misc_keys + vt_keys() + group_keys(_group_names)

# What alt+shift+m (bspc desktop -l next) cycles through. Bsp first so the WM
# starts in the layout it is configured for; Max is bspwm's "monocle".
layouts = [
    bsp,
    layout.Max(),
    # Try more layouts by unleashing below layouts. Bsp is deliberately absent
    # here -- it is already active above, as the configured layout_bsp.bsp.
    # layout.Stack(num_stacks=2),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font=FONT,
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

# The wallpaper bspwmrc passed to `feh --bg-fill`.
WALLPAPER = os.path.expanduser("~/Pictures/wallpapers/Suicool.jpg")

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.WindowName(),
                widget.Prompt(),
                widget.Systray(),
                widget.Clock(format="%a %d %b  %H:%M", foreground=ACCENT),
                widget.QuickExit(),
            ],
            26,
            background=STATUSLINE,
            foreground=FOREGROUND,
        ),
        background=BACKGROUND,
        wallpaper=WALLPAPER,
        wallpaper_mode="fill",
    ),
]

# Instead of screens, define a function to map each Screen to an Output.
fake_screens: list[Screen] | None = None
generate_screens: Callable[[list[Output]], list[Screen]] | None = None

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules: list = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True
screen_change_debounce_timeout = 1
auto_minimize = True

# Input device config for the Wayland backend.
wl_input_rules = None
wl_xcursor_theme = "left_ptr"
wl_xcursor_size = 24

idle_timers: list = []
idle_inhibitors: list = []

# qtile lies here on purpose; java UI toolkits inspect it and whitelist LG3D.
wmname = "LG3D"