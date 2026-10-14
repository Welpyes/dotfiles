-- Input devices.
--
-- Port of xorg.conf.d/*.conf. Those files only apply to an Xorg session; under
-- Wayland there is no xorg.conf, and the compositor configures libinput itself.
--
-- The Xorg files split devices apart with MatchIsPointer / MatchIsTouchpad.
-- Hyprland's global config cannot do that: input.accel_profile,
-- input.sensitivity and input.scroll_method are shared by every pointing
-- device, and input.touchpad only carries touch-specific options.
-- hl.device() can override per device, but it matches on a literal name from
-- `hyprctl devices`, which is not portable across machines -- so this file
-- keeps everything global.

hl.config({
    input = {
        -- xorg.conf.d/00-keyboard.conf
        kb_layout = "us",
        -- The Xorg file says "pc105+inet", where `+inet` appends the legacy
        -- internet keysyms. xkbcommon takes the bare model name; modern
        -- keyboards emit the XF86 media keys directly, so those keysyms are
        -- not needed here.
        kb_model = "pc105",
        -- xkbcommon wants the symbol spelled out with '+' joined modifiers;
        -- the Xorg spelling (terminate:ctrl_alt_bksp) would not apply.
        kb_options = "terminate:ctrl+alt+Backspace",

        -- xorg.conf.d/40-mouse.conf
        accel_profile = "flat",
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        -- xorg.conf.d/40-touchpad.conf
        -- Hyprland spells two-finger scrolling "2fg"; Xorg spells it twofinger.
        scroll_method = "2fg",

        follow_mouse = 1,

        touchpad = {
            tap_to_click = true,
            natural_scroll = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            -- The Xorg touchpad's AccelSpeed 0.3 has no equivalent: input.touchpad
            -- exposes no sensitivity, and input.sensitivity is shared with the
            -- mouse, so this value cannot be set independently.
        },
    },
})

-- Three-finger horizontal swipe switches workspace, matching bspwm's tag model.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })