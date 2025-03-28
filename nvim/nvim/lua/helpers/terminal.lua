local M = {}

-- Local state to store terminal buffer/window
local terminal_bufnr = nil
local terminal_winid = nil

-- Check if current mode is terminal job mode
local function in_terminal_insert_mode()
  return vim.api.nvim_get_mode().mode == "t"
end

-- Check if the terminal window is currently visible
local function is_terminal_open()
  return terminal_winid and vim.api.nvim_win_is_valid(terminal_winid)
end

function M.toggle()
  if is_terminal_open() and in_terminal_insert_mode() then
    -- First, exit insert mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  end

  -- Close terminal if it's open
  if terminal_winid and vim.api.nvim_win_is_valid(terminal_winid) then
    vim.api.nvim_win_close(terminal_winid, true)
    terminal_winid = nil
    return
  end

  -- Reuse buffer if it exists
  if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) then
    vim.cmd('botright split')
    terminal_winid = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(terminal_winid, terminal_bufnr)
    vim.cmd('startinsert')
  else
    -- Create new terminal
    vim.cmd('botright split | terminal')
    terminal_winid = vim.api.nvim_get_current_win()
    terminal_bufnr = vim.api.nvim_get_current_buf()
  end
end

return M
