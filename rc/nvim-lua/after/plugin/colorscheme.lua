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

-- local function theme_cycler()
--   local state = 0
--   local themes = {
--     "gruvbox",
--     "rose-pine",
--     "onedark",
--     "monokai-pro",
--     "catppuccin",
--     "tokyonight-moon",
--     "ayu-mirage",
--     "kanagawa",
--   }
--   return function()
--     state = (state + 1) % #themes
--     local theme = themes[state+1]
--     vim.cmd.colorscheme(theme)
--     print(theme)
--   end
-- end
--
-- vim.keymap.set("n", ",c", theme_cycler())
