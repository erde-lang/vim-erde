function! s:DetectErde()
  if getline(1) =~ '^#!.*\<erde\>'
    set filetype=erde
  endif
endfunction

autocmd BufRead,BufNewFile *.erde set filetype=erde
autocmd BufRead,BufNewFile * call s:DetectErde()
