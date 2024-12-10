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

      vim.keymap.set('n', '<leader>ghs', gs.stage_hunk, { silent = true, desc = '[G]itsigns: [h]unk [s]tage' })
      vim.keymap.set('n', '<leader>ghr', gs.reset_hunk, { silent = true, desc = '[G]itsigns: [h]unk [r]eset' })
      vim.keymap.set('v', '<leader>ghs', function()
        gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { silent = true, desc = '[G]itsigns: [h]unk [s]tage' })
      vim.keymap.set('v', '<leader>ghr', function()
        gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { silent = true, desc = '[G]itsigns: [h]unk [r]eset' })
      vim.keymap.set('n', '<leader>gbs', gs.stage_buffer, { silent = true, desc = '[G]itsigns: [b]uffer [s]tage' })
      vim.keymap.set('n', '<leader>ghu', gs.undo_stage_hunk, { silent = true, desc = '[G]itsigns: [h]unk [u]ndo stage' })
      vim.keymap.set('n', '<leader>gbr', gs.reset_buffer, { silent = true, desc = '[G]itsigns: [b]uffer [r]eset' })
      vim.keymap.set('n', '<leader>ghp', gs.preview_hunk, { silent = true, desc = '[G]itsigns: [h]unk [p]review' })
      vim.keymap.set('n', '<leader>ghb', function()
        gs.blame_line { full = true }
      end, { silent = true, desc = '[G]itsigns: [h]unk [b]lame' })
      vim.keymap.set('n', '<leader>gtb', gs.toggle_current_line_blame, { silent = true, desc = '[G]itsigns: [t]oggle [b]lame' })
      vim.keymap.set('n', '<leader>ghd', gs.diffthis, { silent = true, desc = '[G]itsigns: [h]unk [d]iff' })
      vim.keymap.set('n', '<leader>ghD', function()
        gs.diffthis '~'
      end, { silent = true, desc = '[G]itsigns: [h]unk [D]iff' })
      vim.keymap.set('n', '<leader>gtd', gs.toggle_deleted, { silent = true, desc = '[G]itsigns: [t]oggle [d]eleted' })
    end,
  },
}
