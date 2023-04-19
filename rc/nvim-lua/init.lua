-- Leader must be set before calling "lazy"
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- some bug happen randomly with editorconfig
-- probably caused by my config somewhere
vim.g.editorconfig = false

require('initme.ensure_lazy')
require('initme.use_plugins')
