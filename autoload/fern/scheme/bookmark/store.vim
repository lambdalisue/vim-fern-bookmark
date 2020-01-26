let s:Config = vital#fern#import('Config')

function! fern#scheme#bookmark#store#read(name) abort
  let path = g:fern#scheme#bookmark#store#dir
  let path = fnamemodify(path, ':p')
  let path = path . a:name
  return json_decode(filereadable(path) ? readfile(path) : '{}')
endfunction

function! fern#scheme#bookmark#store#write(name, data) abort
  let path = g:fern#scheme#bookmark#store#dir
  let path = fnamemodify(path, ':p')
  if !isdirectory(path)
    call mkdir(path, 'p')
  endif
  let path = path . a:name
  call writefile([json_encode(a:data)], path)
endfunction


call s:Config.config(expand('<sfile>:p'), {
      \ 'dir': expand('~/.fern/bookmark'),
      \})
