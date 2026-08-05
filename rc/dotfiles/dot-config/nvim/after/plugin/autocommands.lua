-- [[ Highlight on yank ]]
-- See `:help vim.hl.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    -- vim.hl.on_yank()
    vim.hl.hl_op()
  end,
  group = highlight_group,
  pattern = '*',
})
