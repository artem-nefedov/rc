-- [[Mappings not related to plugins]]

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- ; for command menu
vim.keymap.set('n', ';', 'q:i', { silent = true })

-- ZA to quit everything
vim.keymap.set('n', 'ZA', vim.cmd.quitall, { desc = 'Quit everything' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- emacs-like shortcuts for insert/command mode (and some for normal)
vim.keymap.set('n', '<c-a>', '^', { silent = true, desc = 'Go to start' })
vim.keymap.set('c', '<c-a>', '<home>', { desc = 'Go to start' })
vim.keymap.set('c', '<c-k>', '<c-\\>estrpart(getcmdline(),0,getcmdpos()-1)<cr>', { desc = 'Kill till the end of line' })

-- spelling check
vim.keymap.set('n', ',s', ':setlocal spell! spelllang=en_us | syntax spell toplevel<cr>', { desc = 'Toggle spellcheck' })

-- yanks into clipboard
local unnamed_to_clipboard = function()
  local r = vim.fn.getreg('"')
  vim.fn.setreg('*', r)
  print('Copied: ' ..
    vim.fn.strcharpart(vim.trim(vim.split(r, "\n", { plain = true, trimempty = true })[1]), 0, 80) ..
    (#r <= 80 and '' or ' ...'))
end

vim.keymap.set({ 'n', 'v' }, '<c-x>y', '"*y', { desc = '[Y]ank into clipboard' })
vim.keymap.set('n', '<c-x>Y', '"*Y', { desc = 'Shift-[Y]ank into clipboard' })
vim.keymap.set('n', '<c-x><c-y>', unnamed_to_clipboard, { desc = 'Copy unnamed register into clipboard' })

-- increment number under cursor with <c-x><c-a> because <c-a> is remapped
vim.keymap.set('n', '<c-x><c-a>', '<c-a>', { desc = 'Increment number under cursor' })
vim.keymap.set('n', '<c-x><c-x>', '<c-x>', { desc = 'Derement number under cursor' })
