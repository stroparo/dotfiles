#!/usr/bin/env bash

mkdir -p "$HOME"/.vim/colors
mkdir -p "$HOME"/.vim/undodir

if [ ! -d "$HOME"/.vim/colors/zenburn.vim ] ; then
  git clone https://github.com/jnurmine/Zenburn.git "$HOME"/zenburn \
    && mv -f -v "$HOME"/zenburn/colors/zenburn.vim "$HOME"/.vim/colors/ \
    && rm -f -r "$HOME"/zenburn
fi
