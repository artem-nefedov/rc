-- [[Mappings not related to plugins]]

local keymaps = require('helpme.keymaps')
local nmap = keymaps.nmap
local cmap = keymaps.cmap

-- Remap for dealing with word wrap
nmap('k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
nmap('j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- ; for command menu
nmap(';', 'q:i', { silent = true })

-- ZA to quit everything
nmap('ZA', vim.cmd.quitall, { desc = 'Quit everything' })

-- Diagnostic keymaps
nmap('[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
nmap(']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
nmap('<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
nmap('<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- emacs-like shortcuts for insert/command mode (and some for normal)
nmap('<c-a>', '^', { silent = true, desc = 'Go to start' })
cmap('<c-a>', '<home>', { desc = 'Go to start' })
cmap('<c-k>', '<c-\\>estrpart(getcmdline(),0,getcmdpos()-1)<cr>', { desc = 'Kill till the end of line' })

-- spelling check
nmap(',s', '<cmd>setlocal spell! spelllang=en_us | syntax spell toplevel<cr>', { desc = 'Toggle spellcheck' })

-- yanks into clipboard
local unnamed_to_clipboard = function()
  local r = vim.fn.getreg('"')
  vim.fn.setreg('*', r)
  print('Copied: ' ..
    vim.fn.strcharpart(vim.trim(vim.split(r, "\n", { plain = true, trimempty = true })[1]), 0, 80) ..
    (#r <= 80 and '' or ' ...'))
end

vim.keymap.set({ 'n', 'v' }, '<c-x>y', '"*y', { desc = '[Y]ank into clipboard' })
nmap('<c-x>Y', '"*Y', { desc = 'Shift-[Y]ank into clipboard' })
nmap('<c-x><c-y>', unnamed_to_clipboard, { desc = 'Copy unnamed register into clipboard' })

-- increment number under cursor with <c-x><c-a> because <c-a> is remapped
nmap('<c-x><c-a>', '<c-a>', { desc = 'Increment number under cursor' })
nmap('<c-x><c-x>', '<c-x>', { desc = 'Decrement number under cursor' })

-- store string without boundary markers into @s
local search_without_bounds = function()
  vim.cmd.normal({ args = { '*' }, bang = true })
  vim.fn.setreg('s', vim.fn.getreg('/'):gsub('^\\<', '', 1):gsub('\\>$', '', 1))
end

nmap('*', search_without_bounds, { desc = 'Search under cursor and store string without word bounds into @s' })
