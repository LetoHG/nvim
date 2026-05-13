return {
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>xt', '<cmd>Trouble todo toggle<cr>', desc = 'Todos (Trouble)' },
      {
        '<leader>xT',
        function()
          local user = vim.env.USER
          if not user or user == '' then
            vim.notify('USER is not set', vim.log.levels.ERROR)
            return
          end

          local pattern = '^TODO%(' .. vim.pesc(user) .. '%):'
          require('todo-comments.search').search(function(results)
            local items = vim.tbl_filter(function(item)
              return item.tag == 'TODO' and item.text:match(pattern) ~= nil
            end, results)

            vim.fn.setqflist({}, ' ', { title = 'My Todos', id = '$', items = items })
            vim.cmd 'Trouble qflist toggle focus=false'

            if #items == 0 then
              vim.notify('No TODO(' .. user .. '): comments found', vim.log.levels.INFO)
            end
          end, {
            keywords = 'TODO',
            disable_not_found_warnings = true,
          })
        end,
        desc = 'My Todos (Trouble)',
      },
      { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    },
  },
}
