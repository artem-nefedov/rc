-- blink.cmp setup
local cmp = require('blink.cmp')

-- require('cmp-jira-issues').setup({})

cmp.setup({
  keymap = {
    -- 'default' (recommended) for mappings similar to built-in completions
    --   <c-y> to accept ([y]es) the completion.
    --    This will auto-import if your LSP supports it.
    --    This will expand snippets if the LSP sent a snippet.
    -- 'super-tab' for tab to accept
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- For an understanding of why the 'default' preset is recommended,
    -- you will need to read `:help ins-completion`
    --
    -- No, but seriously. Please read `:help ins-completion`, it is really good!
    --
    -- All presets have the following mappings:
    -- <tab>/<s-tab>: move to right/left of your snippet expansion
    -- <c-space>: Open menu or open docs if already open
    -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
    -- <c-e>: Hide menu
    -- <c-k>: Toggle signature help
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    preset = 'default',

    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
  },

  completion = {
    -- By default, you may press `<c-space>` to show the documentation.
    -- Optionally, set `auto_show = true` to show the documentation after a delay.
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer', 'jira' },
    per_filetype = {
      yaml = { 'path', 'snippets', 'buffer' }
    },
    providers = {
      lsp = {
        fallbacks = {} -- Remove buffer fallback, always show other sources
      },
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      jira = {
        name = 'Jira',
        module = 'cmp-jira-issues',
        opts = {},
        should_show_items = function(ctx)
          return ctx.trigger.initial_character == '['
        end,
      },
      buffer = {
        should_show_items = function(ctx)
          return ctx.trigger.initial_kind ~= 'trigger_character'
        end,
      },
    },
  },

  snippets = { preset = 'luasnip' },

  fuzzy = { implementation = 'prefer_rust_with_warning' },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
})
