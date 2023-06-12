local M = {}

M.mainKeymaps = function()
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

  -- Notes
  vim.keymap.set('n', '<leader>no', ':!open "/Users/lukehoward/notes/_attachments') -- open
  vim.keymap.set('n', '<leader>nr', ':!mv "/Users/lukehoward/notes/_attachments') -- rename
end

-- LSP
local lspBaseKeymaps = function(opts)
  -- Buffer local mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  -- vim.keymap.set('n', '<space>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, opts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<space>f', function()
    vim.lsp.buf.format { async = true }
  end, opts)
end

M.lspLuaKeymaps = function(opts)
  lspBaseKeymaps(opts)
end

M.lspTypescriptKeymaps = function(buffer)
  lspBaseKeymaps({ buffer = buffer })
  vim.keymap.set("n", "<leader>f", function() vim.cmd("Prettier") end, { buffer = buffer, remap = false })
end

return M

