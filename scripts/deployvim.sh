#!/usr/bin/env bash

PROGNAME=deployvim.sh
USAGE="[-v]"

# #############################################################################
# Globals

VERBOSE=false

# #############################################################################
# Helpers

_print_bar () {
  echo "################################################################################"
}

# #############################################################################
# Options:
OPTIND=1
while getopts ':hv' option ; do
  case "${option}" in
    v) VERBOSE=true;;
    h) echo "$USAGE"; exit;;
  esac
done
shift "$((OPTIND-1))"

# #############################################################################
# Begin

if ${VERBOSE:-false} ; then _print_bar ; echo "Vim setup; \$0='$0'; \$PWD='$PWD'" ; fi

mkdir -p "$HOME"/.vim/colors
mkdir -p "$HOME"/.vim/undodir

# #############################################################################
# Themes

if [ ! -e "$HOME"/.vim/colors/zenburn.vim ] ; then
  git clone 'https://github.com/jnurmine/Zenburn.git' "$HOME"/vim-zenburn \
    && mv -f "$HOME"/vim-zenburn/colors/zenburn.vim "$HOME"/.vim/colors/ \
    && rm -f -r "$HOME"/vim-zenburn
fi

if [ ! -e "$HOME"/.vim/colors/jellybeans.vim ] ; then
  git clone 'https://github.com/nanotech/jellybeans.vim' "$HOME"/vim-jellybeans \
    && mv -f "$HOME"/vim-jellybeans/colors/jellybeans.vim "$HOME"/.vim/colors/ \
    && rm -f -r "$HOME"/vim-jellybeans
fi

# #############################################################################
# Finish

if ${VERBOSE:-false} ; then
  echo
  echo "==> Vim setup results"
  echo
  ls -d -l "$HOME"/.vim/colors
  ls -d -l "$HOME"/.vim/undodir
  ls -l "$HOME"/.vim/colors/*.vim
  echo
fi

if ${VERBOSE:-false} ; then echo "Vim setup complete" ; _print_bar ; fi

