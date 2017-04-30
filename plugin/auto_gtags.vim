"=============================================================================
" File: auto-gtags.vim
" Author: zebra
" Created: 2017-02-19
"=============================================================================

scriptencoding utf-8

if exists('g:loaded_auto_gtags')
    finish
endif
let g:loaded_auto_gtags = 1

let s:save_cpo = &cpo
set cpo&vim

augroup auto_gtags
  autocmd!
  autocmd BufWritePost * call auto_gtags#gtags(-1)
augroup END

command! GtagsCreate call auto_gtags#gtags(1)
command! GtagsUpdate call auto_gtags#gtags(0)

let &cpo = s:save_cpo
unlet s:save_cpo
