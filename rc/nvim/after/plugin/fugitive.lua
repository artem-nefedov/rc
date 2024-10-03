-- Git menu
vim.keymap.set('n', 'gs', vim.cmd.Git, { desc = '[G]it [S]tatus window' })
vim.keymap.set('n', '<leader>l', '<cmd>0Gclog|copen<cr>', { desc = 'Git [L]og for current file (fugitive)' })
vim.keymap.set('n', '<leader>rr', '<cmd>%y|Gedit|%d_|put|0d_|cclose|w<cr>', { desc = '[R]replace content of file with old revision (fugitive)' })
