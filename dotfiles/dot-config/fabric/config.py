"""A vertical bar pinned to the left edge.

32px wide, full monitor height, split into three sections:
  top    - empty for now
  center - workspaces as circles
  bottom - a two row clock (12 hour, no AM/PM)

Run it with the project venv:

    ~/.config/fabric/venv/bin/python ~/.config/fabric/config.py
"""

import os

import gi

from fabric import Application
from fabric.hyprland.widgets import HyprlandWorkspaces
from fabric.core.widgets import WorkspaceButton
from fabric.widgets.box import Box
from fabric.widgets.datetime import DateTime
from fabric.widgets.wayland import WaylandWindow

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

BAR_WIDTH = 32
WORKSPACES = range(1, 10)
CIRCLE_SIZE = 14
DOT_SIZE = 4

HERE = os.path.dirname(os.path.abspath(__file__))
STYLES = os.path.join(HERE, "styles", "style.css")


def workspace_button(workspace_id: int) -> WorkspaceButton:
  return WorkspaceButton(
    id=workspace_id,
    child=Box(name="dot", h_expand=True, v_expand=True),
    size=(CIRCLE_SIZE, CIRCLE_SIZE),
    h_align="center",
  )


def workspace_list() -> HyprlandWorkspaces:
  ws = HyprlandWorkspaces(
    name="workspaces",
    orientation="v",
    buttons=[workspace_button(i) for i in WORKSPACES],
    buttons_factory=workspace_button,
  )
  ws.set_valign(Gtk.Align.CENTER)
  ws.set_halign(Gtk.Align.CENTER)
  return ws


class VerticalBar(WaylandWindow):
  def __init__(self, **kwargs):
    super().__init__(
      layer="top",
      anchor="left top bottom",
      exclusivity="auto",
      child=Box(
        name="bar",
        orientation="v",
        h_expand=True,
        v_expand=True,
        children=[
          Box(name="bar-top", orientation="v"),
          Box(
            name="bar-center",
            orientation="v",
            h_expand=True,
            v_expand=True,
            children=[workspace_list()],
          ),
          Box(
            name="bar-bottom",
            orientation="v",
            children=[
              DateTime(
                name="clock",
                formatters=("%I\n%M",),
              )
            ],
          ),
        ],
      ),
      style="background-color: #1a1b26;",
      visible=False,
      **kwargs,
    )

    self.set_default_size(BAR_WIDTH, -1)
    self.set_size_request(BAR_WIDTH, -1)

    self.show_all()


if __name__ == "__main__":
  app = Application("bar", VerticalBar())
  app.set_stylesheet_from_file(STYLES)
  app.run()