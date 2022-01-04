# vim-erde

Vim syntax and indentation support for the Erde programming language.

## Install

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'erde-lang/vim-erde'
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use('erde-lang/vim-erde')
```

## Flags

The following flags may be enabled by setting the value to `1` and disabled by
setting it to `0`.

### erde_disable_stdlib_syntax

Disables the syntax highlighting of Lua's stdlib such as `package.path`,
`table.concat`, etc.

```vimscript
set g:erde_disable_stdlib_syntax = 1
```

## Credit

Huge thanks to [tbastos/vim-lua](https://github.com/tbastos/vim-lua) and
VSCode's [lua extension](https://github.com/microsoft/vscode/blob/main/extensions/lua/syntaxes/lua.tmLanguage.json)
for providing a lot of the groundwork.
