-- [[Global user commands]]

-- for accidental uppercase
vim.api.nvim_create_user_command('W', ':w<bang>', { bang = true })

-- set AWS_PROFILE, and optionally AWS_REGION
vim.api.nvim_create_user_command('AWS', function(x)
  if table.maxn(x.fargs) == 0 then
    print('Unset AWS_PROFILE and AWS_REGION')
    vim.env.AWS_PROFILE = nil
    vim.env.AWS_REGION = nil
  elseif table.maxn(x.fargs) > 2 then
    error('Bad number of arguments')
    return
  else
    local msg = 'Set AWS_PROFILE to ' .. x.fargs[1]
    vim.env.AWS_PROFILE = x.fargs[1]
    if table.maxn(x.fargs) == 2 then
      msg = msg .. ' and AWS_REGION to ' .. x.fargs[2]
      vim.env.AWS_REGION = x.fargs[2]
    end
    print(msg)
  end
end, {
  nargs = '*',
  complete = function(_, l, _)
    if l:match('^AWS +$') then
      return { 'sbx', 'dev', 'stg', 'prd' }
    else
      return { 'us-west-2', 'eu-central-1' }
    end
  end,
})
