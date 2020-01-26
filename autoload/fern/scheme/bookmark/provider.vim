let s:Promise = vital#fern#import('Async.Promise')

let s:STATUS_NONE = g:fern#internal#node#STATUS_NONE

function! fern#scheme#bookmark#provider#new() abort
  let tree = {}
  let provider = fern#scheme#dict#provider#new(tree)
  let provider = extend(provider, {
        \ '_parse_url': funcref('s:parse_url'),
        \ '_update_tree': funcref('s:update_tree'),
        \ '_extend_node': funcref('s:extend_node'),
        \ '_root_name_factory': funcref('s:root_name_factory'),
        \ '_leaf_name_factory': { -> 'bookmark' },
        \ '_branch_name_factory': { -> 'folder' },
        \ '_bookmark_name': '',
        \})
  return provider
endfunction

function! s:parse_url(url) abort dict
  let url = fern#lib#url#parse(a:url)
  let name = matchstr(url.path, '^[^/]*')
  let name = empty(name) ? 'default' : name
  let name = fern#lib#url#decode(name)
  let path = matchstr(url.path, '/\zs.*$')

  " Update tree
  call filter(self._tree, { -> 0 })
  call extend(self._tree, fern#scheme#bookmark#store#read(name))

  " Update bookmark name
  let self._bookmark_name = name

  return split(path, '/')
endfunction

function! s:update_tree(tree) abort dict
  call fern#scheme#bookmark#store#write(self._bookmark_name, a:tree)
endfunction

function! s:extend_node(node) abort dict
  if a:node.status isnot# s:STATUS_NONE
    return extend(a:node, {
          \ 'bufname': printf(
          \   'bookmark:%s/%s',
          \   self._bookmark_name,
          \   join(a:node._path, '/'),
          \ ),
          \})
  endif
  return extend(a:node, {
        \ 'bufname': a:node.concealed._value,
        \})
endfunction

function! s:root_name_factory(...) abort dict
  return self._bookmark_name
endfunction
