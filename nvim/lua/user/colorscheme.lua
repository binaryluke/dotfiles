-- Inspired heavily by https://youtu.be/RtNPfJKNr_8

local colorscheme = "default"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
