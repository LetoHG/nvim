local copilot = require 'custom.config.copilot'
local copilot_enabled = copilot.notify_if_unsupported()

return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    enabled = copilot_enabled,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    event = 'VimEnter',
    enabled = copilot_enabled,
    dependencies = {
      'github/copilot.vim',
      {
        'nvim-lua/plenary.nvim',
        branch = 'master',
      },
    },
    build = 'make tiktoken',
    cmd = {
      'CopilotChat',
      'CopilotChatOpen',
      'CopilotChatClose',
      'CopilotChatToggle',
      'CopilotChatStop',
      'CopilotChatReset',
      'CopilotChatSave',
      'CopilotChatLoad',
      'CopilotChatPrompts',
      'CopilotChatModels',
      'CopilotChatExplain',
      'CopilotChatReview',
      'CopilotChatFix',
      'CopilotChatOptimize',
      'CopilotChatDocs',
      'CopilotChatTests',
      'CopilotChatCommit',
    },
    opts = {
      -- See Configuration section for options
    },
    -- :CopilotChat <input>?	Open chat with optional input
    -- :CopilotChatOpen	Open chat window
    -- :CopilotChatClose	Close chat window
    -- :CopilotChatToggle	Toggle chat window
    -- :CopilotChatStop	Stop current output
    -- :CopilotChatReset	Reset chat window
    -- :CopilotChatSave <name>?	Save chat history
    -- :CopilotChatLoad <name>?	Load chat history
    -- :CopilotChatPrompts	View/select prompt templates
    -- :CopilotChatModels	View/select available models
    -- :CopilotChat<PromptName>
    keys = {
      { '<leader>ze', '<cmd>CopilotChatExplain<cr>', mode = 'v', desc = 'Copilot: Explain Code' },
      { '<leader>zr', '<cmd>CopilotChatReview<cr>', mode = 'v', desc = 'Copilot: Review Code' },
      { '<leader>zf', '<cmd>CopilotChatFix<cr>', mode = 'v', desc = 'Copilot: Fix Code Issues' },
      { '<leader>zo', '<cmd>CopilotChatOptimize<cr>', mode = 'v', desc = 'Copilot: Optimize Code' },
      { '<leader>zd', '<cmd>CopilotChatDocs<cr>', mode = 'v', desc = 'Copilot: Generate Docs' },
      { '<leader>zt', '<cmd>CopilotChatTests<cr>', mode = 'v', desc = 'Copilot: Generate Tests' },
      { '<leader>zm', '<cmd>CopilotChatCommit<cr>', mode = 'n', desc = 'Copilot: Generate Commit Message' },
      { '<leader>zs', '<cmd>CopilotChatCommit<cr>', mode = 'v', desc = 'Copilot: Gerenate Commit from Selection' },

      { '<leader>zcc', '<cmd>CopilotChat<cr>', mode = 'n', desc = 'Copilot: Open Chat' },
      { '<leader>zct', '<cmd>CopilotChatToggle<cr>', mode = 'n', desc = 'Copilot: Toggle Chat' },
      { '<leader>zcs', '<cmd>CopilotChatStop<cr>', mode = 'n', desc = 'Copilot: Stop Output' },
      { '<leader>zcr', '<cmd>CopilotChatReset<cr>', mode = 'n', desc = 'Copilot: Reset Chat' },
      { '<leader>zcS', '<cmd>CopilotChatSave<cr>', mode = 'n', desc = 'Copilot: Save Chat' },
      { '<leader>zcL', '<cmd>CopilotChatLoad<cr>', mode = 'n', desc = 'Copilot: Load Chat' },
      { '<leader>zcp', '<cmd>CopilotChatPrompts<cr>', mode = 'n', desc = 'Copilot: Prompts' },
      { '<leader>zcm', '<cmd>CopilotChatModels<cr>', mode = 'n', desc = 'Copilot: Models' },
    },
  },
}
