return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  opts = {
    mappings = {
      pull_request = {
        open_in_browser = { lhs = "gX", desc = "open discussion in browser" },
      }
    },
    -- or "fzf-lua" or "snacks" or "default"
    picker = "telescope",
    -- bare Octo command opens picker of commands
    enable_builtin = true,
    search = {
      completion_overrides = {
        repo = { "align-platform/" },
        org = { "align-platform" },
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    -- OR "ibhagwan/fzf-lua",
    -- OR "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
  },
}
