" Vim syntax file
" Language: Erde
" URL: https://github.com/erde-lang/vim-erde

" ------------------------------------------------------------------------------
" README
"
" Tables vs Blocks
" ----------------
"
" It's difficult to tell Vim the difference between a block and table.
" Consider the following:
"
"   if {} + {} { return {} }
"
" As a workaround for this, we exploit the fact that Terminals will never be
" followed directly by a table and thus such a situation must be a block. In
" the code, this means that all Terminals will have:
"
"   ... skipwhite skipempty nextgroup=erdeBlock
"
" This is also applied to erdeParens to cover the case of wrapped expressions,
" function calls, and `catch() {}`.
" ------------------------------------------------------------------------------

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
  \ @erdeExpr,erdeComment,erdeKeyword,
  \ erdeFunctionCall,erdeFunction,
  \ erdeScope,erdeDeclaration

syntax cluster erdeExpr contains=
  \ erdeName,erdeOperator,erdeBool,erdeNil,
  \ erdeInt,erdeHex,erdeFloat,
  \ erdeShortString,erdeLongString,
  \ erdeFunctionCall,erdeArrowFunction,erdeArrowFunctionOperator,
  \ erdeTable

" Names
"
" Need to define this first, as it is often overridden (function call,
" function definition, table keys, etc).

syntax match erdeName '[a-zA-Z_][a-zA-Z0-9_]*' skipwhite skipempty nextgroup=erdeDotIndex,erdeBlock
syntax match erdeDotIndex '\%(\.\.\)\@<!\.\@<=[a-zA-Z_][a-zA-Z0-9_]*' skipwhite skipempty nextgroup=erdeDotIndex,erdeBlock

hi def link erdeDotIndex Constant

" Operators

syntax match erdeOperator '[#~|&<>=+*/%^:.?-]'
hi def link erdeOperator Operator

" Keywords

syntax keyword erdeKeyword return if elseif for in break continue while until catch
syntax keyword erdeKeyword do else repeat try skipwhite skipempty nextgroup=erdeBlock

hi def link erdeKeyword Keyword

" Surrounds

syntax region erdeParens start='(' end=')' transparent
  \ contains=@erdeExpr,erdeParens
  \ skipwhite skipempty nextgroup=erdeBlock
syntax region erdeBrackets start='\[' end=']' transparent
  \ contains=@erdeExpr,erdeParens
  \ skipwhite skipempty nextgroup=erdeBlock

syntax match erdeError ')'
syntax match erdeError '}'
syntax match erdeError '\]'

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

syntax keyword erdeBool true false skipwhite skipempty nextgroup=erdeBlock
syntax keyword erdeNil nil skipwhite skipempty nextgroup=erdeBlock

hi def link erdeBool Boolean
hi def link erdeNil Type

" Numbers

syntax match erdeInt '\<\d\+\>'
  \ skipwhite skipempty nextgroup=erdeBlock
syntax match erdeHex '\<0[xX]\%([[:xdigit:]]*\.\)\=[[:xdigit:]]\+\%([pP][-+]\=\d\+\)\=\>'
  \ skipwhite skipempty nextgroup=erdeBlock
syntax match erdeFloat '\<\d*\.\=\d\+\%([eE][-+]\=\d\+\)\=\>'
  \ skipwhite skipempty nextgroup=erdeBlock
syntax match erdeFloat '\.\d\+\%([eE][-+]\=\d\+\)\=\>'
  \ skipwhite skipempty nextgroup=erdeBlock

hi def link erdeInt Number
hi def link erdeHex Number
hi def link erdeFloat Float

" Strings
"
" Need to define this after erdeBrackets for precedence!

