return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- lodash of neovim
  use 'nvim-lua/plenary.nvim'

  -- find stuff
  -- todo: read telescope README.md and install optional deps like fd and fzf-native
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- color scheme
  use 'folke/tokyonight.nvim'
end)

