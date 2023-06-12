return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- comments
  use 'tpope/vim-commentary'

  -- git
  use 'tpope/vim-fugitive'

  -- fuzzy find
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = {
      {'nvim-lua/plenary.nvim'},
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    config = function ()
      require("telescope").load_extension("live_grep_args")
      require("telescope").load_extension("git_worktree")
    end
  }

  -- color scheme
  use 'folke/tokyonight.nvim'

  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- prettier ftw
  use 'prettier/vim-prettier'

  -- harpoon
  use('theprimeagen/harpoon')

  -- git worktrees
  use('theprimeagen/git-worktree.nvim')

  use {
    'neovim/nvim-lspconfig',
    requires = {
      'folke/neodev.nvim',
    }
  }
end)

