local function link(src, target)
  vim.cmd.highlight({
    args = { 'link', src, target }
  })
end

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
    link('gitcommitSummary', 'Identifier')
    link('@markup.raw.markdown_inline', '@keyword.return')
    link('@markup.link.url.markdown_inline', 'String')
    link('@markup.link.label.markdown_inline', 'Special')
    link('@markup.list.markdown', 'Special')
    -- vim.cmd.KanagawaCompile() -- run manually instead
  end,
}
