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

local term_word_yank_and_insert = function()
  local prev = vim.fn.getreg('"')
  vim.cmd.normal('"tyiW"tpi')
  vim.fn.setreg('"', prev)
end

local term_modifiable = function(ncmd)
  vim.bo.modifiable = true
  vim.keymap.del({ 'n', 'v' }, 'J', { buffer = true })
  vim.keymap.del({ 'n', 'v' }, 'gJ', { buffer = true })
  vim.cmd.normal(ncmd)
end

local term_init = function(args)
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.sidescrolloff = 0
  vim.opt_local.scrolloff = 0
  vim.opt_local.signcolumn = 'no'
  vim.w.nvr_term = args.buf
  vim.api.nvim_chan_send(vim.bo[args.buf].channel, (' export NVIM_BUF_ID=%d && chpwd\n'):format(args.buf))
  vim.b.terminal_pwd = vim.fn.getcwd()

  vim.keymap.set('n', '<c-w><c-l>', vim.fn.TerminalReset, { buffer = true, desc = 'Terminal reset' })
  vim.keymap.set('n', 'C', term_word_yank_and_insert, { silent = true, buffer = true, desc = 'Copy word into terminal' })
  vim.keymap.set('n', 'yy', term_yank, { silent = true, buffer = true, desc = 'Yank line and remove prompt symbol' })
  vim.keymap.set('n', 'o', vim.cmd.startinsert, { silent = true, buffer = true, desc = 'Enter terminal mode' })
  vim.keymap.set('n', 'O', vim.cmd.startinsert, { silent = true, buffer = true, desc = 'Enter terminal mode' })

  vim.keymap.set('n', '[[', function() vim.cmd('keeppatterns ?^➜') end,
    { silent = true, buffer = true, desc = 'Jump to previous terminal prompt' })
  vim.keymap.set('n', ']]', function() vim.cmd('keeppatterns /^➜') end,
    { silent = true, buffer = true, desc = 'Jump to next terminal prompt' })

  vim.keymap.set({ 'n', 'v' }, 'J', function() term_modifiable('J') end,
    { buffer = true, desc = 'Make term buffer modifiable and [J]oin lines' })
  vim.keymap.set({ 'n', 'v' }, 'gJ', function() term_modifiable('gJ') end,
    { buffer = true, desc = 'Make term buffer modifiable and [J]oin lines (no spaces)' })

  require('lualine').refresh()
  -- nmap <buffer> R :call chansend(&channel, "\<lt>c-a>\<lt>c-k>. ~/.zshrc\<lt>cr>")<cr>
  -- nnoremap <buffer> <c-w><c-l> :call Terminal_reset()<cr>
  -- nnoremap <buffer> D "tyiW:call Terminal_open()<cr>
end

local term_enter = function()
  vim.cmd.lcd({ args = { vim.b.terminal_pwd }, mods = { silent = true } })
end

local aug = vim.api.nvim_create_augroup('CustomTerminalSetup', { clear = true })

local zsh_term_patterm = 'term://*/zsh'

vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileReadPre' },
  { pattern = '*', callback = 'InheritExitRemap', group = aug })
vim.api.nvim_create_autocmd('WinEnter', { pattern = 'term://*', command = 'stopinsert', group = aug })
vim.api.nvim_create_autocmd('TermEnter', { pattern = zsh_term_patterm, callback = term_enter, group = aug })
vim.api.nvim_create_autocmd('TermOpen', { pattern = zsh_term_patterm, callback = term_init, group = aug })

local session_file = vim.fn.stdpath('data') .. '/session'

local save_session = function()
  vim.fn.system('test ! -f ' .. session_file .. ' || mv ' .. session_file .. ' ' .. session_file .. '.prev')
  vim.fn.DeleteHiddenBuffers()
  vim.cmd.mksession({ args = { session_file }, bang = true })
  print('Session saved')
end

local restore_session = function()
  vim.cmd.source(session_file)
  vim.fn.DeleteHiddenBuffers()
end

-- these must be set after nvimux setup to override nvimux defaults
vim.keymap.set('n', '<c-x><c-s>', save_session, { desc = 'Save session' })
vim.keymap.set('n', '<c-x><c-r>', restore_session, { desc = 'Restore session' })
vim.keymap.set('t', '<c-x><c-s>', function()
  save_session()
  vim.cmd.startinsert()
end, { desc = 'Save session (term)' })
vim.keymap.set('t', '<c-x><c-r>', function()
  vim.cmd.stopinsert()
  vim.schedule(function()
    restore_session()
    if vim.bo.buftype == 'terminal' then
      vim.cmd.startinsert()
    end
  end)
end, { desc = 'Restore session (term)' })

local term_insert_branch = function()
  vim.api.nvim_chan_send(vim.bo.channel, vim.b.terminal_git_branch)
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

-- operator-pending in terminal
vim.keymap.set('t', '<c-o>', '<c-\\><c-o>', { desc = '[O]perator-pending (terminal)' })
-- literal <c-o>
vim.keymap.set('t', '<c-x><c-o>', '<c-o>', { desc = 'Send literal Ctrl-[O] in terminal' })

vim.api.nvim_create_user_command('TerminalStatusUpdate', function(opts)
  local b = tonumber(opts.fargs[1], 10)
  vim.api.nvim_buf_set_var(b, 'terminal_pwd', opts.fargs[2])
  vim.api.nvim_buf_set_var(b, 'terminal_git_branch', opts.fargs[3])
  vim.api.nvim_buf_set_var(b, 'terminal_kube_ctx', opts.fargs[4])
  vim.api.nvim_buf_set_var(b, 'terminal_aws_profile', opts.fargs[5])
  local bufname = vim.api.nvim_buf_get_name(b)
  local new_bufname = bufname:gsub('^term://.+//', 'term://' .. vim.fn.fnamemodify(opts.fargs[2], ':~') .. '//', 1)
  vim.api.nvim_buf_call(b, function()
    vim.cmd.file({ args = { new_bufname }, mods = { silent = true, keepalt = true } })
  end)
  for _, win in ipairs(vim.fn.win_findbuf(b)) do
    vim.api.nvim_win_call(win, function()
      vim.cmd.lcd({ args = { opts.fargs[2] }, mods = { silent = true } })
    end)
  end
end, { desc = 'Called by chpwd() hook function in zsh', nargs = '+' })

vim.api.nvim_create_user_command('TerminalOpen', function(opts)
  vim.cmd.edit(opts.args)

  if vim.fn.isdirectory(opts.args) == 1 then
    vim.cmd.lcd({ args = { opts.args }, mods = { silent = true } })
  else
    vim.cmd.lcd({ args = { vim.fs.dirname(opts.args) }, mods = { silent = true } })
  end

  -- not working when opening oil buffers with "v" for some reason
  vim.keymap.set('n', 'ZQ', '<cmd>call GoBack(0)<cr>i',
    { buffer = true, desc = 'Go back (no save) and return to terminal mode' })
  vim.keymap.set('n', 'ZZ', '<cmd>call GoBack(1)<cr>i',
    { buffer = true, desc = 'Go back (with save) and return to terminal mode' })
end, { desc = 'Open file in current window using "v" command in zsh', nargs = 1 })
