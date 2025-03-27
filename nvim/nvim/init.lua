vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Helpers
local function osExecute(cmd)
  local handle = io.popen(cmd)

  if handle == nil then
    return "unknown"
  end

  local result = handle:read("*l")
  handle:close()

  return result
end

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  'prettier/vim-prettier',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {}, tag = 'legacy' },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      -- 'L3MON4D3/LuaSnip',
      -- 'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
        -- vim.keymap.set('n', '<leader>dr', function() require('gitsigns').reset_base(true) end, { desc = 'Gitsigns [D]iff [R]eset Base' })
        -- vim.keymap.set('n', '<leader>dc', function() require('gitsigns').change_base('origin/master', true) end, { desc = 'Gitsigns [D]iff [C]eset Base' })
      end,
    },
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_c = {
          {
            "filename",
            path = 1 -- relative path
          }
        }
      },
      inactive_sections = {
        lualine_c = {
          {
            "filename",
            path = 1 -- relative path
          }
        }
      }
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    'theprimeagen/harpoon',
    dependencies = {
      'nvim-lua/plenary.nvim',
    }
  },

  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({'fzf-tmux'})
    end
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- 'nvim-treesitter/playground',
  'github/copilot.vim',

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },

  -- beancount
  'nathangrigg/vim-beancount'
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.wrap = false
vim.wo.signcolumn = "yes"

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Prettier config to auto save
vim.g["prettier#autoformat_config_present"] = 1
vim.g["prettier#config#config_precedence"] = "prefer-file"

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Harpoon ]]
require("harpoon").setup({
  menu = {
    width = vim.api.nvim_win_get_width(0) - 4
  }
})

vim.keymap.set('n', '<leader>sb', require('fzf-lua').buffers, { desc = '[S] Existing [B]uffers' })
vim.keymap.set('n', '<leader>sf', require('fzf-lua').files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sd', require('fzf-lua').diagnostics_document, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<c-p>', require('fzf-lua').git_files, { desc = 'Search Git Files' })
vim.keymap.set('n', '<C-g>', function() require('fzf-lua').live_grep_glob({ rg_opts = "--sort=path --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e"--[[, continue_last_search = true ]] }) end, { desc = "[S]earch by [R]ipgrep" })
vim.keymap.set('n', '<C-c>', require('fzf-lua').resume, { desc = "Resume Search" })


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- CopilotChat keymaps
vim.keymap.set('n', "<leader>ccq",
    function()
      local input = vim.fn.input("Quick Chat: ")
      if input ~= "" then
        require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
      end
    end,
  { desc = "CopilotChat - Quick chat" }
)

vim.keymap.set('n', "<leader>ccp",
    function()
      local actions = require("CopilotChat.actions")
      require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
    end,
  { desc = "CopilotChat - Prompt actions" }
)

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('gr', function () require('fzf-lua').lsp_references({ fname_width = 70 }) end, '[G]oto [R]eferences')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  vtsls = {},
  marksman = {},
  eslint = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
-- local luasnip = require 'luasnip'
-- require('luasnip.loaders.from_vscode').lazy_load()
-- luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      -- luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = 'nvim_lsp' },
    -- { name = 'luasnip' },
  },

}

--- [[ Configure Treesitter ]]
--- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'bash', 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'javascript', 'vimdoc', 'vim', 'markdown', 'markdown_inline', 'query' },
  sync_install = true,
  ignore_install = {},
  modules = {},

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Function to run the git diff command and pass the output to fzf-lua with preview
local function git_diff_master_fzf()
  local fzf = require('fzf-lua')
  local handle = io.popen('git diff --name-only origin/master...HEAD')
  local result = handle:read("*a")
  handle:close()
  local files = {}
  for file in result:gmatch("[^\r\n]+") do
    table.insert(files, file)
  end
  fzf.fzf_exec(files, {
    prompt = 'Git Diff Files> ',
    preview = 'git diff origin/master...HEAD {} | delta',
    actions = {
      ['default'] = fzf.actions.file_edit,
    },
  })
