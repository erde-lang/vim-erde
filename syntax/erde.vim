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
" This is also applied to erdeParens to cover the case of wrapped expressions
" and function calls.
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
  \ erdeKeyword,erdeComment,erdeName,erdeDotIndex,erdeOperator,
  \ erdeStdModule,erdeStdFunction,erdeStdProperty,
  \ erdeConstant,erdeSelf,erdeNil,erdeBoolean,
  \ erdeInt,erdeHex,erdeFloat,
  \ erdeSingleQuoteString, erdeDoubleQuoteString, erdeLongString,
  \ erdeArrowFunction,erdeFunction,
  \ erdeTable

" -------------------------------------
" Names
"
" Need to define this first, as it is often overridden (keywords, function call,
" function definition, table keys, etc).
" -------------------------------------

syntax match erdeName '\h\w*'
  \ skipwhite skipempty nextgroup=erdeDotIndex,erdeBlock

syntax match erdeConstant '[A-Z_][A-Z0-9_]*'
  \ skipwhite skipempty nextgroup=erdeDotIndex,erdeBlock

syntax match erdeDotIndex '\%(\.\.\)\@<!\.\@<=\h\w*'
  \ skipwhite skipempty nextgroup=erdeDotIndex,erdeBlock

" -------------------------------------
" Punctuation
" -------------------------------------

syntax match erdeOperator '[!#~|&<>=+*/%^-]\|\.\{2,3}\|->\|=>'

syntax region erdeParens start='(' end=')' transparent
  \ contains=@erdeExpr,erdeParens
  \ skipwhite skipempty nextgroup=erdeBlock

syntax region erdeBracketGroup matchgroup=erdeBrackets start='\[' end=']' transparent
  \ contains=@erdeExpr,erdeParens
  \ skipwhite skipempty nextgroup=erdeBlock

" -------------------------------------
" Comments
" -------------------------------------

syntax region erdeComment start='--' end='$'
  \ contains=erdeCommentTags
syntax region erdeComment start='--\[\z(=*\)\['  end='\]\z1\]'
  \ contains=erdeCommentTags
syntax keyword erdeCommentTags NOTE TODO FIXME XXX TBD
  \ contained
syntax region erdeShebang start='^#!' end='$'

" -------------------------------------
" Keywords
" -------------------------------------

call s:ErdeKeywords('erdeKeyword', '', ['break', 'catch', 'continue', 'elseif', 'for', 'function', 'goto', 'if', 'in', 'return', 'until', 'while'])
call s:ErdeKeywords('erdeKeyword', 'erdeBlock', ['do', 'else', 'repeat', 'try'])
call s:ErdeKeywords('erdeScope', '', ['local', 'global', 'module'])
syntax keyword erdeSelf self
  \ skipwhite skipempty nextgroup=erdeDotIndex,erdeBlock

" -------------------------------------
" Stdlib
" -------------------------------------

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
endif

" -------------------------------------
" Types
" -------------------------------------

syntax keyword erdeNil nil
  \ skipwhite skipempty nextgroup=erdeBlock

syntax keyword erdeBoolean true false
  \ skipwhite skipempty nextgroup=erdeBlock

syntax match erdeInt '\<\d\+\>'
  \ skipwhite skipempty nextgroup=erdeBlock
syntax match erdeHex '\<0[xX]\%([[:xdigit:]]*\.\)\=[[:xdigit:]]\+\%([pP][-+]\=\d\+\)\=\>'
  \ skipwhite skipempty nextgroup=erdeBlock
syntax match erdeFloat '\<\d*\.\=\d\+\%([eE][-+]\=\d\+\)\=\>'
  \ skipwhite skipempty nextgroup=erdeBlock
syntax match erdeFloat '\.\d\+\%([eE][-+]\=\d\+\)\=\>'
  \ skipwhite skipempty nextgroup=erdeBlock

