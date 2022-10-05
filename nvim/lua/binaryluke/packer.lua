return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- lodash of neovim
  use 'nvim-lua/plenary.nvim'

  -- lsp and completions
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/nvim-cmp'

  -- find stuff
  -- todo: read telescope README.md and install optional deps like fd and fzf-native
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- prettier ftw
  use 'prettier/vim-prettier'

  -- color scheme
  use 'folke/tokyonight.nvim'
end)

