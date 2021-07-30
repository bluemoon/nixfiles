set termguicolors
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
Plugin 'VundleVim/Vundle.vim'
" Theme related
Plugin 'morhetz/gruvbox'
Plugin 'shinchu/lightline-gruvbox.vim'
" Quality of life
Plugin 'tpope/vim-surround'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'easymotion/vim-easymotion'
" Language specific
Plugin 'fatih/vim-go'
Plugin 'mattn/emmet-vim'
Plugin 'neoclide/coc.nvim'
Plugin 'cespare/vim-toml'
call vundle#end()            " required
filetype plugin indent on    " required

"" Theme
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'

if has('gui_running')
  set guifont=PragmataPro_Mono_Liga:h13
endif

set laststatus=2
set guioptions=
let mapleader = ","
set tabstop=2
set textwidth=0 wrapmargin=0
set softtabstop=2
set nowrap
set number
set autowrite

" Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

" Auto formatting and importing
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

" Status line types/signatures
let g:go_auto_type_info = 1

" Run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

inoremap <silent><expr> <c-@> coc#refresh()
