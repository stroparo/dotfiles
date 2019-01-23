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
  typeset clone_dir
  typeset package_dir

  for scheme_filename in "$@" ; do
    clone_dir="${HOME}/vim-${scheme_filename%.vim}"
    if ! ls "${HOME}/.vim/colors/${scheme_filename%.vim}"*".vim" >/dev/null 2>&1 ; then
      if git clone --depth 1 "${scheme_url}" "${clone_dir}" ; then
        package_dir="${clone_dir}/colors"
        if [ -d "${clone_dir}/vim/colors" ] ; then
          package_dir="${clone_dir}/vim/colors"
        fi
        mv -f -v "${package_dir}/${scheme_filename%.vim}"*".vim" "${HOME}"/.vim/colors/ \
          && rm -f -r "${clone_dir}"
      fi
    fi
  done
}


# #############################################################################
# Main

if ! (vim --version | grep -q 'stroparo') ; then
  bash "${RUNR_DIR:-.}"/installers/setupvim.sh
  if ! (vim --version | grep -q 'stroparo') ; then
    echo "${PROGNAME:+$PROGNAME: }WARN: Error compiling vim, but will carry on with this recipe." 1>&2
  fi
fi

mkdir -p "$HOME"/.vim/undodir

# #############################################################################
# Themes

mkdir -p "$HOME"/.vim/colors
_install_colorscheme 'https://github.com/nanotech/jellybeans.vim' jellybeans

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
