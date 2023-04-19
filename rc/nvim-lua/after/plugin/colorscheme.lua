-- Disalbe semantic highlight
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end

-- local colorscheme_group = vim.api.nvim_create_augroup('UpdateCustomColorScheme', { clear = true })
--
-- local colorscheme_callback = function()
--   for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
--     vim.api.nvim_set_hl(0, group, {})
--   end
-- end
--
-- vim.api.nvim_create_autocmd('ColorScheme', {
--   group = colorscheme_group,
--   callback = colorscheme_callback,
--   desc = 'Disable semantic highlighting'
-- })
