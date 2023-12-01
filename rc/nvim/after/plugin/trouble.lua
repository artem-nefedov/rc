local keymaps = require('helpme.keymaps')
local nmap = keymaps.nmap
local toggle = require('trouble').toggle

nmap("<M-t>", toggle, { desc = "Trouble [T]oggle" })
nmap("<M-w>", function() toggle("workspace_diagnostics") end, { desc = "Trouble [W]orkspace" })
nmap("<M-d>", function() toggle("document_diagnostics") end, { desc = "Trouble [D]ocument" })
