"
" Zac's VIMRC
"

let s:darwin = has('mac')

" Package Management {{{

" To disable a plugin, add it's bundle name to the following list
"let g:pathogen_disabled = []

" Pathogen Package Manager
execute pathogen#infect()

" }}}
" Vim Base Settings {{{

syntax on
filetype on
filetype plugin on
filetype indent on

" Always show status bar
set laststatus=2

" Don't require backward support for vi
set nocompatible

"}}}
" Vim Settings {{{

set autoindent
set smartindent
set showcmd
set textwidth=80
set tabstop=4
set softtabstop=4
set shiftwidth=4
" Add backspace ,start <- to backspace past where you entered insert
set backspace=indent,eol
set numberwidth=4
set smartcase " Case insensitive searches become sensitive with capitals
set smarttab " sw at start of line, sts everywhere else
set expandtab
set ruler
set number
set relativenumber
set ttyfast
set autoread
set more
set cursorline!
set scrolloff=8
set hlsearch
set fileformats=unix,dos,mac
set foldopen+=jump
set formatoptions+=j
set printoptions=paper:letter
set dictionary+=/usr/share/dict/words
set pastetoggle=<localleader>p

" Disable matchparen which jumps the cursor on matching parentheses
let loaded_matchparen = 1

if exists('+breakindent')
    set breakindent showbreak=\ +
endif
set cmdheight=2
if has("eval")
    let &highlight = substitute(&highlight,'NonText','SpecialKey','g')
endif
if exists("+spelllang")
    set spelllang=en_au,en_gb
endif

" Folding {{{

set foldmethod=marker foldmarker={{{,}}}
set foldlevelstart=0

" Set space to toggle folds
nnoremap <Space> za
vnoremap <Space> za

" Make z0 recursively open whatever fold we're in even if it's partially open
nnoremap z0 zcz0

" }}}
" Netrw {{{

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

" }}}

