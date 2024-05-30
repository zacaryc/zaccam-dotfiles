-- Display Settings

-- Set Font
-- vim.opt.guifont = 'DejaVuSansMono Nerd Font'
vim.opt.termguicolors = true
vim.opt.guifont = 'Hack Nerd Font:h13'

-- Set Colouring Themes
vim.cmd("set t_Co=256")
vim.cmd("let g:hybrid_use_Xresources = 1")

-- Set Colorscheme
vim.opt.background = 'dark'
vim.cmd.colorscheme("catppuccin-mocha")
vim.cmd.colorscheme("hybrid")

-- Set List Characters and Fill Characters
vim.opt.listchars:append {
    tab = '⇥·',
    trail = '␣',
    extends = '⇉',
    precedes = '⇇',
    nbsp = '⚭'
}

vim.opt.fillchars:append {
    vert = '▚',
    fold = '·'
}
