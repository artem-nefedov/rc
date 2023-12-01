--[[configure oil]]

local oil = require("oil")

vim.keymap.set("n", "-", function()
  if vim.bo.buftype == 'terminal' then
    oil.open(vim.fn.getcwd())
  else
    oil.open()
  end
  vim.cmd.lcd(oil.get_current_dir())
end, { desc = "Open parent directory" })
