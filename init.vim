let mapleader =","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

map ,, :keepp /<++><CR>ca<

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tribela/vim-transparent'
Plug 'sainnhe/gruvbox-material'
Plug 'tpope/vim-surround'
Plug 'tommcdo/vim-express'
Plug 'preservim/nerdtree'
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
Plug 'vuciv/vim-bujo'
Plug 'davidgranstrom/scnvim'
call plug#end()

set title
set bg=dark
set go=a
set nohlsearch
syntax on
set clipboard+=unnamedplus
set noshowmode
set noruler
set nowrap
set laststatus=0
set noshowcmd
set tabstop=4
set shiftwidth=4
set expandtab
set mouse=

let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_ui_contrast = 1
let g:gruvbox_material_foreground = 'original'

colorscheme gruvbox-material

nnoremap c "_c
set nocompatible
filetype plugin on
set encoding=utf-8
set number relativenumber
set wildmode=longest,list,full
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
vnoremap . :normal .<CR>
" Spell-check set to 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_us<CR>

" splits
set splitbelow splitright
map <leader>T :Todo<cr>
map <leader>C :vsp<space>$CALENDAR<CR>

" split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Nerd tree
let NERDTreeMinimalUI=1
map <leader>n :NERDTreeToggle<CR>
let g:NERDTreeChDirMode = 2
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Replace all
nnoremap S :%s//g<Left><Left>

" Compile and viewing
map <leader>c :w! \| !compiler "%:p"<CR>
map <leader>p :!opout "%:p"<CR>

" Reading Files
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_list = [{'path': '~/.local/share/nvim/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff

" Sudo file saves
cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" remove trailing whitespace and newlines on write
autocmd BufWritePre * let currPos = getpos(".")
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
autocmd BufWritePre *.[ch] %s/\%$/\r/e
autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Recompile dwmblocks on config edit.
autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

silent! source ~/.config/nvim/shortcuts.vim

autocmd FileType scnvim setlocal wrap

lua << EOF
local scnvim = require 'scnvim'
local map = scnvim.map
local map_expr = scnvim.map_expr

scnvim.setup({
  keymaps = {
    ['<CR>'] = {
      map('editor.send_block', 'n'),
      map('editor.send_selection', 'x'),
    },
    ['<M-w>'] = map('postwin.toggle'),
    ['<M-CR>'] = map('postwin.toggle', 'i'),
    ['<M-L>'] = map('postwin.clear', {'n', 'i'}),
    ['<C-k>'] = map('signature.show', {'n', 'i'}),
    ['<F12>'] = map('sclang.hard_stop', {'n', 'x', 'i'}),
    ['<leader>ST'] = map('sclang.start'),
    ['<leader>SP'] = map('sclang.stop'),
    ['<leader>SK'] = map('sclang.recompile'),
    ['<leader>BS'] = map_expr('s.boot'),
    ['<leader>FA'] = map_expr('s.freeAll'),
    ['<leader>KA'] = map_expr('Server.killAll'),
    ['<M-m>'] = map_expr('s.meter'),
  },
  editor = {
    highlight = {
      color = 'IncSearch',
    },
  },
  postwin = {
    highlight = true,
    size = 80,
  },
})
EOF
