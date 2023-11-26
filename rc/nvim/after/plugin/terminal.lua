require('nvimux').setup({
  config = {
    prefix = '<C-x>',
    new_window = 'term',
    new_tab = 'term',
  },
  bindings = {},
})

vim.g.editcommand_prompt = '➜'

vim.keymap.set('t', '<c-x><c-x>', vim.cmd.stopinsert, { desc = 'Stop terminal insert' })

local term_yank = function()
  vim.cmd.yank()
  vim.fn.setreg('"', vim.fn.getreg('"'):gsub('^➜ ', '', 1):gsub('\n$', '', 1))
end

local term_init = function()
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.sidescrolloff = 0
  vim.opt_local.scrolloff = 0
  vim.opt_local.signcolumn = 'no'
  vim.w.nvr_term = vim.api.nvim_get_current_buf()
  vim.b.terminal_pwd = vim.fn.getcwd()

  vim.keymap.set('n', '<c-w><c-l>', vim.fn.TerminalReset, { buffer = true, desc = 'Terminal reset' })
  vim.keymap.set('n', 'C', '"tyiW"tpi', { silent = true, buffer = true, desc = 'Copy word into terminal' })
  vim.keymap.set('n', 'yy', term_yank, { silent = true, buffer = true, desc = 'Yank line and remove prompt symbol' })

  vim.fn.GetGitBranch(1)
  require('lualine').refresh()
  -- setlocal nonumber norelativenumber sidescrolloff=0 scrolloff=0
  -- let w:nvr_term = bufnr('%')
  -- let b:terminal_pwd = getcwd()
  -- nmap <buffer> o i
  -- nmap <buffer> O i
  -- nmap <buffer> R :call chansend(b:terminal_job_id, "\<lt>c-a>\<lt>c-k>. ~/.zshrc\<lt>cr>")<cr>
  -- nnoremap <buffer> <c-w><c-l> :call Terminal_reset()<cr>
  -- nnoremap <buffer> D "tyiW:call Terminal_open()<cr>
  -- nnoremap <buffer> C "tyiW"tpi
  -- nnoremap <buffer> J :<c-u>call Terminal_modify('J')<cr>
  -- vnoremap <buffer> J :<c-u>call Terminal_modify('J')<cr>
  -- nnoremap <buffer> gJ :<c-u>call Terminal_modify('gJ')<cr>
  -- vnoremap <buffer> gJ :<c-u>call Terminal_modify('gJ')<cr>
  -- nnoremap <buffer> <silent> yy yy:<c-u>call Terminal_regsub()<cr>
  -- call Get_git_branch(1)
  -- AirlineRefresh
end

local term_enter = function()
  vim.b.allow_git_refresh = 1
  vim.cmd.lcd(vim.b.terminal_pwd)
end

local aug = vim.api.nvim_create_augroup('CustomTerminalSetup', { clear = true })

local zsh_term_patterm = 'term://*/zsh'

vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileReadPre' },
  { pattern = '*', callback = 'InheritExitRemap', group = aug })
vim.api.nvim_create_autocmd('FileType', { pattern = 'netrw', callback = 'InheritExitRemap', group = aug })
vim.api.nvim_create_autocmd('WinEnter', { pattern = 'term://*', command = 'stopinsert', group = aug })
vim.api.nvim_create_autocmd('TermEnter', { pattern = zsh_term_patterm, callback = term_enter, group = aug })
vim.api.nvim_create_autocmd('TermLeave',
  { pattern = zsh_term_patterm, command = 'let b:allow_git_refresh = 0', group = aug })
vim.api.nvim_create_autocmd('TermOpen', { pattern = zsh_term_patterm, callback = term_init, group = aug })

-- augroup Term
--         au!
--         au Filetype netrw vmap <buffer> E .call feedkeys("i<end>\<lt>c-a>") \| term<cr>
--         au Filetype netrw nmap <buffer> E VE
-- augroup END

local save_session = function()
  vim.fn.system('test ! -f ~/.nvim-session || mv ~/.nvim-session ~/.nvim-session.prev')
  vim.fn.DeleteHiddenBuffers()
  vim.cmd.mksession({ args = { '~/.nvim-session' }, bang = true })
  print('Session saved')
end

local restore_session = function()
  vim.cmd.source('~/.nvim-session')
  local curtab = vim.fn.tabpagenr()
  local curwin = vim.fn.winnr()
  vim.api.nvim_exec2('tabdo windo call TerminalCD() | ' ..
    curtab .. 'tabn\n' .. curwin .. 'wincmd w', {})
end

-- these must be set after nvimux setup to override nvimux defaults
vim.keymap.set('n', '<c-x><c-s>', save_session, { desc = 'Save session' })
vim.keymap.set('n', '<c-x><c-r>', restore_session, { desc = 'Restore session' })
vim.keymap.set('t', '<c-x><c-s>', function()
  save_session()
  vim.cmd.startinsert()
end, { desc = 'Save session (term)' })
vim.keymap.set('t', '<c-x><c-r>', function()
  restore_session()
  vim.cmd.startinsert()
end, { desc = 'Restore session (term)' })

local term_insert_branch = function()
  vim.api.nvim_exec2('call chansend(b:terminal_job_id, GetGitBranch(0))', {})
end

-- insert branch in terminal
vim.keymap.set('t', '<c-x>b', term_insert_branch, { silent = true, desc = 'Insert branch into terminal' })

-- jump back to terminal
local term_goto_bound = function()
  if vim.w.nvr_term == nil then
    print('No bound terminal')
  else
    vim.cmd.buffer(vim.w.nvr_term)
    vim.cmd.startinsert()
  end
end

vim.keymap.set('n', '<c-x><c-e>', term_goto_bound, { desc = 'Jump back to bound terminal' })

vim.api.nvim_create_user_command('TerminalLCD', function(opts)
  vim.b.terminal_pwd = opts.args
  vim.cmd.lcd(opts.args)
end, { desc = 'Use by chpwd() function in shell', nargs = 1 })
