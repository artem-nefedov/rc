-- Git hunks operations
local gitsigns = require('gitsigns')
vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Git [H]unk [S]stage' })
vim.keymap.set('n', '<leader>hu', gitsigns.reset_hunk, { desc = 'Git [H]unk [U]ndo' })
vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Git [H]unk [P]review' })
vim.keymap.set('n', '[c', gitsigns.prev_hunk, { desc = 'Previous git hunk' })
vim.keymap.set('n', ']c', gitsigns.next_hunk, { desc = 'Next git hunk' })
