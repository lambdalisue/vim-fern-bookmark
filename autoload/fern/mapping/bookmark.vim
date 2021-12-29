let s:Promise = vital#fern_bookmark#import('Async.Promise')

function! fern#mapping#bookmark#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-save-as-bookmark) :<C-u>call <SID>call('save_as_bookmark')<CR>

  if !a:disable_default_mappings && !g:fern#mapping#bookmark#disable_default_mappings
    nmap <buffer> B <Plug>(fern-action-save-as-bookmark)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ 'fern#mapping#call',
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_save_as_bookmark(helper) abort
  let nodes = a:helper.sync.get_selected_nodes()
  for node in nodes
    if empty(node.bufname)
      return s:Promise.reject(printf('%s is not bookmarkable node', node.name))
    endif
  endfor
  let tree = fern#scheme#bookmark#store#read()

  for node in nodes
    let path = fern#internal#filepath#to_slash(node.bufname)
    let name = fern#internal#path#basename(path)
    call fern#scheme#dict#tree#create(tree, name, node.bufname)
  endfor
  call fern#scheme#bookmark#store#write(tree)
  return s:Promise.resolve()
        \.then({ -> a:helper.async.update_marks([]) })
        \.then({ -> a:helper.async.redraw() })
        \.then({ -> a:helper.sync.echo(printf('%d nodes are saved as bookmarks', len(nodes))) })
endfunction

let g:fern#mapping#bookmark#disable_default_mappings = get(g:, 'fern#mapping#bookmark#disable_default_mappings', 0)