end

-- Create a custom command to call the function
vim.api.nvim_create_user_command('GitDiffMaster', git_diff_master_fzf, {})

-- Harpon
vim.keymap.set("n", "<leader>ha", require('harpoon.mark').add_file, { desc = "[H]arpoon [A]dd File" })
vim.keymap.set("n", "<leader>ho", require('harpoon.ui').toggle_quick_menu, { desc = "[H]arpoon [O]pen Menu" })
vim.keymap.set("n", "<leader>h1", function() require('harpoon.ui').nav_file(1) end, { desc = "[H]arpoon Go To [1]" })
vim.keymap.set("n", "<leader>h2", function() require('harpoon.ui').nav_file(2) end, { desc = "[H]arpoon Go To [2]" })
vim.keymap.set("n", "<leader>h3", function() require('harpoon.ui').nav_file(3) end, { desc = "[H]arpoon Go To [3]" })
vim.keymap.set("n", "<leader>h4", function() require('harpoon.ui').nav_file(4) end, { desc = "[H]arpoon Go To [4]" })

-- More keymaps
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = "Open [P]roject [V]iew" })
vim.keymap.set('n', '<leader><space>', ':nohl<cr>', { desc = "Clear highlight" })
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>', { desc = "Open tmux sessionizer" })

-- Git
vim.keymap.set('n', '<C-s>', ':G<cr>', { desc = "Git [S]tatus via Fugitive" })

-- Split with movement to new pane
vim.keymap.set('n', '<C-w>s', '<C-w>s<C-w>j', { noremap = true, silent = true }) -- default is <C-a>s (but doesn't move)
vim.keymap.set('n', '<C-w>v', '<C-w>v<C-w>l', { noremap = true, silent = true }) -- default is <C-a>v (but doesn't move)

-- Resize splits with Alt + hjkl
vim.keymap.set('n', '<A-h>', ':vertical resize -2<CR>') -- default is <C-w>< (not repeatable)
vim.keymap.set('n', '<A-l>', ':vertical resize +2<CR>') -- default is <C-w>> (not repeatable)
vim.keymap.set('n', '<A-j>', ':resize -2<CR>') -- default is <C-w>- (not repeatable)
vim.keymap.set('n', '<A-k>', ':resize +2<CR>') -- default is <C-w>+ (not repeatable)

-- Close splits with Ctrl + x
vim.keymap.set('n', '<C-w>x', ':close<CR>') -- default  is <C-w>c

-- Quickfix list
-- n.b. :colder, :cnewer to navigate quickfix lists, vim retains up to 10 of them
-- https://freshman.tech/vim-quickfix-and-location-list/
vim.keymap.set('n', '<leader>co', ':copen 30<cr>', { desc = "Open quickfix list" })
vim.keymap.set('n', '<leader>cc', ':cclose<cr>', { desc = "Close quickfix list" })
vim.keymap.set('n', '<leader>cn', ':cnext<cr>', { desc = "Next item in quickfix list" })
vim.keymap.set('n', '<leader>cp', ':cprev<cr>', { desc = "Prev item in quickfix list" })
vim.keymap.set('n', '<leader>br', ':Gitsigns reset_base true<CR>', { desc = "[B]ase [R]eset" })
vim.keymap.set('n', '<leader>bm', ':Gitsigns change_base origin/master true<CR>', { desc = "[B]ase Change origin/[m]aster" })

vim.keymap.set('n', '<leader>gw', function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local sha = osExecute('git rev-parse origin/master')
  local filename = vim.fn.expand('%')
  local url = vim.env.GITHUB_BLOB_PREFIX .. sha .. '/' .. filename .. '#L' .. line
  osExecute('open "' .. url .. '"')
end, { desc = "Open the line in [G]ithub" })
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
