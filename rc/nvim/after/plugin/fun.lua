-- well...
vim.keymap.set("n", "<leader>fml", function() vim.cmd.CellularAutomaton({ args = { 'make_it_rain' } }) end, { desc = 'Make it rain'})