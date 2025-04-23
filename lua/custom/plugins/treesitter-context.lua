return {
  'nvim-treesitter/nvim-treesitter-context',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  opts = {
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  },
  keys = {
    {
      '<leader>ut',
      function()
        require('treesitter-context').toggle()
      end,
      desc = 'Toggle Treesitter Context',
    },
  },
  -- keys = {
  --   {
  --     '<leader>ut',
  --     function()
  --       local tsc = require 'treesitter-context'
  --       tsc.toggle()
  --       if LazyVim.inject.get_upvalue(tsc.toggle, 'enabled') then
  --         LazyVim.info('Enabled Treesitter Context', { title = 'Option' })
  --       else
  --         LazyVim.info('Enabled Treesitter Context', { title = 'Option' })
  --       end
  --     end,
  --     desc = 'Toggle Treesitter Context',
  --   },
  -- },
}
