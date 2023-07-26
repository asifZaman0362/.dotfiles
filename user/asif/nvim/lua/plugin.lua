local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
    use 'nvim-lualine/lualine.nvim'
    use "rktjmp/lush.nvim"
    use "Metalelf0/jellybeans-nvim"
    use "nvim-treesitter/nvim-treesitter"
    --use "tribela/vim-transparent"
    use { 'bluz71/vim-moonfly-colors', branch = 'cterm-compat' }
    use "wbthomason/packer.nvim"
    use {
        "ellisonleao/gruvbox.nvim"
    }
    use { 'nyoom-engineering/oxocarbon.nvim' }
    use {
        "mattn/emmet-vim", as = emmet,
    }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly'                     -- optional, updated every week. (see issue #1193)
    }
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim"
    }
    use 'folke/tokyonight.nvim'
    use "neovim/nvim-lspconfig"
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'MunifTanjim/eslint.nvim'
    --use "lvimuser/lsp-inlayhints.nvim"
    use('simrat39/inlay-hints.nvim')
    use "simrat39/rust-tools.nvim"
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/vim-vsnip'
    use 'asifZaman0362/prettier.nvim'
    use { 'nvim-telescope/telescope-fzf-native.nvim',
        run =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    use {
        'tanvirtin/vgit.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        }
    }
    use 'mfussenegger/nvim-dap'
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use 'nvim-treesitter/nvim-treesitter-context'
    use "lukas-reineke/indent-blankline.nvim"
    --use { 'glepnir/lspsaga.nvim' }
    use({
        'nvimdev/lspsaga.nvim',
        after = 'nvim-lspconfig',
        config = function()
            require('lspsaga').setup({})
        end,
    })
    use "xiyaowong/transparent.nvim"
    use({ 'rose-pine/neovim', as = 'rose-pine' })
    use 'LhKipp/nvim-nu'
    use "willthbill/opener.nvim"
    use 'goolord/alpha-nvim'
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        }
    }
    use {
        "jesseleite/nvim-noirbuddy",
        requires = { "tjdevries/colorbuddy.nvim", branch = "dev" }
    }
    if packer_bootstrap then
        require('packer').sync()
    end
end)
