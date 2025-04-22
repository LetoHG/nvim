return {
  -- Comments
  {
    'echasnovski/mini.comment',
    version = false,
    -- config = function()
    --   require('mini.comment').setup {
    --     -- tsx, jsx, html , svelte comment support
    --     options = {
    --       custom_commentstring = function()
    --         return vim.bo.commentstring
    --       end,
    --     },
    --   }
    -- end,
  },
  -- File explorer (this works properly with oil unlike nvim-tree)
  {
    'echasnovski/mini.files',
    config = function()
      local MiniFiles = require 'mini.files'
      MiniFiles.setup {
        mappings = {
          go_in = '<CR>', -- Map both Enter and L to enter directories or open files
          go_in_plus = 'L',
          go_out = '-',
          go_out_plus = 'H',
        },
      }
      vim.keymap.set('n', '<leader>ee', '<cmd>lua MiniFiles.open()<CR>', { desc = 'Toggle mini file explorer' }) -- toggle file explorer
      vim.keymap.set('n', '<leader>ef', function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        MiniFiles.reveal_cwd()
      end, { desc = 'Toggle into currently opened file' })
    end,
  },
  {
    'echasnovski/mini.trailspace',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      local miniTrailspace = require 'mini.trailspace'

      miniTrailspace.setup {
        only_in_normal_buffers = true,
      }
      vim.keymap.set('n', '<leader>cw', function()
        miniTrailspace.trim()
      end, { desc = 'Erase Whitespace' })

      -- Ensure highlight never reappears by removing it on CursorMoved
      vim.api.nvim_create_autocmd('CursorMoved', {
        pattern = '*',
        callback = function()
          require('mini.trailspace').unhighlight()
        end,
      })
    end,
  },
  -- Split & join
  {
    'echasnovski/mini.splitjoin',
    config = function()
      local miniSplitJoin = require 'mini.splitjoin'
      miniSplitJoin.setup {
        mappings = { toggle = '' }, -- Disable default mapping
      }
      vim.keymap.set({ 'n', 'x' }, 'sj', function()
        miniSplitJoin.join()
      end, { desc = 'Join arguments' })
      vim.keymap.set({ 'n', 'x' }, 'sk', function()
        miniSplitJoin.split()
      end, { desc = 'Split arguments' })
    end,
  },
}
