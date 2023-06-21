" Vim indent file
" Language: Erde
" URL: https://github.com/erde-lang/vim-erde

" ------------------------------------------------------------------------------
" Setup
" ------------------------------------------------------------------------------

if exists('b:did_indent')
  finish
endif

let b:did_indent = 1

setlocal autoindent
setlocal nosmartindent

setlocal indentexpr=ErdeIndent()
setlocal indentkeys+=<:>,0=},0=)

" Only define the function once.
if exists('*ErdeIndent')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" ------------------------------------------------------------------------------
" Indent
" ------------------------------------------------------------------------------

function s:ErdeSearchPair(lnum, flags)
  let skip = "synIDattr(synID(line('.'), col('.'), 1), 'name') =~# 'erdeComment\\|erdeSingleQuoteString\\|erdeDoubleQuoteString\\|erdeBlockString'"
  return searchpair('\%((\|{\)', '', '\%()\|}\)', a:flags, skip, a:lnum)
endfunction

function s:ErdeCurrentLineIndent(prevlnum)
  let restore_cursor_pos = getpos('.')

  " count how many indents the previous line opens
  call cursor(v:lnum, 1)
  let num_prev_opens = s:ErdeSearchPair(a:prevlnum, 'mrb')

  " count how many indents the current line closes
  call cursor(a:prevlnum, col([a:prevlnum,'$']))
  let num_cur_closes = s:ErdeSearchPair(v:lnum, 'mr')

  " only allow one indent change per line
  let indent_diff = 0
  if num_prev_opens > num_cur_closes
    let indent_diff = 1
  elseif num_prev_opens < num_cur_closes
    let indent_diff = -1
  endif

  call setpos('.', restore_cursor_pos)
  return indent(a:prevlnum) + shiftwidth() * indent_diff
endfunction

function! ErdeIndent()
  let prevlnum = prevnonblank(v:lnum - 1)
  if prevlnum == 0 " top of file
    return 0
  endif

  " don't change indentation for long strings or long comments
  for synid in synstack(v:lnum, 1)
    if synIDattr(synid, 'name') =~# 'erdeBlockString\|erdeComment'
      return -1
    endif
  endfor

  " get lines and strip trailing comments
  let prevl = substitute(getline(prevlnum), '--.*$', '', '')
  let currentl = substitute(getline(v:lnum), '--.*$', '', '')
  let i = s:ErdeCurrentLineIndent(prevlnum)

  " add indentation for index
  let index_chain = '^\v\s*[:.]\h\w*'
  if prevl !~# index_chain
    if currentl =~# index_chain " beginning of chain
      let i += shiftwidth()
    endif
  elseif currentl !~# index_chain " end of chain
    let i -= shiftwidth()
  endif

  return i
endfunction

" ------------------------------------------------------------------------------
" Teardown
" ------------------------------------------------------------------------------

let &cpo = s:cpo_save
unlet s:cpo_save
