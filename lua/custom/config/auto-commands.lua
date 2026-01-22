-- [[ Basic Autocommands ]]
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Use // to comment in c/cpp files instead of the default /* */
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp' },
  callback = function()
    vim.bo.commentstring = '// %s'
  end,
})

-- TODO: does not work yet!
-- Have cmake binding only in cmake projects, extend for cargo and other build systems
-- vim.api.nvim_create_autocmd('LspAttach', {
--   -- group = 'LspAttach',
--   callback = function(ev)
--     local bufnr = ev.buf
--     local client = vim.lsp.get_client_by_id(ev.data.client_id)
--
--     if client.name == 'clangd' then
--       vim.keymap.set('n', '<leader>cb', ':CMakeBuild<CR>', { silent = true, buffer = bufnr })
--       vim.keymap.set('n', '<leader>ct', ':CMakeSelectBuildTarget<CR>', { silent = true, buffer = bufnr })
--       vim.keymap.set('n', '<leader>cc', ':CMakeGenerate<CR>', { silent = true, buffer = bufnr })
--     end
--   end,
-- })

-- Function to emit a notification when recording starts
-- local function on_macro_recording()
--   local register = vim.fn.reg_recording()
--   vim.notify('Macro recording started on register: ' .. register, vim.log.levels.INFO)
-- end
--
-- -- Set up autocommands to detect when recording starts and ends
-- vim.api.nvim_create_autocmd('RecordingEnter', {
--   callback = on_macro_recording, -- Show notification when recording starts
-- })
--
-- vim.api.nvim_create_autocmd('RecordingLeave', {
--   callback = function()
--     vim.notify('Macro recording stopped!', vim.log.levels.INFO)
--   end,
-- })
