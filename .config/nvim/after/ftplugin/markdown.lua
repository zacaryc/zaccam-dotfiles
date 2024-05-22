vim.cmd [[
        au BufNewFile,BufRead *.md setlocal filetype=markdown
        au BufNewFile,BufRead *.m*down setlocal filetype=markdown
        au FileType markdown map <buffer> <localleader>g :Goyo<CR>
]]

    vim.opt_local.foldlevel = 1
    vim.opt_local.spell = true
