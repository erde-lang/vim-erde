" Vim syntax file
" Language: Erde
" URL: https://github.com/erde-lang/vim-erde

if !exists('main_syntax')
  if version < 600
    syntax clear
  elseif exists('b:current_syntax')
    finish
  endif
  let main_syntax = 'erde'
endif

let b:current_syntax = 'erde'
if main_syntax == 'erde'
  unlet main_syntax
endif
