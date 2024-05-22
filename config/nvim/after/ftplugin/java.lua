
vim.cmd [[
    au FileType java setlocal foldmethod=marker
    au FileType java setlocal foldmarker={,} makeprg=javac\ %
]]
