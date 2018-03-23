set nocompatible              " be iMproved, required
filetype off                  " required

""
"" Plugins
"""
if empty(glob("~/.vim/autoload/plug.vim"))
   execute 'curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif


let g:plug_url_format = 'https://github.com/%s.git'

call plug#begin('~/.vim/plugged')
Plug 'honza/vim-snippets'
Plug 'flazz/vim-colorschemes'

Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'fatih/vim-go', { 'for':  'go' }
Plug 'rhysd/vim-go-impl', { 'for': 'go' }
Plug 'zchee/deoplete-go', { 'do': 'make' }

Plug 'itchyny/lightline.vim'
Plug 'nathanaelkane/vim-indent-guides'

Plug 'ekalinin/Dockerfile.vim'
Plug 'guns/xterm-color-table.vim'

Plug 'justmao945/vim-clang'
Plug 'michalbachowski/vim-wombat256mod'
Plug 'crusoexia/vim-monokai'
Plug 'jgdavey/tslime.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'hashivim/vim-terraform'
Plug 'saltstack/salt-vim'
call plug#end()

""
"" Basic setup
"""
syntax on
color wombat256mod
set t_Co=256
filetype plugin indent on
hi Visual ctermbg=238
set laststatus=2
set encoding=utf-8
map <F3> :NERDTreeToggle<CR>
map <F4> :TlistToggle<CR>
set nu
set relativenumber

""
"" Plugins config
"""
  let Tlist_Use_Right_Window=1
  let Tlist_Auto_Open=0
  let Tlist_Exit_OnlyWindow=1
  let Tlist_Sort_Type=""
  let g:airline_powerline_fonts = 1
  let g:tslime_always_current_window = 1
  let g:deoplete#enable_at_startup = 1

  let g:deoplete#enable_profile = 1
  call deoplete#enable_logging('DEBUG', '/tmp/deoplete.log')
  call deoplete#custom#source('jedi', 'is_debug_enabled', 1)
""
"" Open file at the last line before close
"""
if has("autocmd")
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
endif

""
"" close nerdtree on exit
"""
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()



"" Close all open buffers on entering a window if the only
"" buffer that's left is the NERDTree buffer
"""
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

""
"" mark whitespaces eol
"""
set backspace=indent,eol,start
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

""
"" File type mappings
"""
function! CMappings()
	set ts=4
	set sw=4
	set cindent
	map <F8> :call SendToTmux('cmake && make<CR>')<CR>
endfunction

function! GoMappings()
	set ts=4
	set sw=4
	map <F8> :call SendToTmux("go build -o main *.go\n")<CR>
	let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }
endfunction

function! PyMappings()
	set ts=4
	set sw=4
	set et expandtab
endfunction

function! TerraformMappings()
	set ts=2
	set sw=2
	set et expandtab
	map <F8> :call SendToTmux("terraform init && terraform apply\n")<CR>
endfunction

if has("autocmd")
	au FileType c,cpp call CMappings()
	au FileType python call PyMappings()
	au FileType go call GoMappings()
	au FileType terraform call TerraformMappings()
endif
