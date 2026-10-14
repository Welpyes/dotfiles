-- Palette.
--
-- Parsed straight out of ~/.Xresources so it stays the single source of truth
-- shared with st, GTK, bspwm and qtile (see dotfiles/dot-Xresources). Hyprland
-- cannot read Xresources itself, so without this the Tokyo Night palette would
-- have to be duplicated here.
--
-- The file is read directly rather than via `xrdb -query` because Hyprland runs
-- on Wayland, where there is no X server to query.
--
-- Every colour also carries a literal fallback, so a missing or malformed
-- Xresources degrades instead of erroring.

local home = os.getenv("HOME") or "~"
local XRESOURCES = home .. "/.Xresources"

-- Mirrors the values in dotfiles/dot-Xresources.
local FALLBACK = {
    ["st.background"] = "#1a1b26",
    ["st.foreground"] = "#c0caf5",
    ["colors.black2"] = "#171823",
    ["colors.one_bg"] = "#1d1e29",
    ["colors.statusline_bg"] = "#161722",
    ["colors.line"] = "#252631",
    ["colors.blue"] = "#7199ee",
    ["colors.cyan"] = "#38a89d",
    ["colors.green"] = "#98c379",
    ["colors.yellow"] = "#d7a65f",
    ["colors.purple"] = "#a485dd",
    ["colors.red"] = "#ee6d85",
    ["colors.white"] = "#a0a8cd",
    ["colors.grey"] = "#474853",
    ["colors.light_grey"] = "#545560",
}

local FONT = "Ioskeley Mono"
local CURSOR_FALLBACK = "Hoshimachi-Suisei"
local CURSOR_SIZE_FALLBACK = 24

local function trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

--- Parse an Xresources file into a table.
-- Handles `!` comments and `name: value` entries. Values may contain colons
-- (st.font: Ioskeley Mono:style=...), so only the first colon splits.
-- Line continuations are not handled; dot-Xresources does not use them.
local function read_xresources(path)
    local values = {}
    local handle = io.open(path, "r")
    if not handle then
        return values
    end

    for raw in handle:lines() do
        local line = raw
        local comment = line:find("!", 1, true)
        if comment then
            line = line:sub(1, comment - 1)
        end
        line = trim(line)

        local name, value = line:match("^([^:]+):(.*)$")
        if name and value then
            name, value = trim(name), trim(value)
            -- Skip wildcard resources: they are patterns, not concrete values.
            local first = name:sub(1, 1)
            if name ~= "" and first ~= "*" and first ~= "?" then
                values[name] = value
            end
        end
    end

    handle:close()
    return values
end

local X = read_xresources(XRESOURCES)

local function color(key)
    local v = X[key]
    if v and v ~= "" then
        return v
    end
    return FALLBACK[key] or FALLBACK["st.foreground"]
end

--- Convert #rrggbb to the rgba(rrggbbaa) form Hyprland expects for borders.
local function rgba(key, alpha)
    local hex = color(key):gsub("^#", "")
    if #hex == 6 then
        hex = hex .. (alpha or "ff")
    end
    return "rgba(" .. hex .. ")"
end

local function read_gsettings(schema, key)
    local handle = io.popen("gsettings get " .. schema .. " " .. key .. " 2>/dev/null")
    if not handle then
        return nil
    end
    local out = handle:read("*l")
    handle:close()
    if not out or out == "" then
        return nil
    end
    -- gsettings quotes strings: 'Hoshimachi-Suisei'
    return (out:gsub("^'(.*)'$", "%1"))
end

--- Resolve a cursor theme that actually exists.
-- wlr loads cursor themes by *directory* name under the XDG icon dirs and
-- silently falls back when the name does not resolve, so verify the candidate
-- has a cursors/ directory before trusting it.
local function resolve_cursor_theme()
    local candidate = read_gsettings("org.gnome.desktop.interface", "cursor-theme")
    if candidate and candidate ~= "" then
        local probe = io.open(home .. "/.icons/" .. candidate .. "/cursors", "r")
        if probe then
            probe:close()
            return candidate
        end
    end
    return CURSOR_FALLBACK
end

local cursor_size = tonumber(read_gsettings("org.gnome.desktop.interface", "cursor-size"))

return {
    font = FONT,

    -- Window borders. bspwmrc used colors.blue for the focused border and
    -- colors.black2 for the unfocused one.
    active_border = rgba("colors.blue"),
    inactive_border = rgba("colors.black2", "ee"),

    background = rgba("st.background"),
    foreground = rgba("st.foreground"),
    one_bg = rgba("colors.one_bg"),
    line = rgba("colors.line"),
    shadow = rgba("st.background", "ee"),

    cursor_theme = resolve_cursor_theme(),
    cursor_size = cursor_size or CURSOR_SIZE_FALLBACK,
}