syntax match erdeEscapeChar contained
  \ /\\[\\abfnrtvz'"{}]\|\\x[[:xdigit:]]\{2}\|\\[[:digit:]]\{,3}/
syntax region erdeInterpolation matchgroup=erdeInterpolationBraces start='\%([^\\]\)\@<={' end='}'
  \ contained contains=@erdeExpr
syntax region erdeShortString start=/\z(["']\)/ end='\z1\|$' skip='\\\\\|\\\z1'
  \ contains=erdeEscapeChar,erdeInterpolation
  \ skipwhite skipempty nextgroup=erdeBlock
syntax region erdeLongString start="\[\z(=*\)\[" end="\]\z1\]"
  \ contains=erdeEscapeChar,erdeInterpolation
  \ skipwhite skipempty nextgroup=erdeBlock

hi def link erdeEscapeChar SpecialChar
hi def link erdeShortString String
hi def link erdeLongString String
hi def link erdeInterpolationBraces Special

" Tables

syntax match erdeTableKey '[a-zA-Z_][a-zA-Z0-9_]*\s*=\@=' contained
syntax region erdeTable matchgroup=erdeTableBraces start='{' end='}'
  \ contains=erdeTableKey,@erdeExpr
  \ skipwhite skipempty nextgroup=erdeBlock

hi def link erdeTableKey Constant
hi def link erdeTableBraces Structure

" Functions

syntax match erdeFunctionCall '[a-zA-Z_][a-zA-Z0-9_]*\s*(\@='
  \ skipwhite skipempty nextgroup=erdeParens

syntax keyword erdeFunctionKeyword function
  \ skipwhite skipempty nextgroup=erdeFunction
syntax match erdeFunction '\([a-zA-Z_][a-zA-Z0-9_]*\.\)*\([a-zA-Z_][a-zA-Z0-9_]*:\)\=[a-zA-Z_][a-zA-Z0-9_]*\s*(\@='
  \ contained skipwhite skipempty nextgroup=erdeFunctionParams
syntax region erdeFunctionParams start='(' end=')' contained
  \ contains=erdeNameDeclaration,erdeDestructure,@erdeExpr
  \ skipwhite skipempty nextgroup=erdeBlock

hi def link erdeFunctionCall Function
hi def link erdeFunctionKeyword Keyword
hi def link erdeFunction Function

" Arrow Functions

syntax match erdeArrowFunctionOperator '\%(->\|=>\)'
syntax match erdeArrowFunction '\%((.*)\|{.*}\|[a-zA-Z_][a-zA-Z0-9_]*\)\s*\%(->\|=>\)' transparent
  \ contains=erdeNameDeclaration,erdeDestructure,@erdeExpr
  \ skipwhite skipempty nextgroup=erdeBlock,@erdeExpr

hi def link erdeArrowFunctionOperator Operator

" Declarations

syntax keyword erdeScope local global module
syntax match erdeNameDeclaration '[a-zA-Z_][a-zA-Z0-9_]*' contained

hi def link erdeScope Type
hi def link erdeNameDeclaration Identifier

syntax region erdeDeclaration start='\%(local\|global\|module\)\@<=\s\+\(function\)\@!' end='\(=\|\n\)\@='
  \ transparent contains=erdeNameDeclaration,erdeDestructure

" Destructure

syntax region erdeArrayDestruct matchgroup=erdeDestructBrackets start='\[' end=']'
  \ contained contains=erdeNameDeclaration
syntax region erdeDestructure matchgroup=erdeDestructBraces start='{' end='}'
  \ contained contains=erdeNameDeclaration,erdeArrayDestruct,@erdeExpr

hi def link erdeDestructBrackets Structure
hi def link erdeDestructBraces Structure

" Block
"
" Need to define this after erdeTable to give it precedence in the case that
" both are matched! (for example in erdeArrowFunction's nextgroup)

syntax region erdeBlock matchgroup=erdeBlockBraces start='{' end='}'
  \ contained contains=@erdeAll

hi def link erdeBlockBraces Noise

" ------------------------------------------------------------------------------
" Teardown
" ------------------------------------------------------------------------------

let b:current_syntax = 'erde'
if main_syntax == 'erde'
  unlet main_syntax
endif
