
--
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ';'
vim.g.maplocalleader = '\\'

local plugins = {
    --
    -- My plugins here
    "junegunn/goyo.vim",
    -- "junegunn/limelight.vim",
    "folke/twilight.nvim",
    { "junegunn/fzf", build = "./install --all" },
    "junegunn/fzf.vim",
    "kien/rainbow_parentheses.vim",

    --" UI
    "w0ng/vim-hybrid",
    -- use 'HoNamDuong/hybrid.nvim' -- Treesitter compatible
    -- use 'ColinKennedy/hybrid2.nvim' -- Treesitter compatible
    "folke/tokyonight.nvim",
    {
        "metalelf0/jellybeans-nvim",
        dependencies = { "rktjmp/lush.nvim" },
        lazy = false,
    },
    -- use 'marko-cerovac/material.nvim'
    "PHSix/nvim-hybrid",
    -- use 'navarasu/onedark.nvim'
    -- use 'edeneast/nightfox.nvim'
    -- use 'olimorris/onedarkpro.nvim'
    'rebelot/kanagawa.nvim',
    { "rose-pine/neovim", name = "rose-pine" },
    { "catppuccin/nvim", name = "catppuccin" },
	{
		'nvim-telescope/telescope.nvim', branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

    -- use 'altercation/vim-colors-solarized'
    -- use 'vim-airline/vim-airline'
    -- use 'vim-airline/vim-airline-themes'
    "tpope/vim-vinegar",
    "ryanoasis/vim-devicons",
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
    },

    --" Edit
    "majutsushi/tagbar", -- , { 'on': 'TagbarToggle' }
    -- vim.g.tagbar_sort = 0,

    {
        "folke/todo-comments.nvim", -- Adds custom highlighting of todo/warning/notes etc
        event = 'VimEnter',
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
    },
    "nathanaelkane/vim-indent-guides",
    "Raimondi/delimitMate",

    --"Git
    "airblade/vim-gitgutter",
    --"use 'mhinz/vim-signify' " Possible alternative - supposedly be faster, needs trial

    --" Tpope godliness
    "tpope/vim-fugitive",
    "tpope/vim-git",
    -- "tpope/vim-sensible" -- No longer necessary, all settings are either in base nvim or in my settings
    "tpope/vim-markdown",
    "tpope/vim-commentary",
    "tpope/vim-surround",

    --" Languages
    { "fatih/vim-go", build = ":GoInstallBinaries" },
    --" use 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
    "elzr/vim-json",
    "pangloss/vim-javascript",
    "rodjek/vim-puppet",

    --" Misc
    "Konfekt/FastFold",

    --" Lint
    -- "w0rp/ale",

    --" Syntax
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    --" LSP
    { "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            'williamboman/mason.nvim', -- NOTE: Must be loaded before dependants
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- Useful status updates for LSP.
            { 'j-hui/fidget.nvim', config = function() require('fidget').setup() end },

            -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            { 'folke/neodev.nvim', config = function() require('neodev').setup() end },
        },
    },

}

require("lazy").setup(plugins, {})
