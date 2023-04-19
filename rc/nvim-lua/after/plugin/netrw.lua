-- configure netrw
vim.g.netrw_keepdir = 0 -- change directory when navigating

local netrw_aug = vim.api.nvim_create_augroup('netrw', { clear = true })

local netrw_au_callback = function()
  vim.opt_local.list = false
  vim.keymap.set('n', 'e', vim.cmd.terminal, { silent = true, buffer = true })
end

vim.api.nvim_create_autocmd('Filetype', { pattern = 'netrw', callback = netrw_au_callback, group = netrw_aug })

-- au Filetype netrw vnoremap <buffer> <silent> t :call NetrwOpenMultiTab(v:count)<CR>
-- au Filetype netrw vnoremap <buffer> <silent> <expr> T ":call NetrwOpenMultiTab(" . (( v:count == 0) ? '' : v:count) . ")\<CR>"
-- au Filetype netrw nnoremap <buffer> <silent> TT :call NetrwOpenMultiTab()<CR>
-- au Filetype netrw setlocal nolist
-- au Filetype netrw nnoremap <buffer> e :term<cr>
