-- SQL Settings

vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4

vim.opt_local.expandtab = true

vim.opt_local.commentstring = "-- %s"

vim.opt_local.fileformat = 'unix'
vim.opt_local.foldmethod = 'syntax'

vim.cmd[[
    autocmd BufEnter *.sql ALEDisable
]]
