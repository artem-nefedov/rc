local function find_tab_by_bufnr(bufnr)
  local wins = vim.fn.win_findbuf(bufnr)
  if #wins == 0 then
    return ''
  end
  local win_set = {}
  for _, w in ipairs(wins) do
    win_set[w] = true
  end
  local tabs = {}
  for _, t in ipairs(vim.fn.gettabinfo()) do
    for _, w in ipairs(t.windows) do
      if win_set[w] then
        tabs[#tabs + 1] = t.tabnr
        break
      end
    end
  end
  if #tabs == 0 then
    return ''
  end
  return '[' .. table.concat(tabs, ',') .. '] '
end

return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      sort_by = 'tabs',
      name_formatter = function(buf)
        return find_tab_by_bufnr(buf.bufnr) .. buf.bufnr .. ' ' .. buf.name
      end,
    },
  },
}
