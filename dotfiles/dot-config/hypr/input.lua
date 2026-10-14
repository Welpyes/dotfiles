-- Input devices.
--
-- Port of xorg.conf.d/*.conf. Those files only apply to an Xorg session; under
-- Wayland the compositor configures libinput instead. Each block below mirrors
-- one Xorg file.
--
-- The `type:` selector form applies to every device of that class, so these
-- work regardless of which keyboard, mouse or touchpad is plugged in.

hl.config({
    input = {
        kb_layout = "us",
        -- xkbcommon wants the symbol spelled out with '+' joined modifiers;
        -- the Xorg spelling (terminate:ctrl_alt_bksp) would not apply.
        kb_options = "terminate:ctrl+alt+Backspace",

        follow_mouse = 1,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
    },
})

-- xorg.conf.d/40-mouse.conf
--   MatchIsPointer yes / AccelProfile flat / AccelSpeed 0
hl.device({
    name = "type:pointer",
    accel_profile = "flat",
    sensitivity = 0,
})

-- xorg.conf.d/40-touchpad.conf
--   Tapping / NaturalScrolling / DisableWhileTyping / ClickMethod clickfinger
--   / AccelSpeed 0.3 / ScrollMethod twofinger
hl.device({
    name = "type:touchpad",
    tap_to_click = true,
    natural_scroll = true,
    disable_while_typing = true,
    clickfinger_behavior = true,
    sensitivity = 0.3,
    -- Hyprland spells two-finger scrolling "2fg"; Xorg spells it twofinger.
    scroll_method = "2fg",
})

-- Three-finger horizontal swipe switches workspace, matching bspwm's tag model.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })