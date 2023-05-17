vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save'}) -- save file
vim.keymap.set('n', '<leader><space>', ':nohl<cr>', {desc = 'Clear highlight'})

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Registered related key mappings
-- More useful info here: https://blog.sanctum.geek.nz/advanced-vim-registers/
vim.keymap.set({'n', 'x'}, 'x', '"_x') -- 'x' sends deleted chars to the black hole register

vim.keymap.set('n', '<leader>A', ':keepjumps normal! ggVG<cr>') -- select all text in current buffer

vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>') -- open tmux-sessionizer while in vim

vim.keymap.set('n', '<C-w>x', ':q<CR>')

-- Quickfix list
-- n.b. :colder, :cnewer to navigate quickfix lists, vim retains up to 10 of them
-- https://freshman.tech/vim-quickfix-and-location-list/
vim.keymap.set('n', '<leader>co', ':copen 30<cr>')
vim.keymap.set('n', '<leader>cc', ':cclose<cr>')
vim.keymap.set('n', '<leader>cn', ':cnext<cr>')
vim.keymap.set('n', '<leader>cp', ':cprev<cr>')

-- Run tests
vim.keymap.set('n', '<leader>to', ':lua require"jester".run()<CR>') -- test one
vim.keymap.set('n', '<leader>tf', ':lua require"jester".run_file()<CR>') -- test file
vim.keymap.set('n', '<leader>tl', ':lua require"jester".run_last()<CR>') -- test one
vim.keymap.set('n', '<leader>do', ':lua require"jester".debug()<CR>') -- debug one
vim.keymap.set('n', '<leader>df', ':lua require"jester".debug_file()<CR>') -- debug file
vim.keymap.set('n', '<leader>dl', ':lua require"jester".debug_last()<CR>') -- debug one

-- Git fugitive
vim.keymap.set('n', '<leader>gs', ':G<CR>')

