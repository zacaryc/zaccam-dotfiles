function! s:NoCurrent()
   if exists("b:current_syntax")
      unlet b:current_syntax
   endif
endfunction

" include XML syntax
runtime! syntax/xml.vim
call s:NoCurrent()

" include SQL syntax w/ ability to include it elsewhere
syntax include @sql syntax/sql.vim
call s:NoCurrent()

let b:current_syntax='jelly'

syn match sqlCdata +\%(<\1\%(\_s\_[^>]*\)\{-}>\_s*<!\[CDATA\[\_s*\)\@<=\_.\{-}\%(\_s*\]\]>\_s*<\/\(sql:\w\+\)\)\@=+ contains=@sql
syn match sqlRegion +\%(<\1\%(\_s\_[^>]*\)\{-}>\%(\_s*<!\[CDATA\[\)\@!\)\@<=\_.\{-}\%(<\/\(sql:\w\+\)\)\@=+ contains=@sql

syn cluster xmlCdataHook add=sqlCdata
syn cluster xmlRegionHook add=sqlRegion
