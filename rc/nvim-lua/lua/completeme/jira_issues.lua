local Job = require('plenary.job')

local source = {}

local enabled = true

function source.new()
  local self = setmetatable({ cache = {} }, { __index = source })

  return self
end

function source:complete(_, callback)
  if not enabled then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()

  -- cache results
  if not self.cache[bufnr] then
    Job:new({
      'curl',
      '--silent',
      '--get',
      '--data-urlencode',
      'fields=summary,description',
      '--config',
      vim.env['HOME'] .. '/.jira-config',
      on_exit = function(job)
        local result = job:result()
        print(vim.inspect(job))
        print(vim.inspect(table.concat(result, '')))
        local ok, parsed = pcall(vim.json.decode, table.concat(result, ''))

        if not ok then
          enabled = false
          return
        end

        if parsed == nil then -- make linter happy
          enabled = false
          return
        end

        local items = {}
        for _, jira_issue in ipairs(parsed.issues) do
          jira_issue.body = string.gsub(jira_issue.body or '', '\r"', '')

          table.insert(items, {
            label = string.format('[%s] ', jira_issue.key),
            documentation = {
              kind = 'plaintext',
              value = string.format('[%s] %s\n\n%s', jira_issue.key, jira_issue.fields.summary,
              jira_issue.fields.description),
            },
          })
        end

        callback({ items = items, isIncomplete = false })
        self.cache[bufnr] = items
      end,
    }):start()
  else
    callback({ items = self.cache[bufnr], isIncomplete = false })
  end
end

function source.get_trigger_characters()
  return { '[' }
end

function source.is_available()
  return vim.bo.filetype == 'gitcommit' or
  (vim.bo.filetype == 'markdown' and vim.fs.basename(vim.api.nvim_buf_get_name(0)) == 'CHANGELOG.md')
end

require('cmp').register_source('jira_issues', source.new())
