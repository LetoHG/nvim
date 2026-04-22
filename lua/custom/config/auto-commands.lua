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

local function load_custom_agents()
  local chat = require 'CopilotChat'
  local config = require 'CopilotChat.config'

  -- Pfade definieren
  local global_dir = vim.fn.expand '~/.copilot/agents'
  local local_dir = vim.fn.getcwd() .. '/.github/agents'

  local search_paths = { global_dir, local_dir }

  for _, dir in ipairs(search_paths) do
    if vim.fn.isdirectory(dir) == 1 then
      local files = vim.fn.globpath(dir, '*.md', false, true)

      for _, file_path in ipairs(files) do
        local f = io.open(file_path, 'r')
        if f then
          local content = f:read '*all'
          f:close()

          -- Extrahiere NUR die Zeile, die mit 'name:' beginnt
          -- %s* ignoriert Leerzeichen, [^\r\n]+ liest alles bis zum Zeilenumbruch
          local name_line = content:match 'name:%s*([^\r\n]+)'
          local raw_name = ''

          if name_line then
            -- Falls der Name in Anführungszeichen steht, extrahiere den Inhalt
            raw_name = name_line:match '"([^"]+)"' or name_line:match "'([^']+)'" or name_line
          else
            -- Fallback auf Dateiname ohne Endung
            raw_name = vim.fn.fnamemodify(file_path, ':t:r')
          end

          -- Leerzeichen durch '-' ersetzen und führende/anhängende Leerzeichen entfernen
          local agent_name = raw_name:gsub('^%s*(.-)%s*$', '%1'):gsub('%s+', '-')

          -- 3. In CopilotChat registrieren
          config.prompts[agent_name] = {
            prompt = 'Please follow your instructions for this input:',
            system_prompt = content,
            description = 'Agent: ' .. raw_name .. ' (' .. (dir == global_dir and 'Global' or 'Project') .. ')',
          }
        end
      end
    end
  end
end

-- Lädt Agents beim Start oder bei Verzeichniswechsel
vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
  callback = function()
    vim.defer_fn(load_custom_agents, 250)
  end,
})
