local M = {}

function M.run(cmd)
  local handle = io.popen(cmd)

  if handle == nil then
    return "unknown"
  end

  local result = handle:read("*l")
  handle:close()

  return result
end

return M
