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

" ------------------------------------------------------------------------------
" Comments
" ------------------------------------------------------------------------------

syntax keyword erdeCommentTags contained NOTE TODO FIXME XXX TBD
syntax region erdeComment start='--' end='$' contains=erdeCommentTags
syntax region erdeComment start='--\[\z(=*\)\['  end='\]\z1\]' contains=erdeCommentTags
syntax region erdeShebang start='^#!' end='$'

" ------------------------------------------------------------------------------
" Types
"
" Boolean
" Nil
" Number
" Float
" ------------------------------------------------------------------------------

syntax keyword erdeBool true false

syntax keyword erdeNil nil

syntax match erdeInt '\<\d\+\>'
syntax match erdeHex '\<0[xX]\%([[:xdigit:]]*\.\)\=[[:xdigit:]]\+\%([pP][-+]\=\d\+\)\=\>'
syntax match erdeFloat '\<\d*\.\=\d\+\%([eE][-+]\=\d\+\)\=\>'
syntax match erdeFloat '\.\d\+\%([eE][-+]\=\d\+\)\=\>'

syntax region erdeShortString start=/\z(["']\)/ end='\z1\|$' skip='\\\\\|\\\z1' contains=erdeInterpolation
syntax match  erdeLongString '\<\K\k*\>\%(\_s*`\)\@=' skipwhite skipempty nextgroup=erdeLongString
syntax region erdeLongString start="\[\z(=*\)\[" end="\]\z1\]" contains=erdeInterpolation
syntax region erdeInterpolation start='\%([^\\]\)\@<={' end='}' contained

" ------------------------------------------------------------------------------
" Scopes
" ------------------------------------------------------------------------------

syntax keyword erdeLocal local
syntax keyword erdeGlobal global
syntax keyword erdeModule module

" ------------------------------------------------------------------------------
" Logic Flow
" ------------------------------------------------------------------------------

syntax keyword erdeIf if nextgroup=erdeIfElseCondition
syntax keyword erdeElseIf elseif nextgroup=erdeIfElseCondition
syntax keyword erdeElse else nextgroup=erdeIfElseCondition
syntax match erdeIfElseCondition '[^{]*' contained transparent nextgroup=erdeBlock

syntax keyword erdeDo do skipwhite skipempty nextgroup=erdeBlock
syntax keyword erdeFor for
syntax keyword erdeIn in
syntax keyword erdeBreak break
syntax keyword erdeContinue continue
syntax region erdeRepeatUntil start='\<repeat\>' end='\<until\>' contains=erdeBraces
syntax keyword erdeWhile while
syntax keyword erdeTry try skipwhite skipempty nextgroup=erdeBlock
syntax keyword erdeCatch catch
syntax keyword erdeReturn return

" -----------------------------------------------------------------------------
" Functions
" -----------------------------------------------------------------------------

syntax keyword erdeFunction function
" Enforce function name syntax
syntax match erdeFunctionId 
  \ '\%(\<function\>\s*\)\@<=\([a-zA-Z][a-zA-Z0-9]*\.\)*\([a-zA-Z][a-zA-Z0-9]*:\)\=[a-zA-Z][a-zA-Z0-9]*\s*(\@='
syntax match erdeSkinnyArrowFunction '\%(([^)]*)\)\@<=\s*->' skipwhite skipempty nextgroup=@erdeExpr,erdeBlock
syntax match erdeFatArrowFunction '\%(([^)]*)\)\@<=\s*=>' skipwhite skipempty nextgroup=@erdeExpr,erdeBlock
syntax match erdeFunctionCall
  \ '\([a-zA-Z][a-zA-Z0-9]*\.\)*\([a-zA-Z][a-zA-Z0-9]*:\)\=[a-zA-Z][a-zA-Z0-9]*\s*(\@='

" ------------------------------------------------------------------------------
" Blocks
" ------------------------------------------------------------------------------

syntax cluster erdeExpr 
  \ contains=erdeOperator,erdeNumber,erdeFloat,erdeShortString,erdeLongString,erdeSkinnyArrowFunction,erdeFatArrowFunction

syntax cluster erdeStatement
  \ contains=erdeIf,erdeIfElse,erdeElse,erdeReturn
syntax region erdeBlock matchgroup=erdeBlockBraces start='{' end='}' contains=@erdeStatement,@erdeExpr keepend

syntax cluster erdeLoopStatement
  \ contains=@erdeStatement,erdeBreak,erdeContinue
syntax region erdeLoopBlock start='{' end='}' keepend
  \ contains=@erdeLoopStatement,@erdeExpr

" -----------------------------------------------------------------------------
" Tables
" -----------------------------------------------------------------------------

syntax match erdeInlineKey ':[a-zA-Z][a-zA-Z0-9]*' contained
syntax match erdeNameKey '[a-zA-Z][a-zA-Z0-9]*\s*=\@=' contained
syntax region erdeExprKey matchgroup=erdeExprKeyBrackets start='\[' end='\]' contains=@erdeExpr

syntax region erdeTable matchgroup=erdeTableBraces start='{' end='}' contains=erdeInlineKey,erdeNameKey,erdeExprKey,@erdeExpr keepend

" ------------------------------------------------------------------------------
" Highlighting
"
" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
" ------------------------------------------------------------------------------

if version >= 508 || !exists('did_erde_syn_inits')
  if version < 508
    let did_erde_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " Operators
  HiLink erdeOperator Operator

  " Comments
  HiLink erdeComment Comment
  HiLink erdeCommentTags Todo
  HiLink erdeShebang Comment

  " Types
  HiLink erdeBool Boolean
  HiLink erdeNil Type
  HiLink erdeInt Number
  HiLink erdeHex Number
  HiLink erdeFloat Float
  HiLink erdeShortString String
  HiLink erdeLongString String
  HiLink erdeInterpolation Noise

  " Scopes
  HiLink erdeLocal Type
  HiLink erdeModule Type
  HiLink erdeGlobal Type

  " Logic Flow
  HiLink erdeIf Keyword
  HiLink erdeElseIf Keyword
  HiLink erdeElse Keyword

  HiLink erdeFor Keyword
  HiLink erdeIn Keyword
  HiLink erdeBreak Keyword
  HiLink erdeContinue Keyword

  HiLink erdeDo Keyword
  HiLink erdeTry Keyword
  HiLink erdeCatch Keyword
  HiLink erdeRepeatUntil Keyword
  HiLink erdeReturn Keyword
  HiLink erdeWhile Keyword

  " Functions
  HiLink erdeFunction Keyword
  HiLink erdeFunctionId Function
  HiLink erdeFunctionCall Function
  HiLink erdeSkinnyArrowFunction Operator
  HiLink erdeFatArrowFunction Operator

  " Blocks
  HiLink erdeBlockBraces Noise

  " Tables
  HiLink erdeInlineKey Special
  HiLink erdeNameKey Special
  HiLink erdeExprKeyBrackets Special
  HiLink erdeTableBraces Structure

  delcommand HiLink
end

" ------------------------------------------------------------------------------
" Teardown
" ------------------------------------------------------------------------------

let b:current_syntax = 'erde'
if main_syntax == 'erde'
  unlet main_syntax
endif

" :set syntax=vim