" }}}
" Status Line {{{
" Set statusline
set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%{fugitive#statusline()}
set statusline+=%*
"}}}
" Display Settings {{{

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
"}}}
" Plugins {{{

" Plugin: Ctrl-P Properties {{{2

set runtimepath^=~/.vim/bundle/ctrlp.vim

" Let Ctrl P search through my dotfiles as well
let g:ctrlp_show_hidden = 1

" Set Wildmenu ignores
if has('wildmenu')
    set wildmode=list:longest,full
    set wildoptions=tagfile
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Linux/MacOSX
    set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
    set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_tore
    set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
    set wildignore+=application/vendor/**,**/vendor/ckeditor/**,media/vendor/**
    set wildignore+=__pycache__,*.egg-info
endif
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

"}}}2
" Plugin: Rainbow Parantheses {{{2

" Set RainbowParentheses Plugin to be always on
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

"}}}2
" Plugin: Goyo {{{2

function! s:goyo_enter()
    let b:quitting = 0
    let b:quitting_bang = 0
    autocmd QuitPre <buffer> let b:quitting = 1
    cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
    if has('gui_running')
        set fullscreen
    elseif exists('$TMUX')
        silent !tmux set status off
    endif
    Limelight
    GitGutterEnable
endfunction

function! s:goyo_leave()
    " Quit Vim if this is the only remaining buffer
    if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
        if b:quitting_bang
            qa!
        else
            qa
        endif
    endif
    if exists('$TMUX')
        silent !tmux set status on
    endif
    Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
"}}}2
" Plugin: Limelight {{{2
" Number of preceding/following paragraphs to include (default: 0)
let g:limelight_paragraph_span = 1

" Highlighting priority (default: 10)
" Set it to -1 not to overrule hlsearch
let g:limelight_priority = -1
"}}}2
" Plugin: Git Gutter {{{2

set updatetime=250

" }}}2
" Plugin: Vim Move {{{2

let g:move_key_modifier = 'C'

" }}}2
" Plugin: Indent Guide {{{

if exists('g:loaded_indent_guides')
    " indent-guides
    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1
    let g:indent_guides_color_change_percent = 5
    :IndentGuidesEnable
endif

" }}}
" Plugin: Vim Polyglot {{{
    let g:polyglot_disabled = ['go']
" }}}

" }}}
" Buffers on Open {{{

" Return to last edit position when opening files (You want this!)
" Added exclusion for gitcommit files
autocmd BufReadPost *
            \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif
" Remember info about open buffers on close
set viminfo^=%

"}}}
" Mappings {{{

" Set leader and local leader
let mapleader=";"
let maplocalleader = "\\"

" > General Map {{{2

"remap VIM 0 to first non-blank character
map 0 ^
" Disable that goddamn 'Entering Ex mode. Type 'visual' to go to Normal mode.'
" " that I trigger 40x a day.
map Q <Nop>
map q <Nop>
" Move to matching tags i.e. <...> via tab
map <tab> %

"}}}2
" > Normal Mode Map {{{2

" Have capital Y yank til EOL
nnoremap Y y$
" Open Netrw Draw
nnoremap <silent> <Leader>l :call ToggleNetrw()<CR>
nnoremap <Leader>g :Goyo<CR>
" Open Tagbar
nnoremap <Leader>t :TagbarToggle<CR>

" }}}2
" > Command Mode {{{2

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" }}}2
" > Insert Mode {{{2

" Instead of reaching for the escape key
inoremap kj <Esc>

" }}}2
" > Visual Mode {{{2
vnoremap <Space> I<Space><Esc>gv
" }}}2

if has('digraphs')
    digraph ./ 8230
endif

"}}}
" Code Helping/IDE Mappings {{{

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

" toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction

nnoremap <leader>n :call ToggleNumber()<CR>

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

" }}}
" Commands {{{

command! -bar -nargs=1 -complete=file E :exe "edit ".substitute(<q-args>,'\(.*\):\(\d\+\):\=$','+\2 \1','')
command! -bar -nargs=? -bang Scratch :silent enew<bang>|set buftype=nofile bufhidden=hide noswapfile buflisted filetype=<args> modifiable
command! -bar -count=0 RFC     :e http://www.ietf.org/rfc/rfc<count>.txt|setl ro noma
function! s:scratch_maps() abort
    nnoremap <silent> <buffer> == :Scratch<CR>
    nnoremap <silent> <buffer> =" :Scratch<Bar>put<Bar>1delete _<Bar>filetype detect<CR>
    nnoremap <silent> <buffer> =* :Scratch<Bar>put *<Bar>1delete _<Bar>filetype detect<CR>
    nnoremap          <buffer> =f :Scratch<Bar>setfiletype<Space>
endfunction

" }}}
" Autocommands {{{
" -------------------------

if has("autocmd")
    filetype plugin indent on

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
    " Java {{{

    augroup ft_java
        au!

        au FileType java setlocal foldmethod=marker
        au FileType java setlocal foldmarker={,} makeprg=javac\ %
    augroup END
    "}}}
    " Markdown {{{

    augroup ft_markdown
        au!

        au BufNewFile,BufRead *.md setlocal filetype=markdown
        au BufNewFile,BufRead *.m*down setlocal filetype=markdown
        au FileType markdown setlocal foldlevel=1

        au FileType markdown setlocal spell
        au FileType markdown map <buffer> <localleader>g :Goyo<CR>
    augroup END
    "}}}
    " Ruby {{{

    augroup ft_ruby
        au!

        au FileType ruby setlocal foldmethod=syntax
        au FileType ruby set shiftwidth=2 softtabstop=2 tabstop=2 makeprg=ruby\ %
        au BufRead,BufNewFile Capfile setlocal filetype=ruby
    augroup END
    "}}}
    " Vagrant {{{

    augroup ft_vagrant
        au!
        au BufRead,BufNewFile Vagrantfile set filetype=ruby
    augroup END

    " }}}
    " Velocity {{{

    augroup ft_velocity
        au!

        au FileType velocity setlocal foldmethod=syntax
        au FileType velocity setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4
        au BufRead,BufNewFile *.velocity set filetype=velocity
    augroup END

    "}}}
    " HOCON {{{

    augroup ft_hocon
        au!

        au FileType hocon setlocal foldmethod=syntax foldlevel=0
        au FileType hocon setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4
        au BufRead,BufNewFile *.velocity.conf set filetype=hocon
    augroup END

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
    " YAML {{{

    augroup ft_yaml
        au!

        au FileType yaml set shiftwidth=2
    augroup END

    "}}}
    " XML {{{

    augroup ft_xml
        au!

        au FileType xml setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4 foldmethod=manual

        " Indent Tag
        au FileType xml nnoremap <buffer> <localleader>= Vat=

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

        au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0]) | startinsert
    augroup END
    "}}}
    " Latex {{{
    augroup ft_latex
        au!

        au FileType tex makeprg=pdflatex\ %
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


endif " has("autocmd")

"}}}
" Generating Help Files {{{

" Only for Vim 8
if v:version > 800
    " Load all plugins now.
    " " Plugins need to be added to runtimepath before helptags can be
    " generated.
    packloadall
    " " Load all of the helptags now, after plugins have been loaded.
    " " All messages and errors will be ignored.
    silent! helptags ALL
endif
"}}}
" Miscellaneous {{{

"She-Bang
inoreabbrev <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)


" Open in IntelliJ
if s:darwin
    nnoremap <silent> <leader>ij
        \ :call job_start(['/Applications/IntelliJ IDEA.app/Contents/MacOS/idea', expand('%:p')],
        \ {'in_io': 'null', 'out_io': null, 'err_io': 'null'})<cr>
endif


" }}}

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
