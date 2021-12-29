let s:Prompt = vital#fern_bookmark#import('Prompt')
let s:Promise = vital#fern_bookmark#import('Async.Promise')

let s:STATUS_NONE = g:fern#STATUS_NONE

function! fern#scheme#bookmark#provider#new() abort
  let tree = fern#scheme#bookmark#store#read()
  let provider = fern#scheme#dict#provider#new(tree)
  let provider = extend(provider, {
        \ '_parse_url': funcref('s:parse_url'),
        \ '_update_tree': function('fern#scheme#bookmark#store#write'),
        \ '_extend_node': funcref('s:extend_node'),
        \ '_prompt_leaf': funcref('s:prompt', ['bookmark']),
        \ '_prompt_branch': funcref('s:prompt', ['bookmark folder']),
        \ '_default_leaf': { h, n, p -> fern#scheme#bookmark#util#decode(p) },
        \})
  return provider
endfunction

function! s:parse_url(url) abort dict
  let url = fern#fri#parse(a:url)
  return split(url.path, '/')
endfunction

function! s:extend_node(node) abort dict
  let label = a:node._path ==# '/'
        \ ? printf(
        \   'Bookmarks (%s)',
        \   fnamemodify(g:fern#scheme#bookmark#store#file, ':~'),
        \ )
        \ : a:node.label
  let bufname = a:node.status is# s:STATUS_NONE
        \ ? a:node.concealed._value
        \ : printf('bookmark://%s', a:node._path)
  return extend(a:node, {
        \ 'label': label,
        \ 'bufname': bufname,
        \})
endfunction

function! s:prompt(label, helper) abort
  let path = s:Prompt.ask(printf('New %s: ', a:label), '')
  if empty(path)
    throw 'Cancelled'
  endif
  " NOTE: Escape path so that / is available in path
  return fern#scheme#bookmark#util#encode(path)
endfunction
