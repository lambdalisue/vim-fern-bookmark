# fern-bookmark.vim

A plugin for [fern.vim](https://github.com/lambdalisue/fern.vim) which provides simple bookmark feature.

## Usage

Execute the following command to open a default bookmark.

```
:Fern bookmark:
```

Or execute the following command to open a bookmark which name is 'custom'.

```
:Fern bookmark:custom
```

Now create a new entry with `N` and edit that entry with `e` to fill arbital path.
Or execute `add-cwd-to-bookmark` or `add-previous-buffer-to-bookmark` action.

After all, hit `<Return>` to open a file/directory, `x` to open the file/directory with a system
program, or execute `cd/lcd/tcd` action to change current directory.

## Mapping/Action

Addition to the builtin mappings/actions, the followings are available for this scheme.

| Name                            | Mapping | Description                                                  |
| ------------------------------- | ------- | ------------------------------------------------------------ |
| new-leaf                        | `N`     | Add new bookmark                                             |
| new-branch                      | `K`     | Add new bookmark folder                                      |
| remove                          | `d`     | Remove bookmark or folder                                    |
| open:system                     | `x`     | Open the bookmark with a system program                      |
| cd                              |         | Change directory with `cd` command                           |
| lcd                             |         | Change directory with `lcd` command                          |
| tcd                             |         | Change directory with `tcd` command                          |
| add-cwd-to-bookmark             |         | Create new bookmark which points a current working directory |
| add-previous-buffer-to-bookmark |         | Create new bookmark which points a previous buffer           |

## Config

The following config variables are available:

```vim
let g:fern#scheme#bookmark#store#dir = "~/.fern/bookmark"
```

## License

The code in gina.vim follows MIT license texted in [LICENSE](./LICENSE).
Contributors need to agree that any modifications sent in this repository follow the license.
