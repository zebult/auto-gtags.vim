## auto-gtags.vim

run the gtags command

## installation

requires `global` utility. please install

On OSX

    brew install global

Create tags

    :GtagsCreate

Update tags

    :GtagsUpdate

Update at a Writing the file, default `0`

    let g:auto_update_gtags = 1

Create the tags in directory, default `.`

```vim
" dein.vim
call dein#add('zebult/auto-gtags.vim')
" neobundle.vim
NeoBundle 'zebult/auto-gtags.vim'
```

## reference

[soramugi/auto-ctags.vim](https://github.com/soramugi/auto-ctags.vim)

