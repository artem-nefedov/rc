-- Git hunks operations
local gitsigns = require('gitsigns')
local nmap = require('helpme.keymaps').nmap

nmap('<leader>hs', gitsigns.stage_hunk, { desc = 'Git [H]unk [S]stage' })
nmap('<leader>hu', gitsigns.reset_hunk, { desc = 'Git [H]unk [U]ndo' })
nmap('<leader>hU', gitsigns.undo_stage_hunk, { desc = 'Git stage [H]unk [U]ndo' })
nmap('<leader>hp', gitsigns.preview_hunk, { desc = 'Git [H]unk [P]review' })
nmap('[c', gitsigns.prev_hunk, { desc = 'Previous git hunk' })
nmap(']c', gitsigns.next_hunk, { desc = 'Next git hunk' })
