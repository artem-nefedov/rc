-- [[ Setting options ]]

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
-- timeoutlen can only be set as global option (no setlocal)
-- lower timeoutlen is better for whichkey, but in terminal buffer too small is bad
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 700

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- where to open splits
vim.o.splitright = true
vim.o.splitbelow = true

-- show 80 symbols border
vim.o.colorcolumn = '80'

-- show non-printable symbols
vim.o.list = true

-- highlight cursorline
vim.o.cursorline = true
-- vim.o.cursorlineopt = 'number' -- highlight only current line number
