-- setup statusline
local term_branch = function()
  return vim.fn.GetGitBranch(0)
end

local term_cwd = function()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":~:.")
end

local term_extension = {
  sections = {
    lualine_a = {'mode'},
    lualine_b = {term_branch},
    lualine_c = {term_cwd},
    lualine_z = {'location'},
  },
  filetypes = {''}, -- terminal doesn't have a type
}

local cache_aug = vim.api.nvim_create_augroup('lualine_cache', { clear = true })
vim.api.nvim_create_autocmd({'CursorHold', 'BufWritePost'}, { pattern = '*', command = 'unlet! b:lualine_cache', group = cache_aug })

local trailing_whitespace_detect = function()
  if vim.b.lualine_cache == nil then
    local space = vim.fn.search([[\s\+$]], 'nwc')
    ---@diagnostic disable-next-line: inject-field
    vim.b.lualine_cache = (space ~= 0 and 'TW:' .. space or '')
  end
  return vim.b.lualine_cache
end

require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_z = {
      {'location'},
      {
        trailing_whitespace_detect,
        color={
          bg = 'orange',
        },
      },
    },
  },
  extensions = { term_extension },
})
