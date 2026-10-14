"""Window state, workspace switching and WM control.

Drawn from the "bspwm hotkeys", "Wm state" and "Focus Swap" blocks of sxhkdrc.

Not ported from sxhkdrc, because qtile has no counterpart:

  * node -g {marked,locked,sticky,private}  -- no per-node flags
  * node -f @{parent,brother,first,second}  -- navigation is directional, not by
    tree path
  * node -t pseudo_tiled                     -- qtile is binary
    tiled/floating/fullscreen
  * node newest.marked.local -n ...          -- depends on marked nodes
  * desktop -l next (alt+shift+m)            -- cycles tiled/monocle; would
    require adding layout.Max() to `layouts`
  * desktop -f {prev,next} (alt+[ / alt+])   -- qtile 0.37 has no non-interactive
    next/prev workspace command: Group.get_next_group() is not exposed, and
    group names resolve through a plain groups_map lookup. Binding a literal
    neighbour would always jump to one fixed group, not relative to the current.
"""

from libqtile import qtile
from libqtile.config import Key
from libqtile.lazy import lazy

from settings import mod, terminal

keys = [
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # alt + q -> bspc node -c
    Key([mod], "q", lazy.window.kill(), desc="Close window"),
    # alt + {t,s,f} -> bspc node -t {tiled,floating,fullscreen}
    Key([mod], "t", lazy.window.disable_floating(), desc="Force tiled"),
    Key([mod], "s", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    # alt + {_,shift + }c -> bspc node -f {next,prev}
    # layout.next()/previous() act on the *current* group's layout, the closest
    # analogue to bspc's per-desktop window cycling. The group-level
    # next_window/prev_window would need a concrete group name bound in.
    Key([mod], "c", lazy.layout.next(), desc="Focus next window"),
    Key([mod, "shift"], "c", lazy.layout.previous(), desc="Focus previous window"),
    # alt + shift + {q,r} -> bspc {quit,wm -r}
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown qtile"),
    Key([mod, "shift"], "r", lazy.restart(), desc="Restart qtile"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload config"),
    # alt + shift + m -> bspc desktop -l next
    Key([mod, "shift"], "m", lazy.next_layout(), desc="Next layout"),
]

# alt + {Left,Down,Up,Right} -> bspc node -v, floating windows only.
keys += [
    Key([mod], "Left", lazy.window.move_floating(-20, 0), desc="Move floating window west"),
    Key([mod], "Down", lazy.window.move_floating(0, 20), desc="Move floating window south"),
    Key([mod], "Up", lazy.window.move_floating(0, -20), desc="Move floating window north"),
    Key([mod], "Right", lazy.window.move_floating(20, 0), desc="Move floating window east"),
]


# Virtual terminals. Only meaningful on the Wayland backend, so gate on it.
def _on_wayland() -> bool:
    return qtile.core.name == "wayland"


def vt_keys() -> list[Key]:
    # qtile.core.name isn't available at config load time, so defer the backend
    # check until the key is actually pressed. Modifier is spelled out rather
    # than reusing `mod`; this is the conventional ctrl+alt+Fx VT switch.
    return [
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=_on_wayland),
            desc=f"Switch to VT{vt}",
        )
        for vt in range(1, 8)
    ]


def group_keys(names: list[str]) -> list[Key]:
    """alt + {_,shift + }{1-9} -> bspc {desktop -f,node -d}."""
    out: list[Key] = []
    for name in names:
        out.append(Key([mod], name, lazy.group[name].toscreen(), desc=f"Switch to {name}"))
        out.append(
            Key(
                [mod, "shift"],
                name,
                lazy.window.togroup(name, switch_group=True),
                desc=f"Move window to {name}",
            )
        )

    return out