" Vim syntax file
" Language: Erde
" URL: https://github.com/erde-lang/vim-erde

" Useful Helps
" :h pattern-atoms

" ------------------------------------------------------------------------------
" Setup
" ------------------------------------------------------------------------------

if !exists('main_syntax')
  if version < 600
    syntax clear
  elseif exists('b:current_syntax')
    finish
  endif
  let main_syntax = 'erde'
endif

syntax sync fromstart ":h :syn-sync-first
syntax case match ":h :syn-case

" ------------------------------------------------------------------------------
" Misc
" ------------------------------------------------------------------------------

syntax region erdeBraces start='{' end='}' matchgroup=erdeBracesMatch
  \ contains=erdeBreak,erdeContinue,erdeReturn,erdeNameKey,erdeExprKey
highlight default link erdeBraces Noise

" ------------------------------------------------------------------------------
" Operators
" This should be defined first, so we don't override other rules.
" ------------------------------------------------------------------------------

" Do not allow arbitrary operator symbol combinations
syntax match erdeOperator "[#~|&<>=+*/%^-]\@<![#~|&<>=+*/%^-]"

syntax match erdeOperator "\.\.\.\="
syntax match erdeOperator "??"
syntax match erdeOperator "=="
syntax match erdeOperator "\~="
syntax match erdeOperator "<="
syntax match erdeOperator ">="
syntax match erdeOperator "\.|"
syntax match erdeOperator "\.&"
syntax match erdeOperator "\.\~"
syntax match erdeOperator "\.<<"
syntax match erdeOperator "\.>>"
syntax match erdeOperator "//"
syntax match erdeOperator ">>"

highlight default link erdeOperator Operator

" ------------------------------------------------------------------------------
" Comments
" ------------------------------------------------------------------------------

syntax keyword erdeCommentTags contained NOTE TODO FIXME XXX TBD
syntax region erdeComment start='--' end='$' contains=erdeCommentTags
syntax region erdeComment start='--\[\z(=*\)\['  end='\]\z1\]' contains=erdeCommentTags
syntax region erdeShebang start='^#!' end='$'

highlight default link erdeCommentTags Todo
highlight default link erdeComment Comment
highlight default link erdeShebang Comment

" ------------------------------------------------------------------------------
" Terminals
" ------------------------------------------------------------------------------

syntax keyword erdeNil nil
syntax keyword erdeBool true false

highlight default link erdeNil Type
highlight default link erdeBool Boolean

" ------------------------------------------------------------------------------
" Numbers
" ------------------------------------------------------------------------------

syntax match erdeInt '\<\d\+\>'
syntax match erdeHex '\<0[xX]\%([[:xdigit:]]*\.\)\=[[:xdigit:]]\+\%([pP][-+]\=\d\+\)\=\>'
syntax match erdeFloat '\<\d*\.\=\d\+\%([eE][-+]\=\d\+\)\=\>'
syntax match erdeFloat '\.\d\+\%([eE][-+]\=\d\+\)\=\>'

highlight default link erdeInt Number
highlight default link erdeHex Number
highlight default link erdeFloat Float

" ------------------------------------------------------------------------------
" Strings
" ------------------------------------------------------------------------------

syntax region erdeShortString start=/\z(["']\)/ end='\z1\|$' skip='\\\\\|\\\z1' contains=erdeInterpolation
syntax match  erdeLongString '\<\K\k*\>\%(\_s*`\)\@=' skipwhite skipempty nextgroup=erdeLongString
syntax region erdeLongString start="\[\z(=*\)\[" end="\]\z1\]" contains=erdeInterpolation
syntax region erdeInterpolation start='\%([^\\]\)\@<={' end='}' contained

highlight default link erdeShortString String
highlight default link erdeLongString String
highlight default link erdeInterpolation Noise

" ------------------------------------------------------------------------------
" Scopes
" ------------------------------------------------------------------------------

syntax keyword erdeLocal local
syntax keyword erdeGlobal global
syntax keyword erdeModule module

highlight default link erdeLocal Type
highlight default link erdeGlobal Type
highlight default link erdeModule Type

" ------------------------------------------------------------------------------
" Logic Flow
" ------------------------------------------------------------------------------

syntax keyword erdeDo do
syntax keyword erdeIf if
syntax keyword erdeElseIf elseif
syntax keyword erdeElse else
syntax keyword erdeFor for
syntax keyword erdeIn in
syntax keyword erdeBreak break
syntax keyword erdeContinue continue
syntax region erdeRepeatUntil start='\<repeat\>' end='\<until\>' contains=erdeBraces
syntax keyword erdeWhile while
syntax keyword erdeTry try
syntax keyword erdeCatch catch
syntax keyword erdeReturn return

highlight default link erdeDo Keyword
highlight default link erdeIf Keyword
highlight default link erdeElseIf Keyword
highlight default link erdeElse Keyword
highlight default link erdeFor Keyword
highlight default link erdeIn Keyword
highlight default link erdeBreak Keyword
highlight default link erdeContinue Keyword
highlight default link erdeRepeatUntil Keyword
highlight default link erdeWhile Keyword
highlight default link erdeTry Keyword
highlight default link erdeCatch Keyword
highlight default link erdeReturn Keyword

" -----------------------------------------------------------------------------
" Tables
" -----------------------------------------------------------------------------

syntax match erdeNameKey '[a-zA-Z][a-zA-Z0-9]*\s*=\@=' contained
syntax region erdeExprKey start='\[' end='\]' matchgroup=erdeExprKeyBrackets

highlight default link erdeExprKeyBrackets Special
highlight default link erdeNameKey Special

" -----------------------------------------------------------------------------
" Functions
" -----------------------------------------------------------------------------

syntax keyword erdeFunction function
" Enforce function name syntax
syntax match erdeFunctionId 
  \ '\%(\<function\>\s*\)\@<=\([a-zA-Z][a-zA-Z0-9]*\.\)*\([a-zA-Z][a-zA-Z0-9]*:\)\=[a-zA-Z][a-zA-Z0-9]*\s*(\@='
syntax match erdeSkinnyArrowFunction '\%(([^)]*)\)\@<=\s*->'
syntax match erdeFatArrowFunction '\%(([^)]*)\)\@<=\s*=>'
syntax match erdeFunctionCall
  \ '\([a-zA-Z][a-zA-Z0-9]*\.\)*\([a-zA-Z][a-zA-Z0-9]*:\)\=[a-zA-Z][a-zA-Z0-9]*\s*(\@='

highlight default link erdeFunction Keyword
highlight default link erdeFunctionId Function
highlight default link erdeFunctionCall Function
highlight default link erdeSkinnyArrowFunction Operator
highlight default link erdeFatArrowFunction Operator

" ------------------------------------------------------------------------------
" Teardown
" ------------------------------------------------------------------------------

let b:current_syntax = 'erde'
if main_syntax == 'erde'
  unlet main_syntax
endif

" :set syntax=vim
