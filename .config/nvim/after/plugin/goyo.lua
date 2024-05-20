vim.cmd [[
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
]]
