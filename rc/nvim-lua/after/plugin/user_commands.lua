-- [[Global user commands]]

-- for accidental uppercase
vim.api.nvim_create_user_command('W', ':w<bang>', { bang = true })
