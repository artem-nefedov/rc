local M = {}

function M.find_git_root()
  local gitdir = vim.fn.finddir('.git', ';'):gsub('.git$', '', 1)
  if gitdir == '' then
    return vim.fn.getcwd()
  end
  return gitdir
end

return M
