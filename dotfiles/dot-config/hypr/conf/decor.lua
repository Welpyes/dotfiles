hl.config({
    general = {
        gaps_in     = 10,
        gaps_out    = 10, 
        border_size = 2,  
        col = {
            active_border   = "rgb(c0caf5)",
            inactive_border = "rgb(171823)",
        },
    },
    decoration = {
        rounding       = 10, 
        rounding_power = 2,
        dim_inactive = true,
        dim_strength = 0.2,
        blur = {
            enabled = false,
            size    = 5,     
            passes  = 2,     
            noise   = 0.1,   
            xray    = true,  
        },
        shadow = {
            enabled = true,
            range   = 10,
            color   = 0x99000000, 
        },
    },
    animations = {
        enabled = true,
    },
})

hl.animation({ leaf = "global", enabled = true, speed = 4, bezier = "default" })
