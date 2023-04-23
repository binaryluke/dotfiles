
vim.g.mapleader = ' '

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.signcolumn = 'yes'
vim.opt.wrap = false

-- Use system clipboard
vim.api.nvim_set_option("clipboard","unnamed")

-- Configure prettier plugin to use pretier config file
-- It will also auto-format on save if prettier config file is present
vim.cmd [[
  let g:prettier#autoformat_config_present = 1
  let g:prettier#config#config_precedence = 'prefer-file'
]]

