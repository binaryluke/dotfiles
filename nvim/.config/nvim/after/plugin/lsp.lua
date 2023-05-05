-- Language servers list: https://langserver.org/

local lsp = require("lsp-zero")
lsp.preset({
  name = 'minimal',
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = false,
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
})
local cmp_sources = lsp.defaults.cmp_sources()
table.insert(cmp_sources, {name = 'copilot'})

local prioritize = function (entry1, entry2)
  if entry1.copilot and not entry2.copilot then
    return true
  elseif entry2.copilot and not entry1.copilot then
    return false
  end
end

-- Provide `vim` global object in lua files
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v1.x/doc/md/api-reference.md#nvim_workspaceopts
lsp.nvim_workspace({
  library = vim.api.nvim_get_runtime_file('', true)
})

lsp.set_preferences({
  sign_icons = { }
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  sources = cmp_sources,
  preselect = cmp.PreselectMode.None,
  completion = {
    completeopt = 'menu,menuone,noinsert,noselect'
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      prioritize,

      -- Below is the default comparitor list and order for nvim-cmp
      cmp.config.compare.offset,
      -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)
  vim.keymap.set("n", "<leader>o", function() vim.lsp.buf.organize_imports() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.configure('tsserver', {
  on_attach = function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "<leader>f", function() vim.cmd("Prettier") end, opts)
  end
})

lsp.setup()

