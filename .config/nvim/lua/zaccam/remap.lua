
-- Mappings {{{
vim.cmd [[

" > General Map {{{2

"remap VIM 0 to first non-blank character
map 0 ^
" Disable that goddamn 'Entering Ex mode. Type 'visual' to go to Normal mode.'
" " that I trigger 40x a day.
map Q <Nop>
map q <Nop>
" Move to matching tags i.e. <...> via tab
map <tab> %

" Delete without affecting registers
nnoremap <leader>d "_d
vnoremap <leader>d "_d

"}}}2
]]
vim.cmd [[
" > Normal Mode Map {{{2

" Have capital Y yank til EOL
nnoremap Y y$
" Open Netrw Draw
nnoremap <silent> <Leader>l :call ToggleNetrw()<CR>
" Open Tagbar
nnoremap <Leader>t :TagbarToggle<CR>
" Open To Do List
nnoremap <localleader>t :Todo<CR>
" Git Status
nnoremap <leader>gs :G<CR>
" Git Blame
nnoremap <Leader>b :Git blame -w<CR>

" Keep searches centred
nnoremap n nzzzv
nnoremap N Nzzzv

"Yank entire document to clipboard
nnoremap <leader>y mzgg"+yG`z

" }}}2
]]
vim.cmd [[
" > Command Mode {{{2

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" }}}2
]]
vim.cmd [[
" > Insert Mode {{{2

" Instead of reaching for the escape key
inoremap kj <Esc>

" Add break points for undo
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

" }}}2
]]
vim.cmd [[
" > Visual Mode {{{2
vnoremap <Space> I<Space><Esc>gv
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

xnoremap <leader>p "_dP

" }}}2

if has('digraphs')
    digraph ./ 8230
endif

]]
-- }}}
-- Code Helping/IDE Mappings {{{
vim.cmd [[
" WhiteSpace Busting {{{

" highlight extra whitespace

highlight ExtraWhitespace ctermbg=red guibg=red

autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" ----------------------------------------------------------------------------
" Trim Whitespace
" ----------------------------------------------------------------------------
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunction

" Allow usage of :TrimWhitespace instead of :call TrimWhitespace()
command! TrimWhitespace call TrimWhitespace()
"}}}
" Todo {{{
function! s:todo() abort
    let entries = []
    for cmd in ['git grep -niI -e TODO -e FIXME 2> /dev/null',
                \ 'grep -rniI -e TODO -e FIXME 2> /dev/null']
        let lines = split(system(cmd), '\n')
        if v:shell_error != 0 | continue | endif
        for line in lines
            let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
            call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
        endfor
        break
    endfor

    if !empty(entries)
        call setqflist(entries)
        copen
    endif
endfunction
command! Todo call s:todo()

"}}}
" Number Toggle {{{

" toggle between number and relativenumber and none
function! ToggleNumber()
    if(&relativenumber == 0 && &number == 0)
        set relativenumber
    elseif(&relativenumber == 1 && &number == 0)
        set norelativenumber
        set number
    else
        set norelativenumber
        set nonumber
    endif
endfunction

nnoremap <leader>n :call ToggleNumber()<CR>

" }}}
" Copy Mode {{{
" This is to remove all screen additions to copy code to clipboard
function! CleanScreenCopy()
    set norelativenumber
    set nonumber
    GitGutterDisable
    IndentGuidesDisable
    nohl
    redraw!
endfunction

nnoremap <leader>c :call CleanScreenCopy()<CR>
" }}}
" Fold Text {{{2

" FastFold
" Credits: https://github.com/Shougo/shougo-s-github
augroup MyAutoCmd
    autocmd!

    autocmd CursorHold *? syntax sync minlines=300
augroup END

autocmd MyAutoCmd TextChangedI,TextChanged *
            \ if &l:foldenable && &l:foldmethod !=# 'manual' |
            \   let b:foldmethod_save = &l:foldmethod |
            \   let &l:foldmethod = 'manual' |
            \ endif

autocmd MyAutoCmd BufWritePost *
            \ if &l:foldmethod ==# 'manual' && exists('b:foldmethod_save') |
            \   let &l:foldmethod = b:foldmethod_save |
            \   execute 'normal! zx' |
            \ endif

function! MyFoldText()
    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let totalLineCount = line("$")
    let foldPercentage = printf("[%3.1f", (lines_count*1.0)/totalLineCount*100) . "%]"
    let lines_count_text = '| ' . printf("%10s", lines_count . ' lines')
                \ . printf("%8s", foldPercentage) . ' |'
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 10)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction

set foldtext=MyFoldText()

" }}}2

]]
-- " }}}
