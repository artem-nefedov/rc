-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    require('mason-nvim-dap').setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,
      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},
      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    })

    local nmap = function(keys, callback, desc)
      vim.keymap.set('n', keys, callback, { desc = '[D]EBUG: ' .. desc })
    end

    local nmap_repeat = function(keys, callback, desc)
      vim.keymap.set('n', keys, function()
        callback()
        vim.fn['repeat#set'](keys, 1)
      end, { desc = 'DEBUG: ' .. desc })
    end

    -- Basic debugging keymaps, feel free to change to your liking!
    nmap_repeat(',si', dap.step_into, '[S]tep [I]nto')
    nmap_repeat(',ss', dap.step_over, '[S]tep over')
    nmap_repeat(',so', dap.step_out, '[S]tep [O]ut')

    nmap(',du', dapui.toggle, 'Toggle [U]I')
    nmap(',dc', dap.continue, '[C]ontinue')
    nmap(',db', dap.toggle_breakpoint, 'Toggle [B]reakpoint')
    nmap(',dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, 'Set [B]reakpoint condition')

    dapui.setup({})

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup()
  end,
}
