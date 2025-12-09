vim.filetype.add({
  extension = {
    yaml = function(path, _)
      return path:match('/templates/.+[.]yaml$') and 'helm' or 'yaml'
    end,
    tpl = 'helm',
    tmpl = 'gotmpl',
    log = 'text',
  },
  filename = {
    ['dot-zshrc'] = 'zsh',
    ['dot-gitconfig'] = 'gitconfig',
  },
})
