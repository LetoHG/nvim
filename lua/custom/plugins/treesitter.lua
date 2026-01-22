return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'rust',
        'query',
        'vim',
        'vimdoc',
        'zig',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      fold = { enable = true },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    config = function()
      -- A custom fold expression function
      -- It keeps include statements unfolded while using treesitter for everything else.
      function _G.custom_fold_expr()
        -- Get the content of the line being evaluated by 'foldexpr'
        local line = vim.fn.getline(vim.v.lnum)

        -- Check if the line starts with #include, #define, etc., after any whitespace.
        -- You can add more directives like #if, #ifdef, etc., if you want.
        if line:match '^%s*#%s*include' or line:match '^%s*#%s*define' then
          -- Return fold level 0 to prevent this line from being folded.
          return 0
        else
          -- For all other lines, use the default treesitter fold expression.
          return vim.treesitter.foldexpr()
        end
      end

      -- Function to close all folds except the one under the cursor
      function _G.focus_fold()
        -- If no fold exists at the current line, do nothing.
        if vim.fn.foldlevel '.' == 0 then
          -- Optionally print a message, or just return silently.
          -- print("Not inside a fold.")
          return
        end

        -- Save the current window view (cursor position, scrolling)
        local view = vim.fn.winsaveview()

        -- 1. Programmatically close all folds by setting foldlevel to 0.
        -- This is the correct Lua equivalent of the 'zM' command.
        vim.o.foldlevel = 0

        -- 2. Open the fold under the cursor, recursively.
        -- 'foldopen!' opens nested folds as well, which is what 'zO' does.
        -- 'silent!' prevents any messages or errors from showing.
        vim.cmd 'silent! foldopen!'

        -- Restore the window view to keep the cursor exactly where it was.
        vim.fn.winrestview(view)
      end

      -- Function to close all folds except the one under the cursor
      function _G.focus_fold_toplevel()
        -- If no fold exists at the current line, do nothing.
        if vim.fn.foldlevel '.' == 0 then
          -- Optionally print a message, or just return silently.
          -- print("Not inside a fold.")
          return
        end

        -- Save the current window view (cursor position, scrolling)
        local view = vim.fn.winsaveview()

        -- 1. Programmatically close all folds by setting foldlevel to 0.
        -- This is the correct Lua equivalent of the 'zM' command.
        vim.o.foldlevel = 0

        -- 2. Open the fold under the cursor, recursively.
        -- 'foldopen!' opens nested folds as well, which is what 'zO' does.
        -- 'silent!' prevents any messages or errors from showing.
        vim.cmd 'silent! foldopen'

        -- Restore the window view to keep the cursor exactly where it was.
        vim.fn.winrestview(view)
      end

      vim.opt.foldmethod = 'expr'
      -- vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.opt.foldexpr = 'v:lua.custom_fold_expr()'
      vim.opt.foldenable = true
      -- vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 3
      vim.opt.foldtext =
        [[ repeat(' ', &shiftwidth * (v:foldlevel - 1)) . '▸ ' . trim(getline(v:foldstart)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)' . '...']]
      vim.opt.fillchars = 'fold: '
      vim.opt.foldnestmax = 3
      vim.opt.foldminlines = 1

      -- vim.api.nvim_create_autocmd('CursorMoved', {
      --   pattern = { '*.c', '*.cpp', '*.h' },
      --   command = 'if foldlevel(line(".")) > foldlevel(line(".") - 1) | silent! foldopen | endif',
      -- })

      -- Keymap to call the focus_fold function
      vim.keymap.set('n', 'zF', '<Cmd>lua _G.focus_fold()<CR>', {
        desc = 'Focus on current fold completely',
        silent = true,
      })
      -- Keymap to call the focus_fold function
      vim.keymap.set('n', 'zf', '<Cmd>lua _G.focus_fold_toplevel()<CR>', {
        desc = 'Focus on current fold',
        silent = true,
      })
    end,
  },
}
