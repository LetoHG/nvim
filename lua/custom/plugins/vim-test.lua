return {
  'vim-test/vim-test',
  dependencies = {
    'preservim/vimux',
  },

  vim.keymap.set('n', '<leader>tn', ':TestNearest<CR>', { desc = '[T]est [n]earest' }),
  vim.keymap.set('n', '<leader>tf', ':TestFile<CR>', { desc = '[T]est [f]ile' }),
  vim.keymap.set('n', '<leader>ts', ':TestSuite<CR>', { desc = '[T]est [s]uite' }),
  vim.keymap.set('n', '<leader>tl', ':TestLast<CR>', { desc = '[T]est [l]ast' }),
  vim.keymap.set('n', '<leader>tv', ':TestVisit<CR>', { desc = '[T]est [v]isit' }),
}
