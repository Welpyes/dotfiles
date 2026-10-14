"""The tiling layout.

bspwm's tiling is inherent to the WM rather than configuration, so there is nothing
to port: qtile ships an equivalent ``Bsp`` layout. The arguments below reproduce
what ``bspwmrc`` set through ``bspc config``:

    window_gap / *_padding 10   -> margin / margin_on_single
    border_width 2             -> border_width
    normal_border_color        -> border_normal
    focused_border_color       -> border_focus
"""

from libqtile import layout

from theme import BORDER_FOCUS, BORDER_NORMAL

GAP = 5  # WINDOW_GAP in bspwmrc

bsp = layout.Bsp(
    margin=GAP,
    margin_on_single=GAP,
    border_width=2,
    # qtile drops the border when a group holds a single window; bspwm's
    # `bspc config border_width 2` applies unconditionally.
    border_on_single=True,
    border_focus=BORDER_FOCUS,
    border_normal=BORDER_NORMAL,
    # bspwm splits the *focused* window. qtile's default (fair=True) instead
    # inserts into the shortest branch of the tree, so turn it off to match.
    fair=False,
    lower_right=True,
)
