"
" Welcome to my vimrc
"
" Plugin Managers {{{
" Pathogen {{{
" Due to ALE vs Syntastic
if version >= 800
    let g:ale_emit_conflict_warnings = 0
endif

"Pathogen Package Manager
execute pathogen#infect()

" }}}
" Plug {{{
call plug#begin()
call plug#end()
"}}}
"}}}
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
" Vim Settings ====== {{{

set autoindent
set smartindent
set showcmd
set tabstop=4
set shiftwidth=4
" Add backspace ,start <- to backspace past where you entered insert
set backspace=indent,eol
set numberwidth=4
set smarttab
set expandtab
set ruler
set number
set relativenumber
set ttyfast
set autoread
set more
set scrolloff=8

set hlsearch
set ignorecase
set smartcase
set incsearch

" NetRW Settings
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 20

nnoremap <leader>l :Lexplore<CR>


"}}}
" Filetype-Specific Settings {{{

" Conf {{{
    augroup ft_conf
        au!

        au BufRead,BufNewFile *.conf set filetype=conf
    augroup END
"}}}
" Java {{{

augroup ft_java
    au!

    au FileType java setlocal foldmethod=marker
    au FileType java setlocal foldmarker={,}
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

        "au FileType gitcommit :echo fugitive#statusline()
        au FileType gitcommit 1 | startinsert
    augroup END
"}}}
" }}}
" Folding ------ {{{

set foldmethod=marker foldmarker={{{,}}}
set foldlevelstart=0

" Set space to toggle folds
nnoremap <Space> za
vnoremap <Space> za

" Make z0 recursively open whatever fold we're in even if it's partially open
nnoremap z0 zcz0

" }}}
" Display Settings {{{

set t_Co=256
let g:hybrid_use_Xresources = 1
set background=dark
colorscheme hybrid
let g:airline_theme='jellybeans'

" Set airline symbols
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = " "

if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && version >= 700
  let &listchars = "tab:\u21e5\u00b7,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
  let &fillchars = "vert:\u259a,fold:\u00b7"
else
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<
endif

"}}}
" Status Line {{{1

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%{fugitive#statusline()}
set statusline+=%*

" }}}1
" Plugins ------ {{{1

" Set Syntastic Properties {{{2
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_perl_checker = 1
let g:syntastic_enable_yaml_yamllint_checker = 1
let g:syntastic_yaml_checkers = ['yamllint']
let g:syntastic_perl_checkers = ['perl', 'podchecker']
let g:syntastic_xml_checkers = ['xmllint']
let g:syntastic_puppet_puppet_args = '--parser=future'
let g:syntastic_eruby_ruby_quiet_messages = {'regex': 'useless use of a variable in void context'}
"  }}}2
" Ctrl-P Properties {{{2

set runtimepath^=~/.vim/bundle/ctrlp.vim

" Let Ctrl P search through my dotfiles as well
let g:ctrlp_show_hidden = 1
" Excluding version control directories
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Linux/MacOSX
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

"}}}2
" Vim GitGutter {{{2

" Default = 4000ms - this polls every 250ms now
set updatetime=250

"}}}2
" Goyo {{{2

    function! s:goyo_enter()
      let b:quitting = 0
      let b:quitting_bang = 0
      autocmd QuitPre <buffer> let b:quitting = 1
      cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
      Limelight
      GitGutterEnable
    endfunction

    function! s:goyo_leave()
      Limelight!
      " Quit Vim if this is the only remaining buffer
      if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
        if b:quitting_bang
          qa!
        else
          qa
        endif
      endif
    endfunction

    autocmd! User GoyoEnter call <SID>goyo_enter()
    autocmd! User GoyoLeave call <SID>goyo_leave()
"}}}2
" Limelight {{{2
    " Number of preceding/following paragraphs to include (default: 0)
    let g:limelight_paragraph_span = 1

    " Highlighting priority (default: 10)
    " Set it to -1 not to overrule hlsearch
    let g:limelight_priority = -1
"}}}2
" }}}1
" Whitespace busting ---------- {{{

" highlight extra whitespace
autocmd Syntax * syn match airline_error_inactive_red /\s\+$\| \+\ze\t/
autocmd BufWinEnter * match airline_error_inactive_red /\s\+$/
autocmd InsertEnter * match airline_error_inactive_red /\s\+\%#\@<!$/
autocmd InsertLeave * match airline_error_inactive_red /\s\+$/
autocmd BufWinLeave * call clearmatches()

if version >= 800
    " Set this. Airline will handle the rest.
    let g:airline#extensions#ale#enabled = 1
endif

" function to trim trailing whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun
" allow usage of :TrimWhitespace instead of :call TrimWhitespace()
command! TrimWhitespace call TrimWhitespace()

" Automatically trim trailing whitespace on the following filetypes
autocmd FileType velocity,xml,java,sh,bash autocmd BufWritePre <buffer> TrimWhitespace

" Turn on HardKient Mode
autocmd VimEnter,BufNewFile,BufReadPost * silent! call DontPoint()

"}}}
" Buffers on Open ------- {{{
" Return to last edit position when opening files (you want this!)
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
" Remember info about open buffers on close
set viminfo^=%
"}}}
" Mappings {{{1

let mapleader=";"
let maplocalleader="\\"

"remap VIM 0 to first non-blank character
map 0 ^

" Disable that fucking 'Entering Ex mode. Type 'visual' to go to Normal mode
" " that I trigger 40x a day
map Q <Nop>
map q <Nop>

" Move to matching tags i.e. <...> via tab
map <tab> %

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %


" }}}1
" Code Helping/IDE Mappings {{{

" -------------------------------
" Todo
" -------------------------------
function! s:todo() abort
    let entries = []
    for cmd in ['git grep -niIw -e TODO -e FIXME 2>/dev/null',
                \ 'grep -rniIw -e TODO -e FIXME 2>/dev/null']
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
"}}}
" Miscellaneous {{{

" Disable vim jumping to matching parantheses
let loaded_matchparen = 1

" }}}
" Generating Help Files {{{
" Only for Vim 8
if version > 800
    " Load all plugins now.
    " " Plugins need to be added to runtimepath before helptags can be
    " generated.
    packloadall
    " " Load all of the helptags now, after plugins have been loaded.
    " " All messages and errors will be ignored.
    silent! helptags ALL
endif
"}}}
