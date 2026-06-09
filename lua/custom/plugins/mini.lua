return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      -- local statusline = require 'mini.statusline'
      -- -- set use_icons to true if you have a Nerd Font
      -- statusline.setup {
      --   -- Whether to use icons by default
      --   use_icons = vim.g.have_nerd_font,
      --
      --   -- Whether to set Vim's settings for statusline (make it always shown)
      --   set_vim_settings = true,
      -- }
      --
      -- -- You can configure sections in the statusline by overriding their
      -- -- default behavior. For example, here we set the section for
      -- -- cursor location to LINE:COLUMN
      -- ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      --   return '%2l:%-2v'
      -- end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim

      -- Easy navigation with [ and ] prefix (e.g ]b)
      require('mini.bracketed').setup()
    end,
  },

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
