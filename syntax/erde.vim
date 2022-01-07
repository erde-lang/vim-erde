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

function s:ErdeKeywords(groupName, nextGroup, keywords)
  let cmd = 'syntax match ' . a:groupName . ' "\([.:]\)\@<!\<\(' . join(a:keywords, '\|') . '\)\>"'

  if strlen(a:nextGroup) > 0
    let cmd = cmd . ' skipwhite skipempty nextgroup=' . a:nextGroup
  endif

  exec cmd
endfunction

function s:ErdeStdProperties(name, properties)
  exec 'syntax match erdeStdProperty "\(\([.:]\)\@<!\<' . a:name . '\.\)\@<=\(' . join(a:properties, '\|') . '\)\>"'
endfunction

" ------------------------------------------------------------------------------
" Syntax
"
" Order matters here! Rules defined later will take precedence other those 
" before it.
" ------------------------------------------------------------------------------

syntax cluster erdeExpr contains=
  \ erdeComment,erdeName,erdeDotIndex,erdeOperator,
  \ erdeStdModule,erdeStdFunction,erdeStdProperty,
  \ erdeConstant,erdeSelf,erdeBuiltIn,
  \ erdeInt,erdeHex,erdeFloat,
  \ erdeShortString,erdeLongString,
  \ erdeFunctionCall,erdeArrowFunction,erdeArrowFunctionOperator,
  \ erdeTable

" Names
"
" Need to define this first, as it is often overridden (function call,
" function definition, table keys, etc).

syntax match erdeName '\h\w*' skipwhite skipempty nextgroup=erdeDotIndex,erdeBlock
syntax match erdeDotIndex '\%(\.\.\)\@<!\.\@<=\h\w*' skipwhite skipempty nextgroup=erdeDotIndex,erdeBlock

hi def link erdeDotIndex Constant

" Operators

syntax match erdeOperator '[#~|&<>=+*/%^:.?-]'
hi def link erdeOperator Operator

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

" Language Constants

syntax keyword erdeConstant _G _VERSION _ENV skipwhite skipempty nextgroup=erdeBlock
syntax keyword erdeSelf self skipwhite skipempty nextgroup=erdeBlock
syntax keyword erdeBuiltIn nil true false skipwhite skipempty nextgroup=erdeBlock

hi def link erdeConstant Constant
hi def link erdeSelf Special
hi def link erdeBuiltIn Boolean

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

syntax match erdeTableKey '\h\w*\s*=\@=' contained
syntax region erdeTable matchgroup=erdeTableBraces start='{' end='}'
  \ contains=erdeTableKey,@erdeExpr
  \ skipwhite skipempty nextgroup=erdeBlock

hi def link erdeTableKey Constant
hi def link erdeTableBraces Structure

" Functions

syntax match erdeFunctionCall '\h\w*\s*(\@='
  \ skipwhite skipempty nextgroup=erdeParens

call s:ErdeKeywords('erdeFunctionKeyword', 'erdeFunction', ['function'])
syntax match erdeFunction '\(\h\w*\.\)*\(\h\w*:\)\=\h\w*\s*(\@='
  \ contained skipwhite skipempty nextgroup=erdeFunctionParams
syntax region erdeFunctionParams start='(' end=')' contained
  \ contains=erdeNameDeclaration,erdeDestructure,@erdeExpr
  \ skipwhite skipempty nextgroup=erdeBlock

hi def link erdeFunctionCall Function
hi def link erdeFunctionKeyword Keyword
hi def link erdeFunction Function

" Arrow Functions

syntax match erdeArrowFunctionOperator '\%(->\|=>\)'
syntax match erdeArrowFunction '\%((.*)\|{.*}\|\h\w*\)\s*\%(->\|=>\)' transparent
  \ contains=erdeNameDeclaration,erdeDestructure,@erdeExpr
  \ skipwhite skipempty nextgroup=erdeBlock,@erdeExpr

hi def link erdeArrowFunctionOperator Operator

" Declarations

call s:ErdeKeywords('erdeScope', '', ['local', 'module', 'global'])
syntax match erdeNameDeclaration '\h\w*' contained

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

" Stdlib

if !exists('g:erde_disable_stdlib_syntax') || g:erde_disable_stdlib_syntax != 1
  call s:ErdeKeywords('erdeStdFunction', '', [
    \ 'assert',
    \ 'collectgarbage',
    \ 'dofile',
    \ 'error',
    \ 'getfenv',
    \ 'getmetatable',
    \ 'ipairs',
    \ 'loadfile',
    \ 'loadstring',
    \ 'next',
    \ 'pairs',
    \ 'pcall',
    \ 'print',
    \ 'rawequal',
    \ 'rawget',
    \ 'rawset',
    \ 'require',
    \ 'select',
    \ 'setfenv',
    \ 'setmetatable',
    \ 'tonumber',
    \ 'tostring',
    \ 'type',
    \ 'unpack',
    \ 'xpcall',
  \])

  syntax match erdeStdModule '\([.:]\)\@<!\(coroutine\|debug\|io\|math\|os\|package\|string\|table\)'
  call s:ErdeStdProperties('coroutine', ['create', 'resume', 'running', 'status', 'wrap', 'yield' ])
  call s:ErdeStdProperties('debug', ['debug', '[gs]etfenv', '[gs]ethook', 'getinfo', '[gs]etlocal', '[gs]etmetatable', 'getregistry', '[gs]etupvalue', 'traceback'])
  call s:ErdeStdProperties('io', ['close', 'flush', 'input', 'lines', 'open', 'output', 'popen', 'read', 'tmpfile', 'type', 'write'])
  call s:ErdeStdProperties('math', ['abs', 'acos', 'asin', 'atan2?', 'ceil', 'cosh?', 'deg', 'exp', 'floor', 'fmod', 'frexp', 'ldexp', 'log', 'log10', 'max', 'min', 'modf', 'pow', 'rad', 'random', 'randomseed', 'sinh?', 'sqrt', 'tanh'])
  call s:ErdeStdProperties('os', ['clock', 'date', 'difftime', 'execute', 'exit', 'getenv', 'remove', 'rename', 'setlocale', 'time', 'tmpname'])
  call s:ErdeStdProperties('package', ['cpath', 'loaded', 'loadlib', 'path', 'preload', 'seeall'])
  call s:ErdeStdProperties('string', ['byte', 'char', 'dump', 'find', 'format', 'gmatch', 'gsub', 'len', 'lower', 'match', 'rep', 'reverse', 'sub', 'upper'])
  call s:ErdeStdProperties('table', ['concat', 'insert', 'maxn', 'remove', 'sort'])

  hi def link erdeStdModule Type
  hi def link erdeStdFunction Constant
  hi def link erdeStdProperty Constant 
endif

" Keywords
"
" Need to define this after erdeFunctionCall to give precedence for `catch()`

call s:ErdeKeywords('erdeKeyword', '', ['return', 'if', 'elseif', 'for', 'in', 'break', 'continue', 'while', 'until', 'catch'])
call s:ErdeKeywords('erdeKeyword', 'erdeBlock', ['do', 'else', 'repeat', 'try'])

hi def link erdeKeyword Keyword


" Block
"
" Need to define this after erdeTable to give it precedence in the case that
" both are matched! (for example in erdeArrowFunction's nextgroup)

syntax region erdeBlock matchgroup=erdeBlockBraces start='{' end='}'
  \ contained contains=TOP

hi def link erdeBlockBraces Noise

" ------------------------------------------------------------------------------
" Teardown
" ------------------------------------------------------------------------------

let b:current_syntax = 'erde'
if main_syntax == 'erde'
  unlet main_syntax
endif
