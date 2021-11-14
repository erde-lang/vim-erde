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
" Comments
" ------------------------------------------------------------------------------

syntax keyword erdeCommentTags contained TODO FIXME XXX TBD
syntax region erdeComment start='--' end='$' contains=erdeCommentTags
syntax region erdeComment start='---'  end='---' contains=erdeCommentTags
syntax region erdeShebang start='^#!' end='$'

highlight default link erdeCommentTags Todo
highlight default link erdeComment Comment
highlight default link erdeShebang Comment

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

syntax region erdeShortString start=/\z(["']\)/ end='\z1\|$' skip='\\\\\|\\\z1'
syntax match  erdeLongString '\<\K\k*\>\%(\_s*`\)\@=' skipwhite skipempty nextgroup=erdeLongString
syntax region erdeLongString start='`' end='`' skip='\\\\\|\\`\|\\\n' contains=erdeInterpolation
syntax region erdeInterpolation start='\%([^\\]\)\@<={' end='}' contained contains=@erdeExpr

highlight default link erdeShortString String
highlight default link erdeLongString String
highlight default link erdeInterpolation Noise

" ------------------------------------------------------------------------------
" Logic Flow
" ------------------------------------------------------------------------------

syntax keyword erdeIf if skipwhite skipempty nextgroup=erdeExpr
syntax keyword erdeElseIf elseif skipwhite skipempty nextgroup=erdeExpr
syntax keyword erdeElse else skipwhite skipempty nextgroup=erdeBlock

highlight default link erdeIf Keyword
highlight default link erdeElseIf Keyword
highlight default link erdeElse Keyword

syntax keyword erdeDo do skipwhite skipempty nextgroup=erdeBlock
syntax region erdeRepeatUntil start='\<repeat\>' end='\<until\>' contains=erdeBlock nextgroup=erdeExpr
syntax keyword erdeWhile while skipwhite skipempty nextgroup=erdeBlock

highlight default link erdeDo Keyword
highlight default link erdeRepeatUntil Keyword
highlight default link erdeWhile Keyword

syntax keyword erdeIn in
syntax keyword erdeFor for
syntax keyword erdeBreak break
syntax keyword erdeContinue continue

highlight default link erdeIn Keyword
highlight default link erdeFor Keyword
highlight default link erdeBreak Keyword
highlight default link erdeContinue Keyword

syntax keyword erdeReturn return skipwhite skipempty
highlight default link erdeReturn Keyword

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
