let s:Config = vital#fern#import('Config')

function! fern#scheme#bookmark#store#read() abort
  let path = g:fern#scheme#bookmark#store#file
  let path = fnamemodify(path, ':p')
  return json_decode(filereadable(path) ? join(readfile(path), "\n") : '{}')
endfunction

function! fern#scheme#bookmark#store#write(data) abort
  let path = expand(g:fern#scheme#bookmark#store#file)
  let path = fnamemodify(path, ':p')
  call mkdir(fnamemodify(path, ':h'), 'p')
  call writefile([json_encode(a:data)], path)
endfunction


call s:Config.config(expand('<sfile>:p'), {
      \ 'file': '~/.fern/bookmark.json',
      \})
