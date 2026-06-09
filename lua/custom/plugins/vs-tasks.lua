return {
  {
    'Joakker/lua-json5',
    run = './install.sh',
  },
  {
    'EthanJWright/vs-tasks.nvim',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'folke/snacks.nvim',
      'Joakker/lua-json5',
    },
    config = function()
      local vstask = require 'vstask'

      vstask.setup {
        cache_json_conf = true, -- don't read the json conf every time a task is ran
        cache_strategy = 'last', -- can be "most" or "last" (most used / last used)
        config_dir = '.vscode', -- directory to look for tasks.json and launch.json
        picker = 'snacks',
        telescope_keys = { -- change the telescope bindings used to launch tasks
          vertical = '<C-v>',
          split = '<C-p>',
          tab = '<C-t>',
          current = '<CR>',
          background = '<C-b>',
          watch_job = '<C-w>',
          kill_job = '<C-d>',
          run = '<C-r>',
        },
        autodetect = { -- auto load scripts
          npm = 'on',
        },
        terminal = 'nvim', -- can be 'nvim' or 'toggleterm'
        term_opts = {
          vertical = {
            direction = 'vertical',
            size = '80',
          },
          horizontal = {
            direction = 'horizontal',
            size = '10',
          },
          current = {
            direction = 'float',
          },
          tab = {
            direction = 'tab',
          },
        },
        json_parser = require('json5').parse,
      }

      vim.keymap.set('n', '<leader>vt', function()
        vstask.tasks()
      end, { desc = '[V]S [T]asks' })

      vim.keymap.set('n', '<leader>vj', function()
        vstask.jobs()
      end, { desc = '[V]S [J]obs' })

      vim.keymap.set('n', '<leader>vl', function()
        vstask.launches()
      end, { desc = '[V]S [L]aunches' })

      vim.keymap.set('n', '<leader>vi', function()
        vstask.inputs()
      end, { desc = '[V]S [I]nputs' })

      vim.keymap.set('n', '<leader>vr', function()
        vstask.command()
      end, { desc = '[V]S [R]un command' })

      vim.keymap.set('n', '<leader>vc', function()
        vstask.cleanup_completed_jobs()
      end, { desc = '[V]S [C]leanup jobs' })

      vim.keymap.set('n', '<leader>vd', function()
        vstask.clear_inputs()
      end, { desc = '[V]S Clear input cache' })
    end,
  },
}
