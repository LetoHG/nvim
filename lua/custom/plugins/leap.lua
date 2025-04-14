return {
  {
    'ggandor/leap.nvim',
    config = function()
      local leap = require 'leap'
      leap.add_default_mappings(true)
      leap.opts.case_sensitive = true
    end,
    lazy = false,
  },
}
