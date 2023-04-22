return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp', dependencies = { 'rafamadriz/friendly-snippets' } },
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
  },
}
