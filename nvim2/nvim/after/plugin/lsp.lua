-- Setup neovim lua configuration (must be done before lsp setup)
require('neodev').setup({

})

local lspconfig = require('lspconfig')
local keymaps = require('binaryluke/keymaps')

-- neovim runtimepath can ve viewed with:
-- :set runtimepath?

-- Install lua-language-server from https://github.com/luals/lua-language-server/wiki/Getting-Started#command-line
lspconfig.lua_ls.setup {
  -- settings = {
  --   Lua = {
  --     runtime = {
  --       -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
  --       version = 'LuaJIT',
  --     },
  --     diagnostics = {
  --       -- Get the language server to recognize the `vim` global
  --       globals = {'vim'},
  --     },
  --     workspace = {
  --       -- Make the server aware of Neovim runtime files
  --       library = vim.api.nvim_get_runtime_file("", true),
  --       checkThirdParty = false
  --     },
  --     -- Do not send telemetry data containing a randomized but unique identifier
  --     telemetry = {
  --       enable = false,
  --     },
  --   },
  -- },
  on_attach = function (_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    -- vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Apply base keymaps
    keymaps.applyBaseKeymaps({ buffer = bufnr })
  end
}

-- npm install -g typescript-language-server typescript
lspconfig.tsserver.setup {
  on_attach = function(_, bufnr)
    keymaps.lspTypescriptKeymaps(bufnr)
  end
}

