return {
  {
    'leath-dub/snipe.nvim',
    keys = {
      {
        'gb',
        function()
          require('snipe').open_buffer_menu()
        end,
        desc = 'Open Snipe buffer menu',
      },
    },
    opts = {
      hints = {
        dictionary = 'shtarenicp',
      },
      ui = {
        position = 'center',
        open_win_override = {
          -- title = "My Window Title",
          border = 'rounded',
        },
        navigate = {
          -- Specifies the "leader" key
          -- This allows you to select a buffer but defer the action.
          -- NOTE: this does not override your actual leader key!
          leader = ',',

          -- Leader map defines keys that follow a selection prefixed by the
          -- leader key. For example (with tag "a"):
          -- ,ad -> run leader_map["d"](m, i)
          -- NOTE: the leader_map cannot specify multi character bindings.
          leader_map = {
            ['d'] = function(m, i)
              require('snipe').close_buf(m, i)
            end,
            ['v'] = function(m, i)
              require('snipe').open_vsplit(m, i)
            end,
            ['h'] = function(m, i)
              require('snipe').open_split(m, i)
            end,
          },
        },
      },
    },
  },
}
