local fn = vim.fn

-- Have packer use a popup window
local packer = require('packer')
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

return packer.startup(function(use)
  -- Need to load first
  use({ "lewis6991/impatient.nvim" })
  use({ "nathom/filetype.nvim" })
  use({ "nvim-lua/plenary.nvim" })
  use({ "nvim-lua/popup.nvim" })
  use({ "kyazdani42/nvim-web-devicons" })

  -- Color
  use({
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require("plugins/catppuccin")
    end,
  })

  use({ "LnL7/vim-nix" })

  -- LSP
  use({
    "neovim/nvim-lspconfig", -- A collection of common configurations for Neovim's built-in language server client.
    config = function()
      require("lsp")
    end
  })

  use({ "hashivim/vim-terraform" })

  -- Illuminate
  use({
    "RRethy/vim-illuminate",
    config = function()
      require("plugins/vim-illuminate")
    end,
  }) -- Illuminates current word in the document

  -- Fuzzy finder
  use({
    "ibhagwan/fzf-lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("plugins/fzf")
    end,
  })

  -- Autocomplete
  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins/nvim-cmp")
    end,
  })
  use({ "hrsh7th/cmp-path" })
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-buffer" })
  use({ "onsails/lspkind-nvim" })
  use({ "L3MON4D3/LuaSnip" }) -- Luasnip: Only for expansion of nvim-cmp

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("plugins/nvim-treesitter")
    end,
  })
  use({ "nvim-treesitter/nvim-treesitter-textobjects" })

  -- Gitsigns
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("plugins/gitsigns")
    end,
  })

  -- Whichkey
  use({
    "folke/which-key.nvim",
    config = function()
      require("plugins/which-key")
    end,
  })

  -- Comments
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })

  -- Show indent lines
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins/indent-blankline")
    end,
  })

  -- Better quickfix
  use({
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  })

  -- LSP addons
  use({ "jose-elias-alvarez/nvim-lsp-ts-utils" })
  use({ "jose-elias-alvarez/null-ls.nvim" })

  -- Explorer
  use({
    "kyazdani42/nvim-tree.lua",
    requires = {
      "kyazdani42/nvim-web-devicons", -- optional, for file icon
    },
    config = function()
      require("plugins/nvim-tree")
    end,
  })

  -- Colorize hex values
  use("ap/vim-css-color")

  -- Modify faster (){}[] contents
  use("wellle/targets.vim")

  -- Find and replace
  use("nvim-pack/nvim-spectre")

  -- Status Line
  use({
    "hoob3rt/lualine.nvim",
    config = function()
      require("plugins/lualine")
    end,
  })

  -- Copilot
  use({
    "github/copilot.vim",
    config = function()
      require("plugins/copilot")
    end,
  })

  -- Git
  use("tpope/vim-fugitive")

  -- Add gS and gJ keymaps for smart split/join operations
  -- TODO: Port to Lua
  use("AndrewRadev/splitjoin.vim")

  -- Others
  use("tommcdo/vim-exchange")
  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end,
  }) -- TODO: Use more
  use("tpope/vim-repeat")
  use({
    "christoomey/vim-tmux-navigator",
    config = function()
      require("plugins/tmux-navigator")
    end,
  })
end)
