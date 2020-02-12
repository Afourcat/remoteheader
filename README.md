# Remote Header

Dead simple plugin to fetch header over the internet.

[![asciicast](https://asciinema.org/a/fSw7urSxumJzVP75CR2vDNh5k.svg)](https://asciinema.org/a/fSw7urSxumJzVP75CR2vDNh5k)

## Required

You need curl installed to make the plugin work.

## Installation

### NeoBundle

An example of how to load this plugin in NeoBundle:

```VimL
" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

    " Let NeoBundle manage NeoBundle
    " Required:
    NeoBundleFetch 'Shougo/neobundle.vim'

    " You probably have a number of other plugins listed here.

    " Add this line to make your new plugin load, assuming you haven't renamed it.
    NeoBundle 'remoteheader'
call neobundle#end()
```

### vim-plug

An example of how to load this plugin using vim-plug:

```VimL
Plug 'Afourcat/remoteheader'
```

After running `:PlugInstall`, the files should appear in your
`~/.config/nvim/plugged` directory (or whatever path you have configured for plugins).

## Configuration

You need to register a address for each filetype.

```VimL
let g:remote_header_addr = {
    \ 'c': 'http://raw_c_header.my.com',
    \ 'cpp': 'http://raw_c_header.my.com',
    \ 'cxx': 'http://raw_c_header.my.com',
    \ 'rs': 'http://raw_rust_header.my.com',
    \ 'default': 'https://common_header.my.com',
    \ }
```

The `default` address is used for extensions that doesn't match defined ones.

Their is also special variables that can be replaced by the plugin before being used.

`$filename`: Replaced by the name of the current buffer.
`$project`: Replaced by the name of the current project (The directory containing .git)
