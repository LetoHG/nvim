return {
  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = {
      { '<leader>o', '<CMD>Outline<CR>', desc = 'Toggle Outline' },
    },
    config = function()
      require('outline').setup {
        -- make sure you pass at least a default table
      }
    end,
  },
}
