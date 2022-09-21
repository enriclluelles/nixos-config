local packer = require("packer")
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

packer.startup(function(use)
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

    -- LSP
    use({
        "neovim/nvim-lspconfig", -- A collection of common configurations for Neovim's built-in language server client.
        config = function()
            require("lsp")
        end
    })

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
end)
