-- Leader must be set before calling "lazy"
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- some bug happen randomly with editorconfig
-- probably caused by my config somewhere
vim.g.editorconfig = false

-- disable unused providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- gdoc api (for gdoc.vim)
vim.g.path_to_creds = '~/.config/gdoc-nvim/credentials.json'

require('initme.ensure_lazy')
require('initme.use_plugins')
