function! fern#scheme#bookmark#util#encode(str) abort
  return substitute(a:str, '/', '%2F', 'g')
endfunction

function! fern#scheme#bookmark#util#decode(str) abort
  return substitute(a:str, '%2F', '/', 'g')
endfunction

