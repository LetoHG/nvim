return {
  { 'rebelot/kanagawa.nvim' },
  { 'realbucksavage/riderdark.vim' },
  { 'rose-pine/neovim' },
  { 'marko-cerovac/material.nvim' },
  { 'Mofiqul/vscode.nvim' },
  { 'folke/tokyonight.nvim' },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      require('catppuccin').setup {
        integrations = {
          lualine = false,
        },
        transparent_background = true,
        custom_highlights = function(colors)
          return {
            LineNr = { fg = colors.peach, bg = 'NONE' }, -- example with peach color
            GitSignsCurrentLineBlame = { fg = colors.blue, bg = 'NONE' },
          }
        end,
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { 'italic' }, -- Change the style of comments
          conditionals = { 'italic' },
        },
      }
      -- init = function()
      -- Load the colorscheme here.
      vim.cmd.colorscheme 'catppuccin'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
