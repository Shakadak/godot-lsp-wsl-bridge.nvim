local M = {}

function M.win_to_wsl(path)
  path = path:gsub("\\", "/")
  local drive, rest = path:match("^(%a):/(.*)$")
  drive = drive:lower()
  return "/mnt/" .. drive .. "/" .. rest
end

function M.wsl_to_win(path)
  local drive, rest = path:match("^/mnt/(%a)/(.*)$")
  drive = drive:upper()
  rest = rest:gsub("/", "\\")
  return drive .. ":\\" .. rest
end

return M
