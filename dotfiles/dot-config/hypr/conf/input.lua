-- sway: input "type:touchpad" { tap enabled; natural_scroll enabled }
-- sway: input "type:pointer" { accel_profile flat; pointer_accel -0.10 }
-- Hyprland has no per-type (type:touchpad / type:pointer) sections;
-- touchpads go to input.touchpad, pointer accel/sensitivity to input.
hl.config({
    input = {
        accel_profile = "flat",
        sensitivity   = -0.10,
        touchpad = {
            tap_to_click   = true,  -- sway: tap enabled
            natural_scroll = true,
        },
    },
})
