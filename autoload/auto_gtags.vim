"=============================================================================
" File: auto-gtags.vim
" Author: zebra
" Created: 2017-02-19
"=============================================================================

scriptencoding utf-8

if !exists('g:loaded_auto_gtags')
    finish
endif
let g:loaded_auto_gtags = 1

let s:save_cpo = &cpo
set cpo&vim

"------------------------
" setting
"------------------------
if !exists("g:auto_gtags")
  let g:auto_gtags = 0
endif

if !exists("g:auto_gtags_directory_list")
  let g:auto_gtags_directory_list = ['.']
endif

if !exists("g:auto_gtags_gpath_name")
  let g:auto_gtags_gpath_name = 'GPATH'
endif

if !exists("g:auto_gtags_grtags_name")
  let g:auto_gtags_grtags_name = 'GRTAGS'
endif

if !exists("g:auto_gtags_gtags_name")
  let g:auto_gtags_gtags_name = 'GTAGS'
endif

if !exists("g:auto_gtags_bin_path")
  let g:auto_gtags_bin_path = 'gtags'
endif

if !exists("g:auto_global_bin_path")
  let g:auto_global_bin_path = 'global'
endif

if !exists("g:auto_gtags_filetype_mode")
  let g:auto_gtags_filetype_mode = 0
endif

if !exists("g:auto_gtags_is_making_str")
  let g:auto_gtags_is_making_str = 'gtags making'
endif

if !exists("g:auto_gtags_is_not_making_str")
  let g:auto_gtags_is_not_making_str = 'gtags free'
endif
"------------------------
" function
"------------------------
function! auto_gtags#get_gtags_path(tags_name)
  let s:path = ''
  for s:directory in g:auto_gtags_directory_list
    if isdirectory(s:directory)
      if g:auto_gtags_filetype_mode > 0
        if &filetype !=# ''
          let a:tags_name = &filetype.'.'.a:tags_name
        endif
      endif
      let s:path = s:directory.'/'.a:tags_name
      break
    endif
  endfor

  return s:path
endfunction

function! auto_gtags#gpath_path()
  return auto_gtags#get_gtags_path(g:auto_gtags_gpath_name)
endfunction

function! auto_gtags#grtags_path()
  return auto_gtags#get_gtags_path(g:auto_gtags_grtags_name)
endfunction

function! auto_gtags#gtags_path()
  return auto_gtags#get_gtags_path(g:auto_gtags_gtags_name)
endfunction

function! auto_gtags#gtags_cmd()
  let s:gtags_cmd = ''
  let s:tags_bin_path = g:auto_gtags_bin_path
  let s:gtags_cmd = s:tags_bin_path.' -v'
  return s:gtags_cmd
endfunction

function! auto_gtags#update_cmd()
  let s:gtags_cmd = ''
  let s:tags_bin_path = g:auto_global_bin_path
  let s:gtags_cmd = s:tags_bin_path.' -uv'
  return s:gtags_cmd
endfunction

function! auto_gtags#gtags(recreate)
  if a:recreate < 0 && g:auto_gtags != 1
    return
  endif

  if auto_gtags#is_making_gtags() == 1
    return
  endif

  if a:recreate > 0
    silent! execute '!rm '.auto_gtags#gpath_path().' 2>/dev/null'
    silent! execute '!rm '.auto_gtags#grtags_path().' 2>/dev/null'
    silent! execute '!rm '.auto_gtags#gtags_path().' 2>/dev/null'
  elseif filereadable(auto_gtags#gtags_path()) == 0
    return
  endif

  if a:recreate > 0
    let s:cmd = auto_gtags#gtags_cmd()
  else
    let s:cmd = auto_gtags#update_cmd()
  endif
  if len(s:cmd) > 0
    silent! execute '!sh -c "'.s:cmd.'" 2>/dev/null &'
  endif

  if a:recreate > 0
    redraw!
  endif
endfunction

function! auto_gtags#is_making_gtags()
  let ps = system('ps')
  return match(ps, 'gtags.*-v') != -1
endfunction

function! auto_gtags#is_making_gtags_str()
  let str = 'none'
  if auto_gtags#is_making_gtags() == 1
    let str = g:auto_gtags_is_making_str
  else
    let str = g:auto_gtags_is_not_making_str
  endif
  return str
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