syntax match erdeEscapeChar /\\[\\abfnrtvz'"]\|\\x[[:xdigit:]]\{2}\|\\[[:digit:]]\{1,3}/
  \ contained
syntax region erdeInterpolation matchgroup=erdeInterpolationBraces start='\%([^\\]\)\@<={' end='}'
  \ contained contains=@erdeExpr
syntax region erdeSingleQuoteString start="'" end="'\|$" skip="\\\\\|\\'"
  \ contains=erdeEscapeChar
  \ skipwhite skipempty nextgroup=erdeBlock
syntax region erdeDoubleQuoteString start='"' end='"\|$' skip='\\\\\|\\"'
  \ contains=erdeEscapeChar,erdeInterpolation
  \ skipwhite skipempty nextgroup=erdeBlock
syntax region erdeLongString start="\[\z(=*\)\[" end="\]\z1\]"
  \ contains=erdeEscapeChar,erdeInterpolation
  \ skipwhite skipempty nextgroup=erdeBlock

syntax region erdeFunctionParams matchgroup=erdeParens start='(' end=')' contained
  \ contains=@erdeExpr
  \ skipwhite skipempty nextgroup=erdeBlock
syntax match erdeFunction '\h\w*\(?\=(\)\@='
  \ skipwhite skipempty nextgroup=erdeFunctionParams
syntax match erdeArrowFunction '\%((.*)\|{.*}\|\|\[.*\]\|\h\w*\)\s*\%(->\|=>\)'
  \ transparent contains=erdeMapDestructure,erdeArrayDestructure,@erdeExpr
  \ skipwhite skipempty nextgroup=erdeBlock,@erdeExpr

" Need to define this after erdeStdFunction / erdeStdModule so we don't
" highlight table properties that match keywords!
syntax match erdeTableField '\h\w*\s*\%(=\|:\)\@='
  \ transparent contained contains=erdeName
  \ skipwhite skipempty nextgroup=@erdeExpr
syntax region erdeTable matchgroup=erdeTableBraces start='{' end='}'
  \ contains=erdeTableField,@erdeExpr,erdeBracketGroup
  \ skipwhite skipempty nextgroup=erdeBlock

" -------------------------------------
" Destructuring
" -------------------------------------

syntax region erdeMapDestructure matchgroup=erdeBraces start='{' end='}'
  \ contained contains=@erdeExpr
  \ skipwhite skipempty nextgroup=@erdeExpr

syntax region erdeArrayDestructure matchgroup=erdeBrackets start='\[' end=']'
  \ contained contains=@erdeExpr
  \ skipwhite skipempty nextgroup=@erdeExpr

syntax match erdeCatch '\%(catch\)\@<=\s*\(\%({.*}\|\[.*\]\|\h\w*\)\s*\)\?{\@='
  \ transparent contains=erdeMapDestructure,erdeArrayDestructure,@erdeExpr
  \ skipwhite skipempty nextgroup=erdeBlock

" -------------------------------------
" Block
"
" Need to define this after erdeMapDestructure to give it precedence in the case 
" that both are matched (for example in erdeArrowFunction's nextgroup).
" -------------------------------------

syntax region erdeBlock matchgroup=erdeBraces start='{' end='}'
  \ contained contains=TOP

" ------------------------------------------------------------------------------
" Highlighting
"
" @see :h group-name
" ------------------------------------------------------------------------------

" Names
hi def link erdeName Noise
hi def link erdeConstant Constant
hi def link erdeDotIndex Constant

" Punctuation
hi def link erdeOperator Operator
hi def link erdeBrackets Noise
hi def link erdeBraces Noise

" Comments
hi def link erdeComment Comment
hi def link erdeCommentTags Todo
hi def link erdeShebang Comment

" Keywords
hi def link erdeKeyword Keyword
hi def link erdeScope Type
hi def link erdeSelf Special

" Stdlib
hi def link erdeStdFunction Constant
hi def link erdeStdModule Type
hi def link erdeStdProperty Constant 

" Types
hi def link erdeNil Boolean
hi def link erdeBoolean Boolean
hi def link erdeInt Number
hi def link erdeHex Number
hi def link erdeFloat Float
hi def link erdeEscapeChar SpecialChar
hi def link erdeSingleQuoteString String
hi def link erdeDoubleQuoteString String
hi def link erdeLongString String
hi def link erdeInterpolationBraces Special
hi def link erdeFunction Function
hi def link erdeTableBraces Structure

" ------------------------------------------------------------------------------
" Teardown
" ------------------------------------------------------------------------------

let b:current_syntax = 'erde'
if main_syntax == 'erde'
  unlet main_syntax
endif
