#!/usr/bin/env luajit
local home  = os.getenv("HOME")
local cdir  = os.getenv("XDG_CACHE_HOME") or home .. "/.cache"
local CACHE, HIST = cdir .. "/fl-apps.tsv", cdir .. "/fl-hist.tsv"
local TERM  = os.getenv("TERMINAL_CMD") or "foot -e"
local self  = arg[0]

local function q(s) return "'" .. s:gsub("'", "'\\''") .. "'" end

local function build()
  local ds = { (os.getenv("XDG_DATA_HOME") or home .. "/.local/share") .. "/applications" }
  for d in (os.getenv("XDG_DATA_DIRS") or "/usr/local/share:/usr/share"):gmatch("[^:]+") do
    ds[#ds + 1] = d .. "/applications"
  end
  for i, d in ipairs(ds) do ds[i] = q(d) end

  local seen, out = {}, {}
  local p = io.popen("find -L " .. table.concat(ds, " ") .. " -name '*.desktop' 2>/dev/null")
  for path in p:lines() do
    local f = io.open(path)
    if f then
      local name, exec, term, skip, inside
      for l in f:lines() do
        if l:sub(1, 1) == "[" then
          if l == "[Desktop Entry]" then inside = true elseif inside then break end
        elseif inside then
          local k, v = l:match("^(%a+)=(.*)")
          if k == "Name" then name = name or v
          elseif k == "Exec" then exec = exec or v
          elseif k == "Terminal" then term = (v == "true")
          elseif (k == "NoDisplay" or k == "Hidden") and v == "true" then skip = true
          elseif k == "Type" and v ~= "Application" then skip = true end
        end
      end
      f:close()
      if name and exec and not skip and not seen[name] then
        seen[name] = true
        exec = exec:gsub("%%%%", "\0"):gsub("%%[%a]", ""):gsub("%z", "%%"):gsub("%s+$", "")
        out[#out + 1] = name .. "\t" .. (term and "1" or "0") .. "\t" .. exec
      end
    end
  end
  p:close()
  table.sort(out)
  local tmp = CACHE .. ".tmp"
  local o = io.open(tmp, "w"); o:write(table.concat(out, "\n"), "\n"); o:close()
  os.rename(tmp, CACHE)
end

if arg[1] == "rebuild" then build() return end

local c = io.open(CACHE)
if not c then build() else c:close() end
os.execute("setsid -f luajit " .. q(self) .. " rebuild >/dev/null 2>&1")

-- history
local hist = {}
local h = io.open(HIST)
if h then
  for l in h:lines() do
    local n, name = l:match("^(%d+)\t(.*)")
    if n then hist[name] = tonumber(n) end
  end
  h:close()
end

local entries = {}
for l in io.lines(CACHE) do
  local name, term, exec = l:match("^([^\t]*)\t([^\t]*)\t(.*)$")
  if name then entries[#entries + 1] = { name = name, term = term, exec = exec, n = hist[name] or 0 } end
end
table.sort(entries, function(a, b)
  if a.n ~= b.n then return a.n > b.n end
  return a.name < b.name
end)

local tmp = os.tmpname()
local fzf = io.popen("fzf --layout=reverse --tiebreak=index --no-info --prompt='> ' > " .. q(tmp), "w")
for _, e in ipairs(entries) do fzf:write(e.name, "\n") end
fzf:close()

local f = io.open(tmp); local pick = f:read("*l"); f:close(); os.remove(tmp)
if not pick or pick == "" then return end

for _, e in ipairs(entries) do
  if e.name == pick then
    hist[pick] = e.n + 1
    local o = io.open(HIST, "w")
    for name, n in pairs(hist) do o:write(n, "\t", name, "\n") end
    o:close()
    local cmd = (e.term == "1" and TERM .. " " or "") .. e.exec
    os.execute("setsid -f sh -c " .. q("exec " .. cmd) .. " >/dev/null 2>&1")
    break
  end
end