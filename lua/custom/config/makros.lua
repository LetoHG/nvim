-- Work in progress todo comment insert

local esc = vim.api.nvim_replace_termcodes('<ESC>', true, true, true)
local cr = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
-- vim.fn.setreg('t', 'iTODO(lhe5wi): [' .. esc .. ":put =strftime('%Y-%m-%d')" .. cr .. 'i] ' .. esc .. 'gccA')
vim.fn.setreg('t', 'iTODO(lhe5wi): []' .. esc .. ':InsertDate' .. cr .. esc .. 'gccA ')

local function insert_date()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line = vim.api.nvim_get_current_line()
  local date_str = os.date '%Y-%m-%d'
  local new_line = current_line:sub(1, col) .. date_str .. current_line:sub(col + 1)
  vim.api.nvim_set_current_line(new_line)
end

vim.api.nvim_create_user_command('InsertDate', insert_date, {})
vim.keymap.set('n', '<leader>dd', insert_date, { desc = 'Insert todays date', noremap = true, silent = true }) -- Fix keymap

local function insert_note(category)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line = vim.api.nvim_get_current_line()
  local date_str = os.date '%Y-%m-%d'
  local new_line = current_line:sub(1, col) .. ' // ' .. category .. '(lhe5wi): [' .. date_str .. '] ' .. current_line:sub(col + 1)
  vim.api.nvim_set_current_line(new_line)
end

vim.keymap.set('n', '<leader>nf', function()
  insert_note 'TODO'
end, { desc = 'Insert todo comment', noremap = true, silent = true }) -- Fix keymap
vim.keymap.set('n', '<leader>nt', function()
  insert_note 'FIXME'
end, { desc = 'Insert fixme comment', noremap = true, silent = true }) -- Fix keymap
