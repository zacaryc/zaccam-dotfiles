-- All of the keymaps for neovim including some specialty functions

-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- WhiteSpace Busting {{{
-- ================================================
-- highlight extra whitespace
vim.cmd [[
highlight ExtraWhitespace ctermbg=red guibg=red

autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
]]

-- ----------------------------------------------------------------------------
-- Trim Whitespace
-- ----------------------------------------------------------------------------
vim.cmd [[
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunction
]]

-- Allow usage of :TrimWhitespace instead of :call TrimWhitespace()
vim.cmd('command! TrimWhitespace call TrimWhitespace()')

-- ================================================ }}}
-- Todo {{{
-- ================================================

vim.cmd [[
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
]]
-- vim.api.nvim_add_user_command('Todo', 'call s:todo()')
vim.cmd('command! Todo call s:todo()')

-- ================================================ }}}
-- Number Toggle {{{
-- ================================================

-- Toggle between number and relativenumber and none
vim.cmd [[
function! ToggleNumber()
    if(&relativenumber == 0 && &number == 0)
        set norelativenumber
        set number
    elseif(&relativenumber == 0 && &number == 1)
        set relativenumber
        set nonumber
    elseif(&relativenumber == 1 && &number == 0)
        set relativenumber
        set number
    else
        set norelativenumber
        set nonumber
    endif
endfunction
]]

map('n', '<leader>n', ":call ToggleNumber()<CR>")

-- ================================================ }}}
-- Copy Mode {{{
-- ================================================

-- This is to remove all screen additions to copy code to clipboard
vim.cmd [[
function! CleanScreenCopy()
    set norelativenumber
    set nonumber
    GitGutterDisable
    IndentGuidesDisable
    nohl
    redraw!
endfunction
]]

map('n', '<leader>c', ":call CleanScreenCopy()<CR>")

-- ================================================ }}}
-- Fold Text {{{
-- ================================================

-- FastFold
-- Credits: https://github.com/Shougo/shougo-s-github
vim.cmd [[
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
]]

vim.cmd [[
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
]]

vim.opt.foldtext = 'MyFoldText()'

-- ================================================ }}}
