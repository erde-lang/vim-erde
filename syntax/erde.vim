" Vim syntax file
" Language: Erde
" URL: https://github.com/erde-lang/vim-erde

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

function s:MatchWords(groupName, keywords)
  exec 'syntax match ' . a:groupName . ' "[.:]\@<!\<\%(' . join(a:keywords, '\|') . '\)\>"'
endfunction

" ------------------------------------------------------------------------------
" Surrounds
" ------------------------------------------------------------------------------

syntax region erdeParenGroup matchgroup=erdeParens start='(' end=')' contains=TOP
syntax region erdeBracketGroup matchgroup=erdeBrackets start='\[' end=']' contains=TOP
syntax region erdeBracesGroup matchgroup=erdeBraces start='{' end='}' contains=TOP

" ------------------------------------------------------------------------------
" Comments
" ------------------------------------------------------------------------------

syntax region erdeShebang start='^#!' end='$'
syntax region erdeComment start='--' end='$' contains=erdeCommentTags
syntax region erdeComment start='--\[\z(=*\)\['  end='\]\z1\]' contains=erdeCommentTags
syntax keyword erdeCommentTags NOTE TODO FIXME XXX TBD contained

" ------------------------------------------------------------------------------
" Keywords
" ------------------------------------------------------------------------------

call s:MatchWords('erdeKeyword', [ 'break', 'continue', 'do', 'else', 'elseif', 'for', 'function', 'goto', 'if', 'in', 'repeat', 'return', 'until', 'while' ])
call s:MatchWords('erdeScope', [ 'global', 'local', 'module' ])
call s:MatchWords('erdeSelf', [ 'self' ])

if !exists('g:erde_disable_stdlib_syntax') || g:erde_disable_stdlib_syntax != 1
  call s:MatchWords('erdeStdModule', ['bit32', 'coroutine', 'debug', 'io', 'math', 'os', 'package', 'string', 'table', 'utf8'])
endif

" ------------------------------------------------------------------------------
" Constants / Builtins
" ------------------------------------------------------------------------------

syntax match erdeConstant '\<[A-Z_][A-Z0-9_]*\>'
syntax keyword erdeNil nil
syntax keyword erdeBoolean true false
syntax match erdeVarArgs '\.\@<!\.\{3}\.\@!'

" ------------------------------------------------------------------------------
" Operators
" ------------------------------------------------------------------------------

syntax match erdeOperator '[!~|&<>=+*/%^]'
syntax match erdeOperator '#!\@!' " avoid shebang
syntax match erdeOperator '-\@<!--\@!' " avoid coments
syntax match erdeOperator '\.\@<!\.\{2}\.\@!' " avoid varargs

" ------------------------------------------------------------------------------
" Numbers
" ------------------------------------------------------------------------------

syntax match erdeDecimal '\w\@<!\d*\.\=\d\+\%([eE][-+]\=\d\+\)\='
syntax match erdeHex '\w\@<!0[xX]\%([[:xdigit:]]*\.\)\=[[:xdigit:]]\+\%([pP][-+]\=\d\+\)\='

" ------------------------------------------------------------------------------
" Strings
" ------------------------------------------------------------------------------

syntax match erdeEscapeChar /\\[\\abfnrtvz'"\n]/ contained
syntax match erdeEscapeChar /\\x[[:xdigit:]]\{2}/ contained
syntax match erdeEscapeChar /\\[[:digit:]]\{1,3}/ contained
syntax match erdeEscapeChar /\\u{[[:xdigit:]]\+}/ contained

syntax region erdeInterpolation matchgroup=erdeInterpolationBraces start='\%(\%(^\|[^\\]\)\%(\\\\\)*\)\@<={' end='}'
  \ contained contains=TOP

syntax region erdeSingleQuoteString start="'" end="'\|$"
  \ contains=erdeEscapeChar

syntax region erdeDoubleQuoteString start='"' end='"\|$'
  \ contains=erdeEscapeChar,erdeInterpolation

syntax region erdeBlockString start="\[\z(=*\)\[" end="\]\z1\]"
  \ contains=erdeEscapeChar,erdeInterpolation

" ------------------------------------------------------------------------------
" Goto
" ------------------------------------------------------------------------------

syntax match erdeGotoJump '\%(\<goto\>\s*\)\@<=\h\w*'
syntax match erdeGotoLabel '::\h\w*::'

" ------------------------------------------------------------------------------
" Misc
" ------------------------------------------------------------------------------

syntax match erdeDotIndex '\%(\.\.\)\@<!\.\@<=\h\w*'

" Covers both function calls and function declarations
syntax match erdeFunction '\h\w*(\@='

" ------------------------------------------------------------------------------
" Highlighting
"
" @see :h group-name
" ------------------------------------------------------------------------------

hi def link erdeParens Noise
hi def link erdeBrackets Noise
hi def link erdeBraces Noise

hi def link erdeShebang Comment
hi def link erdeComment Comment
hi def link erdeCommentTags Todo

hi def link erdeKeyword Keyword
hi def link erdeScope Type
hi def link erdeSelf Special
hi def link erdeStdModule Type

hi def link erdeConstant Boolean
hi def link erdeNil Boolean
hi def link erdeBoolean Boolean
hi def link erdeVarArgs Boolean

hi def link erdeOperator Operator

hi def link erdeDecimal Number
hi def link erdeHex Number

hi def link erdeEscapeChar SpecialChar
hi def link erdeInterpolationBraces Special
hi def link erdeSingleQuoteString String
hi def link erdeDoubleQuoteString String
hi def link erdeBlockString String

hi def link erdeGotoJump Special
hi def link erdeGotoLabel Special

hi def link erdeDotIndex Constant
hi def link erdeFunction Function

" ------------------------------------------------------------------------------
" Teardown
" ------------------------------------------------------------------------------

let b:current_syntax = 'erde'
if main_syntax == 'erde'
  unlet main_syntax
endif
