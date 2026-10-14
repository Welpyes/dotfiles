local home = os.getenv("HOME") or "~"
local XRESOURCES = home .. "/.Xresources"

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
  return (out:gsub("^'(.*)'$", "%1"))
end

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
