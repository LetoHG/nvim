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
      'nvim-telescope/telescope.nvim',
      'Joakker/lua-json5',
    },
    config = function()
      require('vstask').setup {
        cache_json_conf = true, -- don't read the json conf every time a task is ran
        cache_strategy = 'last', -- can be "most" or "last" (most used / last used)
        config_dir = '.vscode', -- directory to look for tasks.json and launch.json
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
    end,
  },
}
