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
  { 'folke/which-key.nvim', opts = {} },

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
      'tpope/vim-rhubarb',
      require('plugme.gitsigns'),
    },
  },

  -- :GBrowse BitBucket support
  'tommcdo/vim-fubitive',

  -- Surround bindings
  'kylechui/nvim-surround',

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
  -- require('plugme.octo'),

  { 'artem-nefedov/guh.nvim', branch = 'main' }, -- needs latest neovim
  { 'barrettruth/diffs.nvim' },

  -- {
  --   'johnseth97/gh-dash.nvim',
  --   -- lazy = true,
  --   keys = {
  --     {
  --       '<leader>cc',
  --       function() require('gh_dash').toggle() end,
  --       desc = 'Toggle gh-dash popup',
  --     },
  --   },
  --   -- opts = {
  --   --   keymaps     = {},    -- disable internal mapping
  --   --   border      = 'rounded', -- or 'double'
  --   --   width       = 0.8,
  --   --   height      = 0.8,
  --   --   autoinstall = true,
  --   -- },
  -- },

  -- {
  --   "undont/differ.nvim",
  --   build = "make go-build",
  --   config = function()
  --     require("differ").setup()
  --   end,
  -- },

  -- {
  --   "emrearmagan/atlas.nvim",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons", -- optional but recommended
  --     "MeanderingProgrammer/render-markdown.nvim", -- optional but recommended
  --     "esmuellert/codediff.nvim", -- optional (PullRequest diff)
  --     "sindrets/diffview.nvim", -- optional (PullRequest diff - alternative)
  --   },
  --   opts = {
  --     pulls = {
  --       providers = {
  --         github = {},    -- See configuration below
  --       },
  --     },
  --     issues = {
  --       providers = {
  --         jira = {},   -- See configuration below
  --       },
  --     },
  --   },
  -- },

  { 'Bilal2453/luvit-meta', lazy = true },

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
