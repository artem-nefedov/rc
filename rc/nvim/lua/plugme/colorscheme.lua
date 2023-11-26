return {
  'rebelot/kanagawa.nvim',
  priority = 1000,
  config = function()
    require('kanagawa').setup({
      compile = true,
      theme = 'wave',
      commentStyle = { italic = false },
      keywordStyle = { italic = false },
      colors = {
        palette = {
          waveBlue1 = '#2E3f44' -- visual selection
        },
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- dark completion menu (from help example)
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },
        }
      end
    })
    vim.cmd.colorscheme('kanagawa')
    vim.cmd.highlight({ args = { 'link', 'gitcommitSummary', 'Identifier' } })
    -- vim.cmd.KanagawaCompile() -- run manually instead
  end,
}
