#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

echo
echo "==> Setting up vim..."

# #############################################################################
# Directories

mkdir -p "$HOME"/.vim/colors
mkdir -p "$HOME"/.vim/undodir

# #############################################################################
# Plugins

if [ ! -e "$HOME"/.vim/colors/zenburn.vim ] ; then
  git clone https://github.com/jnurmine/Zenburn.git "$HOME"/zenburn \
    && mv -f -v "$HOME"/zenburn/colors/zenburn.vim "$HOME"/.vim/colors/ \
    && rm -f -r "$HOME"/zenburn
fi

# #############################################################################
# Output results

ls -d -l "$HOME"/.vim/colors
ls -d -l "$HOME"/.vim/undodir
ls -l "$HOME"/.vim/colors/zenburn.vim

# #############################################################################
