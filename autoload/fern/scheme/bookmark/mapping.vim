let s:Promise = vital#fern#import('Async.Promise')
let s:Prompt = vital#fern#import('Prompt')

function! fern#scheme#bookmark#mapping#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-cd)          :<C-u>call <SID>call('cd', 'cd')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-lcd)         :<C-u>call <SID>call('cd', 'lcd')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-tcd)         :<C-u>call <SID>call('cd', 'tcd')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:system) :<C-u>call <SID>call('open_system')<CR>
  nnoremap <buffer><silent>
        \ <Plug>(fern-action-add-cwd-to-bookmark)
        \ :<C-u>call <SID>call('add_cwd_to_bookmark')<CR>
  nnoremap <buffer><silent>
        \ <Plug>(fern-action-add-previous-buffer-to-bookmark)
        \ :<C-u>call <SID>call('add_previous_buffer_to_bookmark')<CR>

  call fern#scheme#dict#mapping#init(a:disable_default_mappings)

  if !a:disable_default_mappings
    nmap <buffer><nowait> x <Plug>(fern-action-open:system)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ "fern#mapping#call",
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_cd(helper, command) abort
  let node = a:helper.get_cursor_node()
  if node.status isnot# a:helper.STATUS_NONE
    return s:Promise.reject("folder does not have path to cd")
  endif

  let path = node.concealed._value
  let path = filereadable(path) ? fnamemodify(path, ':h') : path

  if a:command ==# 'tcd' && !exists(':tcd')
    let winid = win_getid()
    silent execute printf(
          \ 'keepalt keepjumps %d,%dwindo lcd %s',
          \ 1, winnr('$'), fnameescape(path),
          \)
    call win_gotoid(winid)
  else
    execute a:command fnameescape(path)
  endif
  return s:Promise.resolve()
endfunction

function! s:map_open_system(helper) abort
  let node = a:helper.get_cursor_node()
  if node.status isnot# a:helper.STATUS_NONE
    return s:Promise.reject("folder does not have path to cd")
  endif
  let Done = a:helper.process_node(node)
  let path = node.concealed._value
  return fern#scheme#file#shutil#open(path, a:helper.fern.source.token)
        \.then({ -> fern#message#info(printf('%s has opened', path)) })
        \.finally({ -> Done() })
endfunction

function! s:map_add_cwd_to_bookmark(helper) abort
  let provider = a:helper.fern.provider
  let value = printf('fern:file://%s', fnamemodify(getcwd(), ':p:gs?\\?/?'))

  let path = s:Prompt.ask('New bookmark: ', fnamemodify(value, ':h'))
  if empty(path)
    return s:Promise.reject('Cancelled')
  endif
  let path = split(path, '/')

  " Get parent node of a new bookmark
  let node = a:helper.get_cursor_node()
  let node = node.status isnot# a:helper.STATUS_EXPANDED ? node.__owner : node

  " Update tree
  call fern#scheme#dict#tree#set(node.concealed._value, path, value, {
        \ 'create_parents': 1,
        \})
  call provider._update_tree(provider._tree)

  " Update UI
  let key = node.__key + path
  let previous = a:helper.get_cursor_node()
  return s:Promise.resolve()
        \.then({ -> a:helper.reload_node(node.__key) })
        \.then({ -> a:helper.reveal_node(key) })
        \.then({ -> a:helper.redraw() })
        \.then({ -> a:helper.focus_node(key, { 'previous': previous }) })
endfunction

function! s:map_add_previous_buffer_to_bookmark(helper) abort
  let provider = a:helper.fern.provider
  let value = bufname(winbufnr(winnr('#')))

  let path = s:Prompt.ask('New bookmark: ', 'prev')
  if empty(path)
    return s:Promise.reject('Cancelled')
  endif
  let path = split(path, '/')

  " Get parent node of a new bookmark
  let node = a:helper.get_cursor_node()
  let node = node.status isnot# a:helper.STATUS_EXPANDED ? node.__owner : node

  " Update tree
  call fern#scheme#dict#tree#set(node.concealed._value, path, value, {
        \ 'create_parents': 1,
        \})
  call provider._update_tree(provider._tree)

  " Update UI
  let key = node.__key + path
  let previous = a:helper.get_cursor_node()
  return s:Promise.resolve()
        \.then({ -> a:helper.reload_node(node.__key) })
        \.then({ -> a:helper.reveal_node(key) })
        \.then({ -> a:helper.redraw() })
        \.then({ -> a:helper.focus_node(key, { 'previous': previous }) })
endfunction
