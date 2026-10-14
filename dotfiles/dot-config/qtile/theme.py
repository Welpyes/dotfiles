"""Colour and font resolution.

The palette is parsed straight out of ``~/.Xresources`` so it stays the single
source of truth shared with st, GTK and bspwm (see ``dotfiles/dot-Xresources``).

The file is read directly rather than via ``xrdb -query``: qtile runs on Wayland,
so there is no X server to query and ``xrdb`` would return nothing. Reading the
file also means the colours resolve identically under X11 and Wayland.

Every colour carries a literal fallback from the same palette, so a missing or
malformed Xresources degrades instead of crashing.
"""

from __future__ import annotations

import os
import re
import subprocess

XRESOURCES = os.path.expanduser("~/.Xresources")

GTK_INTERFACE = "org.gnome.desktop.interface"

# Used when dconf has no cursor preference, or names a theme that is not
# installed. Must be a cursor theme *directory* name under ~/.icons, matching
# what nwg-look/lxappearance write into gsettings.
CURSOR_FALLBACK = "Hoshimachi-Suisei"
CURSOR_SIZE_FALLBACK = 24

# Mirrors the values in dotfiles/dot-Xresources.
FALLBACK = {
    "st.background": "#1a1b26",
    "st.foreground": "#c0caf5",
    "colors.black2": "#171823",
    "colors.one_bg": "#1d1e29",
    "colors.statusline_bg": "#161722",
    "colors.line": "#252631",
    "colors.blue": "#7199ee",
    "colors.cyan": "#38a89d",
    "colors.green": "#98c379",
    "colors.yellow": "#d7a65f",
    "colors.purple": "#a485dd",
    "colors.red": "#ee6d85",
    "colors.white": "#a0a8cd",
    "colors.grey": "#474853",
    "colors.light_grey": "#545560",
}

FONT = "Ioskeley Mono"


def _read_xresources(path: str = XRESOURCES) -> dict[str, str]:
    """Parse an Xresources file into a dict.

    Handles the parts of the format this repo actually uses: ``!`` comments,
    ``name: value`` entries, and backslash line continuations. Values may
    themselves contain colons (``st.font: Ioskeley Mono:style=...``), so only
    the first colon separates key from value.
    """
    try:
        with open(path, encoding="utf-8") as handle:
            raw = handle.read()
    except OSError:
        return {}

    # Join backslash continuations before splitting into logical lines.
    raw = re.sub(r"\\\s*\n\s*", " ", raw)

    values: dict[str, str] = {}
    for line in raw.splitlines():
        line = line.split("!", 1)[0].strip()
        if not line:
            continue
        name, sep, value = line.partition(":")
        if not sep:
            continue
        name = name.strip()
        if name and not name.startswith(("*", "?")):
            values[name] = value.strip()
    return values


_XRESOURCES = _read_xresources()


def _gsettings(schema: str, key: str) -> str | None:
    """Read a gsettings value, returning None if unavailable."""
    try:
        result = subprocess.run(
            ["gsettings", "get", schema, key],
            capture_output=True,
            text=True,
            timeout=2,
            check=False,
        )
    except (OSError, subprocess.SubprocessError):
        return None
    if result.returncode != 0:
        return None
    # gsettings quotes string values: 'Hoshimachi-Suisei'
    return result.stdout.strip().strip("'") or None


def _resolve_cursor_theme() -> str:
    """Pick a cursor theme that actually exists.

    wlr loads cursor themes by *directory* name under the XDG icon dirs and
    falls back silently when the name does not resolve -- so a theme name that
    is wrong in any way looks exactly like no theme at all. Verify the candidate
    has a cursors/ directory before trusting it.
    """
    candidate = _gsettings(GTK_INTERFACE, "cursor-theme")
    if candidate and os.path.isdir(os.path.expanduser(f"~/.icons/{candidate}/cursors")):
        return candidate
    return CURSOR_FALLBACK


CURSOR_THEME = _resolve_cursor_theme()

try:
    CURSOR_SIZE = int(_gsettings(GTK_INTERFACE, "cursor-size") or CURSOR_SIZE_FALLBACK)
except ValueError:
    CURSOR_SIZE = CURSOR_SIZE_FALLBACK


def color(key: str, default: str | None = None) -> str:
    """Resolve a single Xresources colour key, e.g. ``colors.blue``."""
    return _XRESOURCES.get(key) or FALLBACK.get(key) or default or FALLBACK["st.foreground"]


BACKGROUND = color("st.background")
FOREGROUND = color("st.foreground")

BORDER_FOCUS = color("colors.blue")
BORDER_NORMAL = color("colors.black2")

STATUSLINE = color("colors.statusline_bg")
ONE_BG = color("colors.one_bg")
LINE = color("colors.line")

DIM = color("colors.grey")
LIGHT = color("colors.light_grey")
ACCENT = color("colors.cyan")