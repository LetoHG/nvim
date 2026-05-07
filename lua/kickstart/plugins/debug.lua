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

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    -- Alternative für Stop (falls C-S-F5 vom Terminal abgefangen wird)
    {
      '<leader>dq',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Quit',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    {
      '<leader>dl',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See [l]ast session result.',
    },

    -- Start / Continue (F5)
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<leader>ds',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    -- Restart (Shift + F5)
    {
      '<S-F5>',
      function()
        require('dap').terminate()
        require('dap').continue()
      end,
      desc = 'Debug: Restart Session',
    },
    -- Terminate/Stop (Ctrl + Shift + F5)
    {
      '<C-S-F5>',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Terminate Session',
    },

    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve',
        'codelldb',
      },
    }

    require('dap-go').setup {
      -- Hier den Pfad aus 'which dlv' eintragen
      delve = {
        path = vim.fn.expand '~/go/bin/dlv',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '',
          play = '',
          step_into = '󰆹',
          step_over = '',
          step_out = '󰆸',
          step_back = '',
          run_last = '',
          terminate = '',
          disconnect = '',
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Pick CMake target to debug

    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'
    local conf = require('telescope.config').values

    local function select_cmake_target(callback)
      local build_dir = vim.fn.getcwd() .. '/build'
      local executables = vim.fn.glob(build_dir .. '/**/*', false, true)

      local targets = {}
      for _, file in ipairs(executables) do
        if vim.fn.executable(file) == 1 and not file:match 'CMake' then
          table.insert(targets, file)
        end
      end

      pickers
        .new({}, {
          prompt_title = 'CMake Targets',
          finder = finders.new_table { results = targets },
          sorter = conf.generic_sorter {},
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              callback(selection[1])
            end)
            return true
          end,
        })
        :find()
    end

    dap.configurations.cpp = {
      {
        name = 'Launch CMake Target',
        type = 'codelldb',
        request = 'launch',
        program = function()
          local co = coroutine.running()
          select_cmake_target(function(target)
            coroutine.resume(co, target)
          end)
          return coroutine.yield()
        end,
        args = function()
          local input = vim.fn.input 'Arguments: '
          return vim.split(input, ' ') -- Splits by spaces into a table
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
      -- }
      -- dap.configurations.cpp = {
      {
        name = 'Launch with args',
        type = 'codelldb', -- Change this based on your debugger (e.g., gdb, codelldb)
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        args = function()
          local input = vim.fn.input 'Arguments: '
          return vim.split(input, ' ') -- Splits by spaces into a table
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        runInTerminal = false,
      },
    }

    dap.configurations.c = dap.configurations.cpp
  end,
}
