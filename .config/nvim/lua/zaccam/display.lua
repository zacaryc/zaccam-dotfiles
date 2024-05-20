
-- Display Settings {{{
vim.cmd[[
    " Set Colouring Themes
    set t_Co=256
    let g:hybrid_use_Xresources = 1

    set background=dark
    colorscheme hybrid
    "colorscheme two-firewatch
    "set guifont=DejaVuSansMono\ Nerd\ Font
    set guifont=Hack\ Nerd\ Font:h13
    let g:airline_theme="hybrid"
    let g:airline_powerline_fonts = 1
    let g:webdevicons_enable_airline_statusline = 1
    let g:webdevicons_enable_ctrlp = 1

    " Set this. Airline will handle the rest.
    let g:airline#extensions#ale#enabled = 1

    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_symbols.space = " "

    if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && v:version >= 700
        let &listchars = "tab:\u21e5\u00b7,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
        let &fillchars = "vert:\u259a,fold:\u00b7"
    else
        set listchars=tab:>\ ,trail:-,extends:>,precedes:<
    endif
]]
--"}}}
