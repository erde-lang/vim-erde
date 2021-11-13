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
syntax region erdeInterpolation start='\%([^\\]\)\@<={' end='}' matchgroup=erdeInterpolationBrace contained contains=@erdeExpr

highlight default link erdeShortString String
highlight default link erdeLongString String
highlight default link erdeInterpolation Identifier
highlight default link erdeInterpolationBrace Special

" ------------------------------------------------------------------------------
" Clusters
" ------------------------------------------------------------------------------

syntax cluster erdeExpr contains=erdeNumber,erdeFloat,erdeShortString

" ------------------------------------------------------------------------------
" Teardown
" ------------------------------------------------------------------------------

let b:current_syntax = 'erde'
if main_syntax == 'erde'
  unlet main_syntax
endif

" :set syntax=vim
