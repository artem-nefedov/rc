local tags_regenerate = function()
  local root = vim.fs.root(0, '.git')

  if root == nil then
    error('Could not find git root')
  end

  print('Started re-generating tags in ' .. root)

  vim.system({
      'ctags',
      '--tag-relative=yes',
      '--exclude=.git',
      '-R',
      '-f',
      '.git/tags',
      '.'
    },
    { cwd = root },
    function(obj)
      if obj.code == 0 then
        print('Done re-generating tags')
      else
        error('ctags exited with non-zero code\n' .. vim.inspect(obj))
      end
    end)
end

vim.opt.tags:prepend('./.git/tags')
vim.keymap.set('n', '<leader>T', tags_regenerate, { desc = 'Regenerate [T]ags' })
