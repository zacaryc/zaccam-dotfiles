-- Netrw
--
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 20
vim.cmd('let g:netrw_list_hide = &wildignore')

-- -----------------------------
--  Fix up for netrw behaviour
--  https://www.reddit.com/r/vim/comments/6jcyfj/toggle_lexplore_properly/
-- -----------------------------
vim.cmd[[
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

--  Set statusline
-- vim.cmd('set statusline+=%#warningmsg#')
-- vim.cmd('set statusline+=%{fugitive#statusline()}')
-- vim.cmd('set statusline+=%*')
