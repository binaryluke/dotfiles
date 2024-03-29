-- Reference (safe key mappings): https://vim.fandom.com/wiki/Unused_keys
-- Schema: keymap_[area]_[action]_[details]
local keymap_codereview_pick_diff_originhead = '<C-r>d'
local keymap_codereview_pick_pr = '<C-r>p'
local keymap_codereview_next_hunk = '[c'
local keymap_codereview_prev_hunk = ']c'
local keymap_codereview_change_base_originhead = '<C-r>bo'
local keymap_codereview_reset_base = '<C-r>br'

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
  { 'folke/which-key.nvim', opts = {} },
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
        local function map(mode, lhs, rhs, opts)
          opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end

        -- Navigation
        map('n', keymap_codereview_next_hunk, "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true, desc = "Next hunk" })
        map('n', keymap_codereview_prev_hunk, "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true, desc = "Prev hunk" })

        -- vim.keymap.set('n', keymap_codereview_prev_hunk, require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        -- vim.keymap.set('n', keymap_codereview_next_hunk, require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', keymap_codereview_reset_base, function() require('gitsigns').reset_base(true) end, { buffer = bufnr, desc = 'Gitsigns reset base' })
        vim.keymap.set('n', keymap_codereview_change_base_originhead, function() require('gitsigns').change_base('origin/HEAD', true) end, { buffer = bufnr, desc = 'Gitsigns change base to origin/HEAD' })
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

--  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-github.nvim"
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
      require("telescope").load_extension("gh")
    end
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  'nvim-treesitter/playground',

  'theprimeagen/harpoon',
  {
    'axkirillov/easypick.nvim',
    commit = '6ea5aef3eceba46a26091e2339c9b51d7e104648',
    dependencies = 'nvim-telescope/telescope.nvim'
  }
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

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-Down>'] = require('telescope.actions').cycle_history_prev,
        ['<C-Up>'] = require('telescope.actions').cycle_history_next,
        ['<C-h>'] = "which_key"
      },
    },
    path_display = {
      -- shorten = {
      --   len = 5,
      --   exclude = {-2, -1}
      -- }
    },
    layout_strategy = "vertical",
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '--glob=!.git/',
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S] Existing [B]uffers' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<c-p>', require('telescope.builtin').git_files, { desc = 'Search Git Files' })
vim.keymap.set('n', '<C-g>', require('telescope').extensions.live_grep_args.live_grep_args, { desc = "[S]earch by [R]ipgrep" })
vim.keymap.set('n', '<C-c>', require('telescope.builtin').resume, { desc = "Resume Telescope Search" })
vim.keymap.set("n", keymap_codereview_pick_pr, function() require('telescope').extensions.gh.pull_request({
  search = "status:success draft:false -author:@me -label:Draft -label:\"WIP\" -label:\"Don't Review\"",
  on_attach = function ()
    require('gitsigns').change_base('origin/HEAD', true)
  end
}) end, { desc = "Pick from pull requests ready for review" })
vim.keymap.set("n", "<leader>gs", function() require('telescope.builtin').git_status() end, { desc = "[G]it [S]tatus" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
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

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

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
  nmap('gr', function () require('telescope.builtin').lsp_references({ fname_width = 70 }) end, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

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
  tsserver = {},
  marksman = {},

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
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- elseif luasnip.expand_or_locally_jumpable() then
        -- luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      -- elseif luasnip.locally_jumpable(-1) then
        -- luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    -- { name = 'luasnip' },
  },
}

local easypick = require("easypick")
easypick.setup({
	pickers = {
		-- add your custom pickers here
		-- below you can find some examples of what those can look like

		-- list files inside current folder with default previewer
		{
			-- name for your custom picker, that can be invoked using :Easypick <name> (supports tab completion)
			name = "ls",
			-- the command to execute, output has to be a list of plain text entries
			command = "ls",
			-- specify your custom previwer, or use one of the easypick.previewers
			previewer = easypick.previewers.default()
		},

		-- diff current branch with base_branch and show files that changed with respective diffs in preview
		{
			name = "changed_files_originhead",
			command = "git diff --name-only $(git merge-base HEAD " .. 'origin/HEAD' .. " )",
			previewer = easypick.previewers.branch_diff({base_branch = 'origin/HEAD'})
		},

		-- list files that have conflicts with diffs in preview
		{
			name = "conflicts",
			command = "git diff --name-only --diff-filter=U --relative",
			previewer = easypick.previewers.file_diff()
		},
	}
})

-- Code review
vim.keymap.set("n", keymap_codereview_pick_diff_originhead, ':Easypick changed_files_originhead<CR>', { desc = "Pick changed files against origin/HEAD" })

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

-- Quickfix list
-- n.b. :colder, :cnewer to navigate quickfix lists, vim retains up to 10 of them
-- https://freshman.tech/vim-quickfix-and-location-list/
vim.keymap.set('n', '<leader>co', ':copen 30<cr>', { desc = "Open quickfix list" })
vim.keymap.set('n', '<leader>cc', ':cclose<cr>', { desc = "Close quickfix list" })
vim.keymap.set('n', '<leader>cn', ':cnext<cr>', { desc = "Next item in quickfix list" })
vim.keymap.set('n', '<leader>cp', ':cprev<cr>', { desc = "Prev item in quickfix list" })

vim.keymap.set('n', '<leader>gw', function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local sha = osExecute('git rev-parse origin/master')
  local filename = vim.fn.expand('%')
  local url = vim.env.GITHUB_BLOB_PREFIX .. sha .. '/' .. filename .. '#L' .. line
  osExecute('open "' .. url .. '"')
end, { desc = "Open the line in [G]ithub" })
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
