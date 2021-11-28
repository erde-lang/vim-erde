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
" Util
" ------------------------------------------------------------------------------

syntax match erdeName '[a-zA-Z][a-zA-Z0-9]*'

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
syntax region erdeInterpolation start='\%([^\\]\)\@<={' end='}' contained contains=@erdeExpr

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

syntax keyword erdeDo do skipwhite skipempty nextgroup=erdeBlock
syntax keyword erdeIf if skipwhite skipempty nextgroup=erdeExpr
syntax keyword erdeElseIf elseif skipwhite skipempty nextgroup=erdeExpr
syntax keyword erdeElse else skipwhite skipempty nextgroup=erdeBlock
syntax keyword erdeFor for
syntax keyword erdeIn in
syntax keyword erdeBreak break
syntax keyword erdeContinue continue
syntax region erdeRepeatUntil start='\<repeat\>' end='\<until\>' contains=erdeBlock nextgroup=erdeExpr
syntax keyword erdeWhile while skipwhite skipempty nextgroup=erdeBlock
syntax keyword erdeTry try skipwhite skipempty nextgroup=erdeBlock
syntax keyword erdeCatch catch
syntax keyword erdeReturn return skipwhite skipempty nextgroup=erdeExpr

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



" -----------------------------------------------------------------------------
" Functions
" -----------------------------------------------------------------------------

syntax keyword erdeFunction function
syntax match erdeFunctionId 
  \ '\%(\<function\>\s*\)\@<=\([a-zA-Z][a-zA-Z0-9]*\.\)*\([a-zA-Z][a-zA-Z0-9]*:\)\=[a-zA-Z][a-zA-Z0-9]*\s*(\@='
syntax match erdeFunctionParams
  \ '\%(\<function\>[^(]\+\)\@<=()'

highlight default link erdeFunction Keyword
highlight default link erdeFunctionId Function
highlight default link erdeFunctionParams Special

" ------------------------------------------------------------------------------
" Clusters
" ------------------------------------------------------------------------------

syntax cluster erdeExpr contains=erdeNumber,erdeFloat,erdeShortString
syntax cluster erdeStatement contains=erdeIf,erdeFor,erdeBreak,erdeContinue,erdeReturn
syntax region erdeBlock start='{' end='}' matchgroup=erdeBraces contains=@erdeStatement

highlight default link erdeBraces Noise

" ------------------------------------------------------------------------------
" Teardown
" ------------------------------------------------------------------------------

let b:current_syntax = 'erde'
if main_syntax == 'erde'
  unlet main_syntax
endif

" :set syntax=vim
