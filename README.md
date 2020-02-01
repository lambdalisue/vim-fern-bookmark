# 🌿 fern-bookmark.vim

[![fern plugin](https://img.shields.io/badge/🌿%20fern-plugin-yellowgreen)](https://github.com/lambdalisue/fern.vim)

A plugin for [fern.vim](https://github.com/lambdalisue/fern.vim) which provides simple bookmark feature.

## Usage

First of all, open fern for any scheme and hit `B` to save selected nodes to bookmarks.
Then, execute the following command to open a bookmark tree.

```
:Fern bookmark:///
```

In bookmark tree, you can manually create a new bookmark with `N` or edit with `e`.
Or, hit `<Return>` to open the bookmark, `x` to open the bookmark with a system
program, or execute `cd/lcd/tcd` action to change current directory.

## Mapping/Action

Addition to the builtin mappings/actions, the followings are available for bookmark scheme.

| Mapping | Action        | Description                             |
| ------- | ------------- | --------------------------------------- |
| `N`     | `new-leaf`    | Add new bookmark                        |
| `K`     | `new-branch`  | Add new bookmark folder                 |
| `d`     | `remove`      | Remove bookmark or folder               |
| `x`     | `open:system` | Open the bookmark with a system program |
|         | `cd`          | Change directory with `cd` command      |
|         | `lcd`         | Change directory with `lcd` command     |
|         | `tcd`         | Change directory with `tcd` command     |

And the followings are available for _ANY_ scheme.

| Mapping | Action             | Description                                                |
| ------- | ------------------ | ---------------------------------------------------------- |
| `B`     | `save-as-bookmark` | Save selected nodes as bookmarks (node must has `bufname`) |

## Config

The following config variables are available:

```vim
let g:fern#mapping#bookmark#disable_default_mappings = 0
```

## License

The code in fern-bookmark.vim follows MIT license texted in [LICENSE](./LICENSE).
Contributors need to agree that any modifications sent in this repository follow the license.
