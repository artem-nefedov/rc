return {
  'stevearc/oil.nvim',
  opts = {
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = function()
        require("oil.actions").select.callback()
        vim.defer_fn(function()
          local curdir = require("oil").get_current_dir()
          if curdir then
            vim.cmd.lcd(curdir)
          end
        end, 200)
      end,
      ["<C-s>"] = "actions.select_vsplit",
      ["<C-h>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<M-l>"] = "actions.refresh",
      ["-"] = function()
        require("oil.actions").parent.callback()
        vim.cmd.lcd(require("oil").get_current_dir())
      end,
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["ge"] = "actions.open_terminal",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },
    use_default_keymaps = false,
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
