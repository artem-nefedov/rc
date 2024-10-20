-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')

require('cmp-jira-issues').setup({})

luasnip.config.setup({})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-y>'] = cmp.mapping(function(fallback) fallback() end, { 'i' }), -- keep original c-y behavior
    -- ['<C-n>']     = cmp.mapping.select_next_item(),
    -- ['<C-p>']     = cmp.mapping.select_prev_item(),
    ['<C-d>']     = cmp.mapping.scroll_docs(-4),
    ['<C-f>']     = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete({}), -- <C-n> works instead
    ['<CR>']      = cmp.mapping.confirm({
      -- behavior = cmp.ConfirmBehavior.Replace,
      -- select   = true,
    }),
    ['<Tab>']     = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
        -- TODO: use expand_or_locally_jumpable
        -- elseif luasnip.expand_or_jumpable() then
        --   luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>']   = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
        -- elseif luasnip.jumpable(-1) then
        --   luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),

    -- Think of <c-l> as moving to the right of your snippet expansion.
    --  So if you have a snippet that's like:
    --  function $name($args)
    --    $body
    --  end
    --
    -- <c-l> will move you to the right of each of the expansion locations.
    -- <c-h> is similar, except moving you backwards.
    ['<C-l>'] = cmp.mapping(function()
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { 'i', 's' }),
    ['<C-h>'] = cmp.mapping(function()
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { 'i', 's' }),

    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  }),
  sources = {
    {
      name = 'lazydev',
      -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
      group_index = 0,
    },
    { name = 'jira_issues' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
})

-- cmp.setup.cmdline('/', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })
--
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   },
--   {
--     {
--       name = 'cmdline',
--       option = {
--         ignore_cmds = { 'Man', '!' }
--       }
--     }
--   })
-- })
