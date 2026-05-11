return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'master',
        lazy = false,
      },
    },
    -- main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'diff',
        'html',
        'go',
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
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['ap'] = '@parameter.outer',
            ['ip'] = '@parameter.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
        },
      },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      local function normalize_tsnode(node)
        if type(node) == 'table' and #node == 1 and type(node[1]) == 'userdata' then
          return node[1]
        end

        return node
      end

      local original_get_node_text = vim.treesitter.get_node_text
      vim.treesitter.get_node_text = function(node, source, opts_)
        return original_get_node_text(normalize_tsnode(node), source, opts_)
      end

      local original_get_range = vim.treesitter.get_range
      vim.treesitter.get_range = function(node, source, metadata)
        return original_get_range(normalize_tsnode(node), source, metadata)
      end

      local ts_query = require 'nvim-treesitter.query'
      local function normalize_match(match)
        if type(match) ~= 'table' then
          return match
        end

        if type(match.node) == 'table' and #match.node >= 1 and type(match.node[1]) == 'userdata' then
          match.node = match.node[1]
        end

        for _, value in pairs(match) do
          if type(value) == 'table' then
            normalize_match(value)
          end
        end

        return match
      end

      local original_get_capture_matches_recursively = ts_query.get_capture_matches_recursively
      ts_query.get_capture_matches_recursively = function(bufnr, capture_or_fn, query_type)
        local matches = original_get_capture_matches_recursively(bufnr, capture_or_fn, query_type)
        if query_type ~= 'textobjects' then
          return matches
        end

        for _, match in ipairs(matches) do
          normalize_match(match)
        end

        return matches
      end

      local original_find_best_match = ts_query.find_best_match
      ts_query.find_best_match = function(bufnr, capture_string, query_group, filter_predicate, scoring_function, root)
        if query_group ~= 'textobjects' then
          return original_find_best_match(bufnr, capture_string, query_group, filter_predicate, scoring_function, root)
        end

        return original_find_best_match(bufnr, capture_string, query_group, function(match)
          return filter_predicate(normalize_match(match))
        end, function(match)
          return scoring_function(normalize_match(match))
        end, root)
      end

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
