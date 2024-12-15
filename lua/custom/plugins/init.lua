-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      'nvim-telescope/telescope.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
      'echasnovski/mini.pick', -- optional
    },
    config = true,
  },
  --[[
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      local gs = require 'gitsigns'

      gs.setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      }

      -- In this case, we create a function that lets us more easily define mappings specific
      -- for Git related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { silent = true, desc = 'Git: ' .. desc })
      end

      map('<leader>ghs', gs.stage_hunk, '[H]unk [S]tage')
      map('<leader>ghr', gs.reset_hunk, '[H]unk [R]eset')
      map('<leader>ghs', function()
        gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, '[H]unk [S]tage', 'v')
      map('<leader>ghr', function()
        gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, '[H]unk [R]eset', 'v')
      map('<leader>gbs', gs.stage_buffer, '[B]uffer [S]tage')
      map('<leader>ghu', gs.undo_stage_hunk, '[H]unk [U]ndo stage')
      map('<leader>gbr', gs.reset_buffer, '[B]uffer [R]eset')
      map('<leader>ghp', gs.preview_hunk, '[H]unk [P]review')
      map('<leader>ghb', function()
        gs.blame_line { full = true }
      end, '[H]unk [B]lame')
      map('<leader>gtb', gs.toggle_current_line_blame, '[T]oggle [B]lame')
      map('<leader>ghd', gs.diffthis, '[H]unk [D]iff')
      map('<leader>ghD', function()
        gs.diffthis '~'
      end, '[H]unk [D]iff')
      map('<leader>gtd', gs.toggle_deleted, '[T]oggle [D]eleted')
    end,
  },
  ]]
  --[[
  {
    'EmilOhlsson/FloatTerm.nvim',
    config = function()
      local ft = require 'FloatTerm'

      ft.setup {
        window_config = {
          border = 'shadow',
          title = 'FloatTerm',
          title_pos = 'left',
        },
        pad_vertical = 5,
        pad_horizontal = 10,
      }

      vim.keymap.set('n', '<leader>tt', ft.toggle_window, { silent = true, desc = '[T]oggle [T]erminal' })
    end,
  },

  ]]

  --[[
  -- todo: configure toggling when in terminal mode 
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    },
    config = function()
      local tt = require 'toggleterm'
      local toggle_terminal = function()
        tt.toggle(1, 40, '.', 'horizontal', 'terminal')
      end

      vim.keymap.set('n', '<leader>tt', toggle_terminal, { desc = '[T]oggle [T]erminal' })
    end,
  },
]]
}
