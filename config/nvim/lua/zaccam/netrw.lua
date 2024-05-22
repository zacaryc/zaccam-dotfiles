-- " Netrw {{{
vim.cmd[[
    let g:netrw_banner = 0
    let g:netrw_browse_split = 4
    let g:netrw_altv = 1
    let g:netrw_winsize = 20
    let g:netrw_list_hide = &wildignore

    "-----------------------------
    " Fix up for netrw behaviour
    " https://www.reddit.com/r/vim/comments/6jcyfj/toggle_lexplore_properly/
    "-----------------------------

    let g:NetrwIsOpen=0

    function! ToggleNetrw()
        if g:NetrwIsOpen
            let i = bufnr("$")
            while (i >= 1)
                if (getbufvar(i, "&filetype") == "netrw")
                    silent exe "bwipeout " . i
                endif
                let i-=1
            endwhile
            let g:NetrwIsOpen=0
        else
            let g:NetrwIsOpen=1
            silent Lexplore
        endif
    endfunction
]]
--" }}}
--" }}}
-- " Status Line {{{
vim.cmd[[
    " Set statusline
    set statusline+=%#warningmsg#
    " set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%{fugitive#statusline()}
    set statusline+=%*
]]
--"}}}
