-- Display Settings

-- Set Font
-- vim.opt.guifont = 'DejaVuSansMono Nerd Font'
vim.opt.guifont = 'Hack Nerd Font:h13'

-- Set Colouring Themes
vim.cmd("set t_Co=256")
vim.cmd("let g:hybrid_use_Xresources = 1")

-- Set Colorscheme
vim.opt.background = 'dark'
vim.cmd.colorscheme("hybrid")
-- vim.cmd.colorscheme("kanagawa-dragon")

-- Set Airline Theme
vim.cmd[[
    let g:airline_theme="hybrid"
    let g:airline_powerline_fonts = 1
    let g:webdevicons_enable_airline_statusline = 1
]]

-- Set this. Airline will handle the rest.
vim.cmd("let g:airline#extensions#ale#enabled = 1")

vim.cmd[[
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_symbols.space = " "
]]

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

