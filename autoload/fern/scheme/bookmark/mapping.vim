let s:Promise = vital#fern#import('Async.Promise')
let s:Prompt = vital#fern#import('Prompt')

function! fern#scheme#bookmark#mapping#init(disable_default_mappings) abort
  call fern#scheme#dict#mapping#init(a:disable_default_mappings)

  nnoremap <buffer><silent> <Plug>(fern-action-cd)          :<C-u>call <SID>call('cd', 'cd')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-lcd)         :<C-u>call <SID>call('cd', 'lcd')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-tcd)         :<C-u>call <SID>call('cd', 'tcd')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:system) :<C-u>call <SID>call('open_system')<CR>

  if !a:disable_default_mappings
    nmap <buffer><nowait> x <Plug>(fern-action-open:system)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ "fern#internal#mapping#call",
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_cd(helper, command) abort
  let node = a:helper.sync.get_cursor_node()
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
  let node = a:helper.sync.get_cursor_node()
  if node.status isnot# a:helper.STATUS_NONE
    return s:Promise.reject("folder does not have path to cd")
  endif
  let Done = a:helper.sync.process_node(node)
  let path = node.concealed._value
  return fern#scheme#file#shutil#open(path, a:helper.fern.source.token)
        \.then({ -> a:helper.sync.echo(printf('%s has opened', path)) })
        \.finally({ -> Done() })
endfunction
