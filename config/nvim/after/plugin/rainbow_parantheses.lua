-- Set RainbowParentheses Plugin to be always on
vim.api.nvim_create_autocmd('VimEnter', {
    command = "RainbowParenthesesToggle",
})
-- vim.cmd("au VimEnter * RainbowParenthesesToggle")
vim.api.nvim_create_autocmd('Syntax', {
    command = "RainbowParenthesesLoadRound"
})
vim.api.nvim_create_autocmd('Syntax', {
    command = "RainbowParenthesesLoadSquare"
})
vim.api.nvim_create_autocmd('Syntax', {
    command = "RainbowParenthesesLoadBraces"
})
-- vim.cmd("au Syntax * RainbowParenthesesLoadRound")
-- vim.cmd("au Syntax * RainbowParenthesesLoadSquare")
-- vim.cmd("au Syntax * RainbowParenthesesLoadBraces")
