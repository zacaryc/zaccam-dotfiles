vim.cmd [[
    set runtimepath+=~/.fzf
]]

-- nnoremap <C-P> :FZF<CR>
-- " Open up exec mode with Rg ready
-- nnoremap <C-G> :Rg<Space>
vim.keymap.set('n', '<C-P>', ':FZF<CR>')
vim.keymap.set('n', '<C-G>', ':GitFiles<CR>')
vim.keymap.set('n', '<C-S>', ':Rg<Space>')

-- Customize fzf colors to match your color scheme
--  - fzf#wrap translates this to a set of `--color` options
vim.cmd [[
    let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }
]]
