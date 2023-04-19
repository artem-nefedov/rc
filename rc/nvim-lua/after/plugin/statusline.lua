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

require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
  extensions = { term_extension },
})
