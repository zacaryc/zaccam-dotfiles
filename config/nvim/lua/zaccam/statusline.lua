
--  Set statusline
-- vim.cmd('set statusline+=%#warningmsg#')
-- vim.cmd('set statusline+=%{fugitive#statusline()}')
-- vim.cmd('set statusline+=%*')

-- Set Airline Theme
-- vim.cmd[[
--     let g:airline_theme="hybrid"
--     let g:airline_powerline_fonts = 1
--     let g:webdevicons_enable_airline_statusline = 1
-- ]]

-- -- Set this. Airline will handle the rest.
-- vim.cmd("let g:airline#extensions#ale#enabled = 1")

-- vim.cmd[[
--     if !exists('g:airline_symbols')
--         let g:airline_symbols = {}
--     endif
--     let g:airline_symbols.space = " "
-- ]]

-- require('lualine').get_config()
-- require('lualine').setup()
