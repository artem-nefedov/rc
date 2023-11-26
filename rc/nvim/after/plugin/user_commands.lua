-- [[Global user commands]]

-- for accidental uppercase
vim.api.nvim_create_user_command('W', ':w<bang>', { bang = true })

-- command! -bang -range=% -complete=file -nargs=* W <line1>,<line2>write<bang> <args>
