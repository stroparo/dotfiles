#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

echo
echo "==> Vim setup..."

# #############################################################################
# Directories

mkdir -p "$HOME"/.vim/colors
mkdir -p "$HOME"/.vim/undodir

# #############################################################################
# Themes

if [ ! -e "$HOME"/.vim/colors/zenburn.vim ] ; then
  git clone 'https://github.com/jnurmine/Zenburn.git' "$HOME"/vim-zenburn \
    && mv -f -v "$HOME"/vim-zenburn/colors/zenburn.vim "$HOME"/.vim/colors/ \
    && rm -f -r "$HOME"/vim-zenburn
fi

if [ ! -e "$HOME"/.vim/colors/jellybeans.vim ] ; then
  git clone 'https://github.com/nanotech/jellybeans.vim' "$HOME"/vim-jellybeans \
    && mv -f -v "$HOME"/vim-jellybeans/colors/zenburn.vim "$HOME"/.vim/colors/ \
    && rm -f -r "$HOME"/vim-jellybeans
fi

# #############################################################################
# Results

echo "==> Vim setup results:"

ls -d -l "$HOME"/.vim/colors
ls -d -l "$HOME"/.vim/undodir
ls -l "$HOME"/.vim/colors/*.vim

# #############################################################################

echo "==> Vim setup finished ($0)"
