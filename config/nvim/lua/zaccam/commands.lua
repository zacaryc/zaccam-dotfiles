-- All of the commands

-- Commands {{{
vim.cmd [[
command! -bar -nargs=1 -complete=file E :exe "edit ".substitute(<q-args>,'\(.*\):\(\d\+\):\=$','+\2 \1','')
command! -bar -nargs=? -bang Scratch :silent enew<bang>|set buftype=nofile bufhidden=hide noswapfile buflisted filetype=<args> modifiable
function! s:scratch_maps() abort
    nnoremap <silent> <buffer> == :Scratch<CR>
    nnoremap <silent> <buffer> =" :Scratch<Bar>put<Bar>1delete _<Bar>filetype detect<CR>
    nnoremap <silent> <buffer> =* :Scratch<Bar>put *<Bar>1delete _<Bar>filetype detect<CR>
    nnoremap          <buffer> =f :Scratch<Bar>setfiletype<Space>
endfunction
]]

-- }}}
-- Autocommands {{{
-- -------------------------
vim.cmd [[

if has("autocmd")

    " Conf {{{
    augroup ft_conf
        au!

        au BufRead,BufNewFile *.conf set filetype=conf
    augroup END
    "}}}
    " TMux {{{
    augroup ft_tmux
        au!

        autocmd BufNewFile,BufRead {.,}tmux*.conf* setfiletype tmux
    augroup END
    " }}}
    " Vagrant {{{

    augroup ft_vagrant
        au!
        au BufRead,BufNewFile Vagrantfile set filetype=ruby
    augroup END

    " }}}
    " HOCON {{{

"    augroup ft_hocon
"        au!
"
"        au FileType hocon setlocal foldmethod=syntax foldlevel=0
"        au FileType hocon setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4
"        au BufRead,BufNewFile *.velocity.conf set filetype=hocon
"    augroup END

    "}}}
    " Vim {{{

    augroup ft_vim
        au!

        au FileType vim setlocal foldmethod=marker keywordprg=:help
        au FileType help setlocal textwidth=78
        au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
        au BufWritePost .vimrc nested source % | redraw
    augroup END

    "}}}
    " XSD {{{

    augroup ft_xml
        au!

        " au FileType xsd setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4 foldmethod=manual

        " Indent Tag
        " au FileType xsd nnoremap <buffer> <localleader>= Vat=

        " Tagbar
        let g:tagbar_type_xsd = {
            \ 'ctagstype' : 'XSD',
            \ 'kinds'     : [
                \ 'e:elements',
                \ 'c:complexTypes',
                \ 's:simpleTypes'
            \ ]
        \ }

    augroup END

    "}}}
    "Jenkinsfile DSL {{{
    augroup ft_jenkinsfile
        au!

        au BufRead,BufNewFile Jenkinsfile set filetype=groovy
    augroup END
    "}}}
    " RC Files {{{
    augroup ft_rcfiles
        au!

        au BufRead,BufNewFile .smartsrc set filetype=sh
    augroup END
    " }}}
    " Git Commit {{{
    augroup ft_gitcommit
        au!

        au FileType gitcommit setlocal comments=:#
        au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0]) | startinsert
    augroup END
    "}}}
    " Quickfix {{{
    augroup autoquickfix
		autocmd!
		autocmd QuickFixCmdPost [^l]* cwindow
		autocmd QuickFixCmdPost    l* lwindow
	augroup END
    " }}}
    " Misc {{{
    augroup Misc
        autocmd!

        autocmd FileType netrw call s:scratch_maps()
        autocmd FileType gitcommit if getline(1)[0] ==# '#' | call s:scratch_maps() | endif
        autocmd FocusLost   * silent! wall
        autocmd FocusGained * if !has('win32') | silent! call fugitive#reload_status() | endif
        autocmd SourcePre */macros/less.vim set laststatus=0 cmdheight=1
        if v:version >= 700 && isdirectory(expand("~/.trash"))
            autocmd BufWritePre,BufWritePost * if exists("s:backupdir") | set backupext=~ | let &backupdir = s:backupdir | unlet s:backupdir | endif
            autocmd BufWritePre ~/*
                        \ let s:path = expand("~/.trash").strpart(expand("<afile>:p:~:h"),1) |
                        \ if !isdirectory(s:path) | call mkdir(s:path,"p") | endif |
                    \ let s:backupdir = &backupdir |
                    \ let &backupdir = escape(s:path,'\,').','.&backupdir |
                    \ let &backupext = strftime(".%Y%m%d%H%M%S~",getftime(expand("<afile>:p")))
        endif

        autocmd BufNewFile */init.d/*
                    \ if filereadable("/etc/init.d/skeleton") |
                    \   keepalt read /etc/init.d/skeleton |
                    \   1delete_ |
                    \ endif |
                    \ set ft=sh

        autocmd BufReadPost * if getline(1) =~# '^#!' | let b:dispatch = getline(1)[2:-1] . ' %' | let b:start = b:dispatch | endif
        autocmd BufReadPost ~/.Xdefaults,~/.Xresources let b:dispatch = 'xrdb -load %'
        autocmd BufWritePre,FileWritePre /etc/* if &ft == "dns" |
                    \ exe "normal msHmt" |
                    \ exe "gl/^\\s*\\d\\+\\s*;\\s*Serial$/normal ^\<C-A>" |
                    \ exe "normal g`tztg`s" |
                    \ endif
        autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
                    \ if !$VIMSWAP && isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif


        if exists('$TMUX') && !exists('$NORENAME')
            au BufEnter * if empty(&buftype) | call system('tmux rename-window '.expand('%:t:S')) | endif
			au VimLeave * call system('tmux set-window automatic-rename on')
		endif

    augroup END
    " }}}

endif
]]

--}}}
-- Miscellaneous {{{
-- She-Bang
vim.cmd[[inoreabbrev <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)]]
-- }}}
