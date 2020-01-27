if exists('g:fern_bookmark_loaded')
  finish
endif
let g:fern_bookmark_loaded = 1

call extend(g:fern#internal#mapping#enabled_mapping_presets, ['bookmark'])

let g:fern_bookmark_disable_default_mappings = get(g:, 'fern_bookmark_disable_default_mappings', 0)
