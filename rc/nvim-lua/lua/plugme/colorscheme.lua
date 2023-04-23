return {
  'rebelot/kanagawa.nvim',
  priority = 1000,
  config = function()
    require('kanagawa').setup({
      compile = true,
      commentStyle = { italic = false },
      keywordStyle = { italic = false },
    })
    vim.cmd.colorscheme('kanagawa-wave')
    -- vim.cmd.KanagawaCompile() -- run manually instead
  end,
}
