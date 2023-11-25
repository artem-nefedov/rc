return {
  'potamides/pantran.nvim',

  -- keys = {
  --   {
  --     "<leader>tr",
  --     function()
  --         require("pantran").motion_translate()
  --     end,
  --     mode = {"n", "v"},
  --     desc = "[Tr]anslate",
  --   },
  --   {
  --     "<leader>trr",
  --     function()
  --         require("pantran").motion_translate()
  --     end,
  --     mode = {"n"},
  --     desc = "[Tr]anslate",
  --   },
  -- },
  --
  opts = {
    default_engine = 'deepl',
  },
  --
  -- config = function (_, opts)
  --   require('pantran').setup(opts)
  -- end,
}
