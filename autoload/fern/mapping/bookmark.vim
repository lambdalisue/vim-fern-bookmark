let s:Prompt = vital#fern#import('Prompt')
let s:Promise = vital#fern#import('Async.Promise')

function! fern#mapping#bookmark#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-save-as-bookmark) :<C-u>call <SID>call('save_as_bookmark')<CR>

  if !a:disable_default_mappings && !g:fern_bookmark_disable_default_mappings
    nmap <buffer> B <Plug>(fern-action-save-as-bookmark)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ "fern#internal#mapping#call",
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_save_as_bookmark(helper) abort
  let nodes = a:helper.get_selected_nodes()
  for node in nodes
    if empty(node.bufname)
      return Promise.reject(printf("%s is not bookmarkable node", node.name))
    endif
  endfor
  let tree = fern#scheme#bookmark#store#read()
  for node in nodes
    call fern#scheme#dict#tree#set(
          \ tree,
          \ [fern#lib#url#encode(node.bufname)],
          \ node.bufname,
          \)
  endfor
  call fern#scheme#bookmark#store#write(tree)
  return s:Promise.resolve()
        \.then({ -> fern#message#info(printf("%d nodes are saved as bookmarks", len(nodes))) })
endfunction
