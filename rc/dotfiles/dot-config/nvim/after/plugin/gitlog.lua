vim.keymap.set({'n', 'v'}, ',l', require('git-log').check_log, {desc = "Check Git [L]og of selected text"})
