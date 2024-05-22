--vim.cmd.packadd('packer.nvim')

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- TODO: Test TODO
-- FIX: Test FIX
-- WARN: Test WARN
-- HACK: Test Hack
-- NOTE: Test
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  --
  -- My plugins here
    use 'junegunn/goyo.vim'
    use 'junegunn/limelight.vim'
    use({'junegunn/fzf', run = './install --all' })
    use 'junegunn/fzf.vim'
    use 'kien/rainbow_parentheses.vim'

    --" UI
    use 'w0ng/vim-hybrid'
    -- use 'HoNamDuong/hybrid.nvim' -- Treesitter compatible
    use 'marko-cerovac/material.nvim'
    use 'PHSix/nvim-hybrid'
    use 'navarasu/onedark.nvim'
    use 'edeneast/nightfox.nvim'
    use 'olimorris/onedarkpro.nvim'
    use 'rebelot/kanagawa.nvim'
    use { "catppuccin/nvim", as = "catppuccin" }

    use 'altercation/vim-colors-solarized'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    use 'tpope/vim-vinegar'
    use 'ryanoasis/vim-devicons'
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    --" Edit
    use 'majutsushi/tagbar'-- , { 'on': 'TagbarToggle' }
    vim.g.tagbar_sort = 0
    use {
        'folke/todo-comments.nvim', -- Adds custom highlighting of todo/warning/notes etc
        requires = {
            { 'nvim-lua/plenary.nvim' },
        }
    }
    use 'nathanaelkane/vim-indent-guides'
    use 'Raimondi/delimitMate'

    --"Git
    use 'airblade/vim-gitgutter'
    --"use 'mhinz/vim-signify' " Possible alternative - supposedly be faster, needs trial

    --" Tpope godliness
    use 'tpope/vim-fugitive'
    use 'tpope/vim-git'
    use 'tpope/vim-sensible'
    use 'tpope/vim-markdown'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'

    --" Languages
    use({'fatih/vim-go', run = ':GoInstallBinaries' })
    --" use 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
    use 'elzr/vim-json'
    use 'pangloss/vim-javascript'
    use 'rodjek/vim-puppet'

    --" Misc
    use 'Konfekt/FastFold'

    --" Lint
    use 'w0rp/ale'

    --" Syntax
    use({"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"})

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

