" Vim syntax file
" Language: Erde
" URL: https://github.com/erde-lang/vim-erde

" Helpful Helps
" :h group-name
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
" Syntax
"
" Order matters here! Rules defined later will take precedence other those 
" before it.
" ------------------------------------------------------------------------------

syntax cluster erdeAll contains=
  \ @erdeExpr,erdeKeyword,erdeFunction,erdeScope,erdeDeclaration

syntax cluster erdeExpr contains=
  \ erdeOperator,erdeBool,erdeNil,erdeInt,erdeHex,erdeFloat,
  \ erdeShortString,erdeLongString,
  \ erdeSkinnyArrowFunction,erdeFatArrowFunction,
  \ erdeBlock

" Keywords

syntax keyword erdeKeyword
  \ if elseif else do for in break continue repeat until while try catch return

hi def link erdeKeyword Keyword

" Operators

syntax match erdeOperator '[#~|&<>=+*/%^:.?-]'

hi def link erdeOperator Operator

" Surrounds

syntax region erdeParens start='(' end=')' transparent contains=@erdeExpr
syntax region erdeBrackets matchgroup=erdeOperator start='\[' end=']' transparent
syntax region erdeOptParens matchgroup=erdeOperator start='?(' end=')' transparent

syntax region erdeBlock matchgroup=erdeBraces start='{' end='}' contains=@erdeAll

syntax match erdeError ')'
syntax match erdeError '}'
syntax match erdeError '\]'

hi def link erdeBraces Structure
hi def link erdeError Error

" Comments

syntax keyword erdeCommentTags contained NOTE TODO FIXME XXX TBD
syntax region erdeComment start='--' end='$' contains=erdeCommentTags
syntax region erdeComment start='--\[\z(=*\)\['  end='\]\z1\]' contains=erdeCommentTags
syntax region erdeShebang start='^#!' end='$'

hi def link erdeCommentTags Todo
hi def link erdeComment Comment
hi def link erdeShebang Comment

" Bool / Nil

syntax keyword erdeBool true false
syntax keyword erdeNil nil

hi def link erdeBool Boolean
hi def link erdeNil Type

" Numbers

syntax match erdeInt '\<\d\+\>'
syntax match erdeHex '\<0[xX]\%([[:xdigit:]]*\.\)\=[[:xdigit:]]\+\%([pP][-+]\=\d\+\)\=\>'
syntax match erdeFloat '\<\d*\.\=\d\+\%([eE][-+]\=\d\+\)\=\>'
syntax match erdeFloat '\.\d\+\%([eE][-+]\=\d\+\)\=\>'

hi def link erdeInt Number
hi def link erdeHex Number
hi def link erdeFloat Float

" Strings

syntax match erdeEscapeChar contained
  \ /\\[\\abfnrtvz'"{}]\|\\x[[:xdigit:]]\{2}\|\\[[:digit:]]\{,3}/
syntax region erdeShortString start=/\z(["']\)/ end='\z1\|$' skip='\\\\\|\\\z1'
  \ contains=erdeEscapeChar,erdeInterpolation
syntax region erdeLongString start="\[\z(=*\)\[" end="\]\z1\]"
  \ contains=erdeEscapeChar,erdeInterpolation
syntax region erdeInterpolation matchgroup=erdeInterpolationBraces start='\%([^\\]\)\@<={' end='}'
  \ contained contains=@erdeExpr

hi def link erdeEscapeChar SpecialChar
hi def link erdeShortString String
hi def link erdeLongString String
hi def link erdeInterpolationBraces Special

" Functions

syntax match erdeFunctionCall '[a-zA-Z][a-zA-Z0-9]*\s*(\@='

syntax keyword erdeFunction function skipwhite skipempty nextgroup=erdeFunctionId
syntax match erdeFunctionId '\([a-zA-Z][a-zA-Z0-9]*\.\)*\([a-zA-Z][a-zA-Z0-9]*:\)\=[a-zA-Z][a-zA-Z0-9]*\s*(\@='
  \ contained skipwhite skipempty nextgroup=erdeFunctionParams
syntax region erdeFunctionParams start='(' end=')' contained
  \ contains=erdeName,erdeDestructure,@erdeExpr

hi def link erdeFunctionCall Function
hi def link erdeFunction Keyword
hi def link erdeFunctionId Function

" Arrow Functions

syntax match erdeSkinnyArrowFunction '->'
syntax match erdeFatArrowFunction '=>'
syntax match erdeArrowFunctionParams '(.*)\s*\%(->\|=>\)\@=' transparent
  \ skipwhite skipempty nextgroup=erdeSkinnyArrowFunction,erdeFatArrowFunction
  \ contains=erdeName,erdeDestructure,@erdeExpr

hi def link erdeSkinnyArrowFunction Operator
hi def link erdeFatArrowFunction Operator

" Declarations

syntax keyword erdeScope local global module
syntax match erdeName '[a-zA-Z][a-zA-Z0-9]*' contained

hi def link erdeScope Type
hi def link erdeName Identifier

syntax region erdeDeclaration start='\%(local\|global\|module\)\@<=\s\+\(function\)\@!' end='=\@='
  \ transparent contains=erdeName,erdeDestructure

" Destructure

syntax region erdeArrayDestruct matchgroup=erdeDestructBrackets start='\[' end=']'
  \ contained contains=erdeName
syntax region erdeDestructure matchgroup=erdeBraces start='{' end='}'
  \ contained contains=erdeName,erdeArrayDestruct,@erdeExpr

hi def link erdeDestructBrackets Structure

" ------------------------------------------------------------------------------
" Teardown
" ------------------------------------------------------------------------------

let b:current_syntax = 'erde'
if main_syntax == 'erde'
  unlet main_syntax
endif

" :set syntax=vim
