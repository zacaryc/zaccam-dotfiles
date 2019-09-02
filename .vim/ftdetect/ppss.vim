
" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

autocmd BufNewFile,BufRead *.ppss setfiletype ppss

" vim: sw=2 ts=2 et
