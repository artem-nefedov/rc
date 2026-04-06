-- experimental UI v2 (:mes and such)
require('vim._core.ui2').enable({ enable = true, msg = { target = 'cmd' } })

-- Leader must be set before calling "lazy"
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- some bug happen randomly with editorconfig
-- probably caused by my config somewhere
vim.g.editorconfig = false

-- disable unused providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

require('initme.ensure_lazy')
require('initme.use_plugins')

vim.cmd.packadd('nvim.undotree')
