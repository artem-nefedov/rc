-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
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

vim.keymap.set('n', '<leader>?', telescope_builtin.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>/', telescope_builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>sb', telescope_builtin.buffers, { desc = '[S]earch [B]uffers' })
vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sF', telescope_builtin.find_files, { desc = '[S]earch git [F]iles' })
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', telescope_builtin.registers, { desc = '[S]earch [R]egisters ' })

-- add 't' (terminal) maps
vim.keymap.set('n', '<leader>sk', function()
  telescope_builtin.keymaps({ modes = { 'n', 'i', 'c', 'x', 't' } })
end, { desc = '[S]earch [K]eymaps' })
