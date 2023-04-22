local M = {}

function M.nmap(...)
  vim.keymap.set('n', ...)
end

function M.cmap(...)
  vim.keymap.set('n', ...)
end

return M
