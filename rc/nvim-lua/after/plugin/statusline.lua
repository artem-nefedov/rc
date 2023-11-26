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

local whitespace_detect = function()
  if vim.b.lualine_cache == nil then
    local indent_warn = ''

    local space_indent = vim.fn.search([[^ ]], 'nwc')
    local tab_indent = vim.fn.search([[^\t]], 'nwc')
    local mixed = (space_indent > 0 and tab_indent > 0)
    local mixed_same_line
    if not mixed then
      mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], 'nwc')
      mixed = mixed_same_line > 0
    end

    if mixed then
      if mixed_same_line ~= nil and mixed_same_line > 0 then
        indent_warn = 'MI:' .. mixed_same_line
      else
        local space_indent_cnt = vim.fn.searchcount({pattern=[[^ ]], max_count=1e3}).total
        local tab_indent_cnt = vim.fn.searchcount({pattern=[[^\t]], max_count=1e3}).total
        indent_warn = 'MI:' .. (space_indent_cnt > tab_indent_cnt and tab_indent or space_indent)
      end
    end

    local tr_space = vim.fn.search([[\s\+$]], 'nwc')
    ---@diagnostic disable-next-line: inject-field
    vim.b.lualine_cache = indent_warn .. (tr_space ~= 0 and 'TW:' .. tr_space or '')
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
        whitespace_detect,
        color={
          bg = 'orange',
        },
      },
    },
  },
  extensions = { term_extension },
})
