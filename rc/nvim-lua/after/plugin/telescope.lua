-- [[ Configure Telescope ]]

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
})

-- Enable telescope fzf native (must be installed)
require('telescope').load_extension('fzf')

-- See `:help telescope.builtin`
local telescope_builtin = require('telescope.builtin')
local nmap = require('helpme.keymaps').nmap

nmap('<leader>?', telescope_builtin.oldfiles, { desc = '[?] Find recently opened files' })
nmap('<leader>/', telescope_builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })
nmap('<leader>sb', telescope_builtin.buffers, { desc = '[S]earch [B]uffers' })
nmap('<leader>sf', telescope_builtin.git_files, { desc = '[S]earch git [F]iles' })
nmap('<leader>sF', telescope_builtin.find_files, { desc = '[S]earch [F]iles' })
nmap('<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp' })
nmap('<leader>sW', telescope_builtin.grep_string, { desc = '[S]earch current [W]ord (current dir)' })
nmap('<leader>sG', telescope_builtin.live_grep, { desc = '[S]earch by [G]rep (current dir)' })
nmap('<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
nmap('<leader>sr', telescope_builtin.registers, { desc = '[S]earch [R]egisters' })
nmap('<leader>sc', telescope_builtin.git_bcommits, { desc = '[S]earch git [C]ommits (current file)' })
nmap('<leader>sC', telescope_builtin.git_commits, { desc = '[S]earch git [C]ommits (repo-wide)' })
nmap('<leader>sB', telescope_builtin.git_branches, { desc = '[S]earch git [B]ranches' })

-- search configs and RCs
nmap('<leader>sp', function()
  telescope_builtin.git_files({ cwd = vim.fn.expand('~/git/personal') })
end, { desc = '[S]earch [P]ersonal git files' })

-- add 't' (terminal) maps
nmap('<leader>sk', function()
  telescope_builtin.keymaps({ modes = { 'n', 'i', 'c', 'x', 't' } })
end, { desc = '[S]earch [K]eymaps' })

local find_git_root = require('helpme.fs').find_git_root

-- grep from git root
nmap('<leader>sw', function()
  telescope_builtin.grep_string({ cwd = find_git_root() })
end, { desc = '[S]earch current [W]ord (git dir)' })

nmap('<leader>sg', function()
  telescope_builtin.live_grep({ cwd = find_git_root() })
end, { desc = '[S]earch by [G]rep (git dir)' })
