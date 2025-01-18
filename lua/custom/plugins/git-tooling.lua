-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

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
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        gitsigns.setup {
          signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
          },
        }

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>ghs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git: [H]unk [S]tage' })
        map('v', '<leader>ghr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git: [H]unk [R]eset' })
        -- normal mode
        map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'Git: [s]tage hunk' })
        map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'Git: [r]eset hunk' })
        map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = 'Git: [S]tage buffer' })
        map('n', '<leader>ghu', gitsigns.undo_stage_hunk, { desc = 'Git: [u]ndo stage hunk' })
        map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = 'Git: [R]eset buffer' })
        map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = 'Git: [p]review hunk' })
        map('n', '<leader>ghb', gitsigns.blame_line, { desc = 'Git: [b]lame line' })
        map('n', '<leader>ghd', gitsigns.diffthis, { desc = 'Git: [d]iff against index' })
        map('n', '<leader>ghD', function()
          gitsigns.diffthis '@'
        end, { desc = 'Git: [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = 'Git: [T]oggle git show [b]lame line' })
        map('n', '<leader>gtD', gitsigns.toggle_deleted, { desc = 'Git: [T]oggle git show [D]eleted' })
      end,
    },
  },
}
