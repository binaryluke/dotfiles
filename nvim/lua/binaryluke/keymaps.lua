vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save'}) -- save file
vim.keymap.set('n', '<leader><space>', ':nohl<cr>', {desc = 'Clear highlight'})

-- Registered related key mappings
-- More useful info here: https://blog.sanctum.geek.nz/advanced-vim-registers/
vim.keymap.set({'n', 'x'}, 'cp', '"+y') -- copy to clipboard
vim.keymap.set({'n', 'x'}, 'cv', '"+p') -- paste from clipboard
vim.keymap.set({'n', 'x'}, 'x', '"_x') -- 'x' sends deleted chars to the black hole register

vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>') -- select all text in current buffer


