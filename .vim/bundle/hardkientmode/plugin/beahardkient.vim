" This is my own version of hardmode
" Author: Zachary Campbell
" Version: 1.0
"

if exists('g:hardkientactivated')
    finish
endif
let g:hardkientactivated = 1

function! DontPoint()

    vnoremap <buffer> <Left> <Nop>
    vnoremap <buffer> <Right> <Nop>
    vnoremap <buffer> <Up> <Nop>
    vnoremap <buffer> <Down> <Nop>
    vnoremap <buffer> <PageUp> <Nop>
    vnoremap <buffer> <PageDown> <Nop>

    nnoremap <buffer> <Left> <Nop>
    nnoremap <buffer> <Right> <Nop>
    nnoremap <buffer> <Up> <Nop>
    nnoremap <buffer> <Down> <Nop>
    nnoremap <buffer> <PageUp> <Nop>
    nnoremap <buffer> <PageDown> <Nop>

endfunction
