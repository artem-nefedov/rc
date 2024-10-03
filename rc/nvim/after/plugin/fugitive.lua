-- Git menu
vim.keymap.set('n', 'gs', vim.cmd.Git, { desc = '[G]it [S]tatus window' })
vim.keymap.set('n', '<leader>l', '<cmd>0Gclog<cr>', { desc = '[G]it [L]og for current file (fugitive)' })
