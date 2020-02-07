if exists('g:fern_bookmark_loaded')
  finish
endif
let g:fern_bookmark_loaded = 1

call extend(g:fern#mapping#mappings, ['bookmark'])
