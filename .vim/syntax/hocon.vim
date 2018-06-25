" Vim syntax file
" Language: Hocon configuration file
" Maintainer: Zac Campbell
" Latest Revision: 2017 12 17

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'hocon'
endif

let s:cpo_save = &cpo
set cpo&vim

syn keyword hoconBoolean true false
syn keyword hoconNull null

syn match hoconFunction "\(url\|file\|classpath\)\s*("


syn match hoconEmptyString '\"\"'

syn region hoconMultiLineString start='"""' end='""""\@!'

syn match hoconNumber '-\?\(\d\+\|\d*\.\d*\)'

syn region hoconTopLevel start="^[a-z]*\s*=\s*{" end="}" fold

syn region hoconString start='"[^"]' skip='\\"' end='"' contains=hoconStringEscape
syn match hoconStringEscape "\\u[0-9a-fA-F]\{4}" contained
syn match hoconStringEscape "\\[nrfvb\\\"]" contained

syn region hoconVariable start="\${" end="}"

syn match hoconUnquotedString '[a-zA-Z_][a-zA-Z0-9_.-]*'

syn keyword hoconKeyword include nextgroup=hoconString skipwhite

syn case ignore
syn keyword hoconTodo contained TODO FIXME XXX NOTE
syn case match

syn region hoconArray start="\[" end="\]" transparent

syn match hoconComment "\(#\|\/\/\).*$" contains=hoconTodo

syn region hoconObject start="^[a-z]*\s*=\s*{" end="}" transparent fold

syn match hoconKeyValueSep "=\|:\|+="

syn sync fromstart
syn sync maxlines=100

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_hocon_syn_inits")
  if version < 508
    let did_hocon_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink hoconTopLevel        Number
  HiLink hoconTodo            Todo
  HiLink hoconComment         Comment
  HiLink hoconArray           Function
  HiLink hoconObject          Statement
  HiLink hoconEmptyString     String
  HiLink hoconString          String
  HiLink hoconMultiLineString String
  HiLink hoconUnquotedString  Function
  HiLink hoconBoolean         Boolean
  HiLink hoconKeyword         Keyword
  HiLink hoconNull            Keyword
  HiLink hoconKeyValueSep     Keyword
  HiLink hoconNumber          Number
  HiLink hoconVariable        Variable
  HiLink hoconFunction        Variable

  delcommand HiLink
endif


let b:current_syntax = "hocon"
if main_syntax == 'hocon'
  unlet main_syntax
endif
let &cpo = s:cpo_save
unlet s:cpo_save

