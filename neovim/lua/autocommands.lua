require("utils").define_augroups({
  _general_settings = {
    {
      "TextYankPost",
      "*",
      "lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})",
    },
  },
  _markdown = {
    { "FileType", "markdown", "setlocal wrap" },
    { "FileType", "markdown", "setlocal spell" },
  },
  _resize = {
    -- Automatically rebalance windows on vim resize (added because tmux)
    { "VimResized", "*", ":wincmd =" },
  },
})
