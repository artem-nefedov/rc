-- setup statusline
local git_branch = function()
  return ' ' .. vim.b.gitsigns_head
end

local term_branch = function()
  return ' ' .. vim.fn.GetGitBranch(0)
end

local term_cwd = function()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":~:.")
end

local term_kubeconfig = function()
  return '󱃾 ' .. vim.split(vim.b.terminal_kubecontext, "/")[2]
end

local term_aws_profile = function()
  return vim.b.terminal_aws_profile and (' ' .. vim.b.terminal_aws_profile) or ''
end

local term_extension = {
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { term_branch, term_kubeconfig, term_aws_profile },
    lualine_c = { term_cwd },
    lualine_z = { 'location' },
  },
  filetypes = { '' }, -- terminal doesn't have a type
}

local cache_aug = vim.api.nvim_create_augroup('lualine_cache', { clear = true })
vim.api.nvim_create_autocmd({ 'CursorHold', 'BufWritePost' },
  { pattern = '*', command = 'unlet! b:lualine_cache', group = cache_aug })

local whitespace_detect = function()
  if vim.o.buftype ~= '' then
    return ''
  end

  if vim.b.lualine_cache == nil then
    local mix_indent

    if vim.o.expandtab then
      mix_indent = vim.fn.search([[\v^(\t| +\t)]], 'nwc')
    else
      mix_indent = vim.fn.search([[\v^( |\t+ )]], 'nwc')
    end

    local tr_space = vim.fn.search([[\s$]], 'nwc')

    ---@diagnostic disable-next-line: inject-field
    vim.b.lualine_cache = (mix_indent ~= 0 and 'MI:' .. mix_indent or '') .. (tr_space ~= 0 and 'TW:' .. tr_space or '')
  end

  return vim.b.lualine_cache
end

local function diff_source()
  ---@diagnostic disable-next-line: undefined-field
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_b = {
      git_branch,
      {
        'diff',
        source = diff_source
      },
    },
    lualine_z = {
      { 'location' },
      {
        whitespace_detect,
        color = {
          bg = 'orange',
        },
      },
    },
  },
  extensions = { term_extension, 'fugitive' },
})
