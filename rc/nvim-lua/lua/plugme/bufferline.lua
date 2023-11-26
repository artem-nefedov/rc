local function find_tab_by_bufnr(bufnr)
  local winnr = vim.fn.win_findbuf(bufnr)[1]
  for _, t in ipairs(vim.fn.gettabinfo()) do
    for _, w in ipairs(t.windows) do
      if w == winnr then
        return '[' .. t.tabnr .. '] '
      end
    end
  end
  return ''
end

return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      sort_by = 'tabs',
      name_formatter = function(buf)
        return find_tab_by_bufnr(buf.bufnr) .. buf.name
      end,
    },
  },
}
