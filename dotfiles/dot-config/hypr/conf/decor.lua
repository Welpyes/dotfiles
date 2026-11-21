-- sway gaps: `gaps inner 10`, `gaps outer 0`, `gaps top 10`, `gaps bottom 10`,
-- `gaps left 10`, `gaps right 10`. Hyprland has gaps_in and gaps_out only,
-- so the per-side sway gaps are not expressible; gaps_out = 0.
hl.config({
    general = {
        gaps_in     = 10,
        gaps_out    = 10, -- workspace padding (sway outer was 0)
        border_size = 2,  -- default_border / default_floating_border pixel 2
        col = {
            active_border   = "rgb(c0caf5)",
            inactive_border = "rgb(171823)",
        },
    },
    decoration = {
        rounding       = 10, -- sway corner_radius
        rounding_power = 2,
        -- sway: default_dim_inactive 0.1
        dim_inactive = true,
        dim_strength = 0.1,
        blur = {
            enabled = true,
            size    = 5,     -- blur_radius
            passes  = 2,     -- blur_passes
            noise   = 0.1,   -- blur_noise
            xray    = true,  -- sway: blur_xray
        },
        shadow = {
            enabled = true,       -- shadows enable
            range   = 10,         -- shadow_blur_radius
            color   = 0x99000000, -- shadow_color #00000099
        },
    },
    animations = {
        enabled = true,
        -- sway: animation_duration_ms 400. Hyprland sets speed per leaf;
        -- there is no single global duration knob.
    },
})
