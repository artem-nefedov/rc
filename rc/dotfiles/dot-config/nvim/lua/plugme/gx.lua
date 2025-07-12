return {
  "artem-nefedov/gx.nvim",
  branch = 'terraform-ft',
  keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
  cmd = { "Browse" },
  init = function ()
    vim.g.netrw_nogx = 1 -- disable netrw gx
  end,
  submodules = false, -- not needed, submodules are required only for tests
  config = function()
    require("gx").setup({
      handlers = {
        terraform = true,
        jira = {
          name = "jira",
          handle = function(mode, line, _)
            local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
            if ticket and #ticket < 15 then
              return "https://jira.aligntech.com/browse/" .. ticket
            end
          end,
        },
      }
    })
  end
}
