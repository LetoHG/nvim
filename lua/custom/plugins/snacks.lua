return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      -- bigfile = { enabled = true },
      dashboard = { enabled = true },
      dim = {
        enabled = true,
        scope = {
          min_size = 5,
          max_size = 20,
          siblings = true,
        },
      },
      -- Disabled until snacks.nvim fixes nvim 0.12.1 treesitter parse compat
      indent = { enabled = false },
      -- input = { enabled = true },
      -- notifier = { enabled = true },
      -- quickfile = { enabled = true },
      scroll = { enabled = true },
      -- statuscolumn = { enabled = true },
      -- toggle = { enabled = true },
      -- words = { enabled = true },
      -- HACK: read picker docs @ https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
      picker = {
        enabled = true,
        sources = {
          explorer = {
            layout = {
              layout = {
                position = 'right', -- <-- move it to the right
                -- width = 30, -- optional: adjust width
              },
              preset = 'sidebar',
            },
          },
        },
        matchers = {
          frecency = true,
          cwd_bonus = false,
        },
        formatters = {
          file = {
            filename_first = false,
            filename_only = false,
            icon_width = 2,
          },
        },
        layout = {
          -- presets options : "default" , "ivy" , "ivy-split" , "telescope" , "vscode", "select" , "sidebar"
          -- override picker layout in keymaps function as a param below
          preset = 'telescope', -- defaults to this layout unless overidden
          cycle = false,
        },
        layouts = {
          select = {
            preview = false,
            layout = {
              backdrop = false,
              width = 0.6,
              min_width = 80,
              height = 0.4,
              min_height = 10,
              box = 'vertical',
              border = 'rounded',
              title = '{title}',
              title_pos = 'center',
              { win = 'input', height = 1, border = 'bottom' },
              { win = 'list', border = 'none' },
              { win = 'preview', title = '{preview}', width = 0.6, height = 0.4, border = 'top' },
            },
          },
          telescope = {
            reverse = true, -- set to false for search bar to be on top
            layout = {
              box = 'horizontal',
              backdrop = false,
              width = 0.8,
              height = 0.9,
              border = 'none',
              {
                box = 'vertical',
                { win = 'list', title = ' Results ', title_pos = 'center', border = 'rounded' },
                { win = 'input', height = 1, border = 'rounded', title = '{title} {live} {flags}', title_pos = 'center' },
              },
              {
                win = 'preview',
                title = '{preview:Preview}',
                width = 0.50,
                border = 'rounded',
                title_pos = 'center',
              },
            },
          },
          ivy = {
            layout = {
              box = 'vertical',
              backdrop = false,
              width = 0,
              height = 0.4,
              position = 'bottom',
              border = 'top',
              title = ' {title} {live} {flags}',
              title_pos = 'left',
              { win = 'input', height = 1, border = 'bottom' },
              {
                box = 'horizontal',
                { win = 'list', border = 'none' },
                { win = 'preview', title = '{preview}', width = 0.5, border = 'left' },
              },
            },
          },
        },
      },
    },
    -- NOTE: Keymaps
    keys = {
      {
        '<leader>lg',
        function()
          require('snacks').lazygit()
        end,
        desc = 'Lazygit',
      },
      {
        '<leader>gl',
        function()
          require('snacks').lazygit.log()
        end,
        desc = 'Lazygit Logs',
      },
      {
        '<leader>es',
        function()
          require('snacks').explorer()
        end,
        desc = 'Open Snacks Explorer',
      },
      {
        '<leader>rN',
        function()
          require('snacks').rename.rename_file()
        end,
        desc = 'Fast Rename Current File',
      },
      {
        '<leader>dB',
        function()
          require('snacks').bufdelete()
        end,
        desc = 'Delete or Close Buffer  (Confirm)',
      },
      -- Snacks Picker
      {
        '<leader>sh',
        function()
          require('snacks').picker.help()
        end,
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sk',
        function()
          require('snacks').picker.keymaps { layout = 'ivy' }
        end,
        desc = '[S]earch [K]eymaps',
      },
      {
        '<leader>sf',
        function()
          require('snacks').picker.files()
        end,
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>ss',
        function()
          require('snacks').picker()
        end,
        desc = '[S]earch [S]elect Picker',
      },
      {
        '<leader>sw',
        function()
          require('snacks').picker.grep_word()
        end,
        desc = '[S]earch current [W]ord',
        mode = { 'n', 'x' },
      },
      {
        '<leader>sg',
        function()
          require('snacks').picker.grep { layout = 'ivy' }
        end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sd',
        function()
          require('snacks').picker.diagnostics()
        end,
        desc = '[S]earch [D]iagnostics',
      },
      {
        '<leader>sr',
        function()
          require('snacks').picker.resume()
        end,
        desc = '[S]earch [R]esume',
      },
      {
        '<leader>s.',
        function()
          require('snacks').picker.recent()
        end,
        desc = '[S]earch Recent Files ("." for repeat)',
      },
      {
        '<leader>s/',
        function()
          require('snacks').picker.grep_buffers { layout = 'ivy' }
        end,
        desc = '[S]earch [/] in Open Files',
      },
      {
        '<leader>sn',
        function()
          require('snacks').picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[S]earch [N]eovim files',
      },
      {
        '<leader><leader>',
        function()
          require('snacks').picker.buffers()
        end,
        desc = '[ ] Find existing buffers',
      },
      {
        '<leader>/',
        function()
          require('snacks').picker.lines()
        end,
        desc = '[/] Fuzzily search in current buffer',
      },
      -- Git Stuff
      {
        '<leader>gsb',
        function()
          require('snacks').picker.git_branches { layout = 'select' }
        end,
        desc = 'Pick and Switch Git Branches',
      },
      -- Other Utils
      {
        '<leader>pl',
        function()
          require('snacks').picker.colorschemes { layout = 'ivy' }
        end,
        desc = 'Pick Color Schemes',
      },
      {
        '<leader>i',
        function()
          local d = require('snacks').dim
          if d.enabled then
            d.disable()
          else
            d.enable()
          end
        end,
        desc = 'Toggle dimming',
      },
    },
  },
  -- NOTE: todo comments w/ snacks
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      highlight = {
        pattern = {
          [[.*<(KEYWORDS)\s*:]],
          [[.*<(KEYWORDS)\([^)]*\)\s*:]],
        },
      },
      search = {
        pattern = [[\b(KEYWORDS)(\([^)]+\))?:]],
      },
    },
    keys = {
      {
        '<leader>pt',
        function()
          require('snacks').picker.todo_comments()
        end,
        desc = 'Todo',
      },
      {
        '<leader>pT',
        function()
          require('snacks').picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
        end,
        desc = 'Todo/Fix/Fixme',
      },
    },
  },
}
