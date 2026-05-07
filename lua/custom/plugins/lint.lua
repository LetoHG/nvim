return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      local cpp_linters = {}
      local cpp_filetypes = { c = true, cpp = true }

      if vim.fn.executable 'clang-tidy' == 1 then
        cpp_linters = { 'clangtidy' }
      end

      lint.linters_by_ft = lint.linters_by_ft or {}
      lint.linters_by_ft.c = cpp_linters
      lint.linters_by_ft.cpp = cpp_linters

      vim.api.nvim_create_user_command('Lint', function()
        lint.try_lint()
      end, { desc = 'Run configured linters for the current buffer' })

      local lint_augroup = vim.api.nvim_create_augroup('custom-lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if cpp_filetypes[vim.bo.filetype] and vim.bo.buftype == '' and vim.bo.modifiable and #cpp_linters > 0 then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
