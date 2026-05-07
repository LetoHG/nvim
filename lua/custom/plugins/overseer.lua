return {
  {
    'stevearc/overseer.nvim',
    cmd = {
      'OverseerOpen',
      'OverseerClose',
      'OverseerToggle',
      'OverseerRun',
      'OverseerTaskAction',
      'OverseerShell',
    },
    keys = {
      {
        '<leader>oo',
        function()
          require('overseer').open { direction = 'right' }
        end,
        desc = 'Open task list',
      },
      {
        '<leader>ot',
        function()
          require('overseer').toggle()
        end,
        desc = 'Toggle task list',
      },
      {
        '<leader>or',
        '<cmd>OverseerRun<cr>',
        desc = 'Run task',
      },
      {
        '<leader>oq',
        function()
          local overseer = require 'overseer'
          local tasks = overseer.list_tasks {
            include_ephemeral = false,
            sort = function(a, b)
              return a.id > b.id
            end,
          }

          if tasks[1] then
            overseer.run_action(tasks[1])
          else
            vim.notify('No Overseer tasks available', vim.log.levels.INFO)
          end
        end,
        desc = 'Last task action',
      },
      {
        '<leader>oa',
        '<cmd>OverseerTaskAction<cr>',
        desc = 'Task actions',
      },
    },
    opts = {
      strategy = 'terminal',
      task_list = {
        direction = 'right',
        min_width = 40,
        max_width = { 60, 0.4 },
        default_detail = 1,
        bindings = {
          ['q'] = 'Close',
          ['<CR>'] = 'RunAction',
          ['?'] = 'ShowHelp',
          ['g?'] = 'ShowHelp',
        },
      },
    },
    config = function(_, opts)
      require('overseer').setup(opts)
    end,
  },
}
