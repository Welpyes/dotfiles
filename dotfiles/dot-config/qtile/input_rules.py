"""Input device configuration.

Port of ``xorg.conf.d/*.conf``. Those files only apply to an Xorg session; under
Wayland there is no xorg.conf, and the compositor configures libinput instead.
Each rule below mirrors one Xorg file, keyed by device type.

qtile matches the most specific key first: a device identifier, then ``type:X``,
then ``*``. These use ``type:`` so they apply regardless of which keyboard,
mouse or touchpad happens to be plugged in.
"""

from libqtile.backend.wayland import InputConfig

wl_input_rules = {
    # xorg.conf.d/00-keyboard.conf
    #   MatchIsKeyboard on / XkbLayout us / XkbModel pc105+inet
    #   XkbOptions terminate:ctrl_alt_bksp
    "type:keyboard": InputConfig(
        kb_layout="us",
        # xkbcommon wants the symbol spelled out with '+' joined modifiers;
        # the Xorg spelling (terminate:ctrl_alt_bksp) would not apply.
        kb_options="terminate:ctrl+alt+Backspace",
    ),
    # xorg.conf.d/40-mouse.conf
    #   MatchIsPointer yes / AccelProfile flat / AccelSpeed 0
    "type:pointer": InputConfig(
        accel_profile="flat",
        pointer_accel=0.0,
    ),
    # xorg.conf.d/40-touchpad.conf
    #   Tapping / NaturalScrolling / DisableWhileTyping / ClickMethod clickfinger
    #   / AccelSpeed 0.3 / ScrollMethod twofinger
    "type:touchpad": InputConfig(
        tap=True,
        natural_scroll=True,
        dwt=True,
        click_method="clickfinger",
        pointer_accel=0.3,
        # libinput spells this two_finger; the Xorg spelling is twofinger.
        scroll_method="two_finger",
    ),
}