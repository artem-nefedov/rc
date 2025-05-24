-- [[ Plugins ]]
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
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
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'gbprod/none-ls-shellcheck.nvim',
    }
  },

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

  'tommcdo/vim-fubitive',

  {
    'kylechui/nvim-surround',
    config = true,
  },

  require('plugme.lazydev'),
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
  require('plugme.gx'),
  require('plugme.guessindent'),

  { 'Bilal2453/luvit-meta', lazy = true },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',         opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
  },

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
