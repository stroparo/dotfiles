#!/usr/bin/env bash

PROGNAME=deployvim.sh
USAGE="[-v]"

# #############################################################################
# Globals

: ${VERBOSE:=false} ; export VERBOSE

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
# Main

echo "################################################################################"
echo "Vim setup; \$0='$0'; \$PWD='$PWD'"

mkdir -p "$HOME"/.vim/colors
mkdir -p "$HOME"/.vim/undodir

# #############################################################################
# Themes

if [ ! -e "$HOME"/.vim/colors/zenburn.vim ] ; then
  git clone --depth 1 'https://github.com/jnurmine/Zenburn.git' "$HOME"/vim-zenburn \
    && mv -f "$HOME"/vim-zenburn/colors/zenburn.vim "$HOME"/.vim/colors/ \
    && rm -f -r "$HOME"/vim-zenburn
fi

if [ ! -e "$HOME"/.vim/colors/jellybeans.vim ] ; then
  git clone --depth 1 'https://github.com/nanotech/jellybeans.vim' "$HOME"/vim-jellybeans \
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

echo "FINISHED custom deployment of Vim"
echo
