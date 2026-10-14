"""Application launchers.

Ported from the "Applications" block of sxhkdrc, minus the sxhkd-specific
bindings (reload sxhkd / reload picom, which have no analogue here).

Rofi goes through the existing ``~/.config/rofi/launch.sh`` helper rather than
repeating the ``-theme ~/.config/rofi/dmenu.rasi`` argument that sxhkdrc spelled
out by hand. launch.sh takes the mode as $1 and defaults to drun.
"""

import os

from libqtile.config import Key
from libqtile.lazy import lazy

from settings import mod

LAUNCHER = os.path.expanduser("~/.config/rofi/launch.sh")

keys = [
    # alt + space -> rofi -show drun
    Key([mod], "space", lazy.spawn([LAUNCHER, "drun"]), desc="App launcher"),
    # alt + Tab -> rofi -show window
    Key([mod], "Tab", lazy.spawn([LAUNCHER, "window"]), desc="Window switcher"),
    # alt + r -> rofi -show run
    Key([mod], "r", lazy.spawn([LAUNCHER, "run"]), desc="Run command"),
]