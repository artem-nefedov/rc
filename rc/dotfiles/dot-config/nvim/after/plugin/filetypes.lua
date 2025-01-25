vim.filetype.add({
  extension = {
    yaml = function(path, _)
      return string.match(path, '/templates/[^/]+[.]yaml$') and 'helm' or 'yaml'
    end,
    tpl = 'helm',
  },
  filename = {
    ['dot-zshrc'] = 'zsh',
    ['dot-gitconfig'] = 'gitconfig',
  },
})
