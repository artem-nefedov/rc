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
  mapping = cmp.mapping.preset.insert {
    -- ['<C-n>']     = cmp.mapping.select_next_item(),
    -- ['<C-p>']     = cmp.mapping.select_prev_item(),
    ['<C-d>']     = cmp.mapping.scroll_docs(-4),
    ['<C-f>']     = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete({}), -- <C-n> works instead
    ['<CR>']      = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
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
    ['<M-w>']     = cmp.mapping(function(_)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'jira_issues' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
})
