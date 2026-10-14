"""Focus / move / resize keys for the Bsp layout.

Mirrors the "Focus Swap" and "Move/Resize" blocks of sxhkdrc, rebound from
``alt``/``ctrl`` onto the single ``mod`` key.

Deliberately absent: sxhkdrc's *Preselect* block (``bspc node -p`` / ``-o``).
qtile's Bsp layout keeps no preselect state -- split direction is derived from
the split geometry -- so those bindings would have nothing to drive.
"""

from libqtile.config import Key
from libqtile.lazy import lazy

from settings import mod

keys = [
    # alt + {_,shift + }{h,j,k,l} -> bspc node -{f,s} {west,south,north,east}
    Key([mod], "h", lazy.layout.left(), desc="Focus west"),
    Key([mod], "j", lazy.layout.down(), desc="Focus south"),
    Key([mod], "k", lazy.layout.up(), desc="Focus north"),
    Key([mod], "l", lazy.layout.right(), desc="Focus east"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Swap west"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Swap south"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Swap north"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Swap east"),
    # ctrl + {h,j,k,l} -> bspc node -z
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow west"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow south"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow north"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow east"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset split ratios"),
    # Not from sxhkdrc: bspwm has no equivalent command. Flips the focused
    # split between vertical and horizontal.
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle split orientation",
    ),
]