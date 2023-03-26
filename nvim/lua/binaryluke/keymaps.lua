vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save'}) -- save file
vim.keymap.set('n', '<leader><space>', ':nohl<cr>', {desc = 'Clear highlight'})

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Registered related key mappings
-- More useful info here: https://blog.sanctum.geek.nz/advanced-vim-registers/
vim.keymap.set({'n', 'x'}, 'x', '"_x') -- 'x' sends deleted chars to the black hole register

vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>') -- select all text in current buffer

vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>') -- open tmux-sessionizer while in vim

