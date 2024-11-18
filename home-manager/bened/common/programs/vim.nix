{ pkgs, ... }:
{
  programs.vim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-lastplace
      YouCompleteMe
      ReplaceWithRegister
      vim-peekaboo
      nerdtree
      vim-polyglot
      vim-elixir
      ctrlp-vim
    ];

    extraConfig = ''
      set nocompatible
      set backspace=indent,eol,start
      syntax on
      set number relativenumber
      set scrolloff=10
      set wrap
      set hlsearch
      set incsearch
      set showcmd
      set showmode
      set showmatch
      set background=dark

      let mapleader=","

      map <space> /
      nnoremap <Leader>n :noh<CR>

      nnoremap <leader>n :NERDTreeFocus<CR>
      nnoremap <C-n> :NERDTree<CR>
      nnoremap <C-t> :NERDTreeToggle<CR>
      nnoremap <C-f> :NERDTreeFind<CR>

      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
      autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
    '';
  };
}
