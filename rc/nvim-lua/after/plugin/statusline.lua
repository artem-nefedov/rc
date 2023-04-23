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

local trailing_whitespace_detect = function()
  local space = vim.fn.search([[\s\+$]], 'nwc')
  return space ~= 0 and "TW:"..space or ""
end

require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'catppuccin',
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
