-- [[ Plugins ]]
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- -- repeat custom commands with "."
  'tpope/vim-repeat',

  -- Align
  'junegunn/vim-easy-align',

  -- Undotree
  'mbbill/undotree',

  -- Read without distractions
  'folke/twilight.nvim',
  'folke/zen-mode.nvim',

  -- Terminal multiplexer
  'artem-nefedov/nvim-editcommand',
  'hkupty/nvimux',

  -- fake language server for linters and stuff
  'nvimtools/none-ls.nvim',

  -- helm filetype detection
  'towolf/vim-helm',

  -- WTF is this
  'eandrju/cellular-automaton.nvim',

  -- resolve symlinks
  {
    'aymericbeaumet/symlink.vim',
    dependencies = {
      'moll/vim-bbye',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',          opts = {} },

  -- git log for selected text
  {
    'niuiic/git-log.nvim',
    dependencies = {
      'niuiic/core.nvim'
    },
  },

  -- complete jira issues
  'artem-nefedov/cmp-jira-issues.nvim',

  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'tpope/vim-fugitive',
      require('plugme.gitsigns'),
    },
  },

  {
    'chrishrb/gx.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
  },

  {
    'kylechui/nvim-surround',
    config = true,
  },

  require('plugme.lspconfig'),
  require('plugme.cmp'),
  require('plugme.colorscheme'),
  require('plugme.indent'),
  require('plugme.treesitter'),
  require('plugme.debug'),
  require('plugme.pantran'),
  require('plugme.bufferline'),
  require('plugme.oil'),
  require('plugme.trouble'),

  -- colorschemes
  -- 'ellisonleao/gruvbox.nvim',
  -- 'navarasu/onedark.nvim',
  -- 'rose-pine/neovim',
  -- 'catppuccin/nvim',
  -- 'loctvl842/monokai-pro.nvim',
  -- 'folke/tokyonight.nvim',
  -- 'Shatur/neovim-ayu',
  -- "rebelot/kanagawa.nvim",

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',         opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
  },

  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',
}, {})
