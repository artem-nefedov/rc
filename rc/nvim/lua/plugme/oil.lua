local open_term = function()
  vim.cmd.lcd(require("oil").get_current_dir())
  vim.cmd.term()
end

local always_hidden = function(name, _)
  return name == ".."
end

return {
  'stevearc/oil.nvim',
  opts = {
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = "actions.select_vsplit",
      ["<C-h>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<M-l>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["ge"] = open_term,
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
    },
    use_default_keymaps = false,
    view_options = {
      show_hidden = true,
      is_always_hidden = always_hidden,
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
