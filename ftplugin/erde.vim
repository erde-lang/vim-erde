if exists("b:did_ftplugin")
	finish
endif

let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

setlocal suffixesadd=.erde
setlocal formatoptions-=t
setlocal comments=:--
setlocal commentstring=--\ %s

let b:undo_ftplugin = "setlocal suffixesadd< formatoptions< comments< commentstring<"

let &cpo = s:cpo_save
