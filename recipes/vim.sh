#!/usr/bin/env bash

PROGNAME="vim.sh"
USAGE="[-v]"

echo "################################################################################"
echo "Vim custom stroparo/dotfiles setup; \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

: ${VERBOSE:=false}

# #############################################################################
# Options:
OPTIND=1
while getopts ':hv' option ; do
  case "${option}" in
    h) echo "$USAGE"; exit ;;
    v) VERBOSE=true ;;
  esac
done
shift "$((OPTIND-1))"

# #############################################################################
# Functions


_install_colorscheme () {
  # Syntax: {repo url} {colorscheme filename}
  if [ $# -lt 2 ] ; then return ; fi

  typeset scheme_filename
  typeset scheme_url="$1"; shift

  for scheme_filename in "$@" ; do
    if [ ! -e "${HOME}/.vim/colors/${scheme_filename%.vim}.vim" ] ; then
      if git clone --depth 1 "${scheme_url}" "${HOME}/vim-${scheme_filename%.vim}" ; then
        case $scheme_filename in
          Tomorrow*)
            ls -l "${HOME}/vim-${scheme_filename%.vim}/vim/colors"
            mv -f "${HOME}/vim-${scheme_filename%.vim}/vim/colors/${scheme_filename%.vim}*.vim" "${HOME}"/.vim/colors/
            ;;
          *)
            ls -l "${HOME}/vim-${scheme_filename%.vim}/colors"
            mv -f "${HOME}/vim-${scheme_filename%.vim}/colors/${scheme_filename%.vim}*.vim" "${HOME}"/.vim/colors/
            ;;
        esac
        rm -f -r "${HOME}/vim-${scheme_filename%.vim}"
      fi
    fi
  done
}


# #############################################################################
# Main

if ! (vim --version | grep -q 'stroparo') ; then
  bash "${RUNR_DIR:-.}"/installers/setupvim.sh
  if ! (vim --version | grep -q 'stroparo') ; then
    echo "${PROGNAME:+$PROGNAME: }WARN: Error compiling vim, but proceeding with this recipe." 1>&2
  fi
fi

mkdir -p "$HOME"/.vim/colors
mkdir -p "$HOME"/.vim/undodir

# #############################################################################
# Themes

_install_colorscheme 'https://github.com/nanotech/jellybeans.vim' jellybeans
_install_colorscheme 'https://github.com/chriskempson/tomorrow-theme' Tomorrow
_install_colorscheme 'https://github.com/jnurmine/Zenburn.git' zenburn

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
