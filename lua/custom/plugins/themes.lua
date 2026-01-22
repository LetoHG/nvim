return {
  { 'rebelot/kanagawa.nvim' },
  { 'realbucksavage/riderdark.vim' },
  { 'rose-pine/neovim' },
  { 'marko-cerovac/material.nvim' },
  { 'Mofiqul/vscode.nvim' },
  { 'folke/tokyonight.nvim' },
  {
    'catppuccin/nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      require('catppuccin').setup {
        transparent_background = true,
        custom_highlights = function(colors)
          return {
            LineNr = { fg = colors.peach, bg = 'NONE' }, -- example with peach color
          }
        end,
      }
      -- init = function()
      -- Load the colorscheme here.
      vim.cmd.colorscheme 'catppuccin'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
