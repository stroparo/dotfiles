#!/usr/bin/env bash

PROGNAME="vim.sh"
USAGE="[-v]"

echo "################################################################################"
echo "Vim custom stroparo/dotfiles setup; \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

: ${VIM_COLORS_DIR:=${HOME}/.vim/colors}
: ${VIM_UNDO_DIR:=${HOME}/.vim/colors}
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


_print_results () {
  if ${VERBOSE:-false} ; then
    echo
    echo "==> Vim setup results"
    echo
    ls -d -l "${VIM_COLORS_DIR}"
    ls -d -l "${VIM_UNDO_DIR}"
    ls -l "${VIM_COLORS_DIR}"/*.vim
    echo
  fi
}


_provide_vim_colors_dir () {
  mkdir -p "${VIM_COLORS_DIR}"
  [ -d "${VIM_COLORS_DIR}" ]
}


_provide_vim_undo_dir () {
  mkdir -p "${VIM_UNDO_DIR}"
  [ -d "${VIM_UNDO_DIR}" ]
}


_install_colorscheme () {
  # Syntax: {repo url} {colorscheme filename}
  if [ $# -lt 2 ] ; then return ; fi

  typeset scheme_filename
  typeset scheme_url="$1"; shift
  typeset clone_dir
  typeset package_dir

  for scheme_filename in "$@" ; do
    clone_dir="${HOME}/.vimscheme-${scheme_filename%.vim}"
    if ls "${HOME}/.vim/colors/${scheme_filename%.vim}"*".vim" >/dev/null 2>&1 ; then
      echo "${PROGNAME:+$PROGNAME: }SKIP: colorscheme '${scheme_filename}' was previously installed.."
    else
      echo
      echo "${PROGNAME:+$PROGNAME: }INFO: Installing '${scheme_filename}' colorscheme..."

      if git clone --depth 1 "${scheme_url}" "${clone_dir}" ; then
        package_dir="${clone_dir}/colors"
        if [ -d "${clone_dir}/vim/colors" ] ; then
          package_dir="${clone_dir}/vim/colors"
        fi
        mv -f -v \
          "${package_dir}/${scheme_filename%.vim}"*".vim" \
          "${VIM_COLORS_DIR}/" \
          && rm -f -r "${clone_dir}"
      fi
    fi
  done
}


# #############################################################################
# Main

bash "${RUNR_DIR:-.}"/installers/setupvim.sh
_provide_vim_undo_dir

# #############################################################################
# Themes

if _provide_vim_colors_dir ; then
  : # empty command in case all lines below get commented

  _install_colorscheme 'https://github.com/AlessandroYorba/Despacio' despacio

  # Themes also aggregated by https://github.com/rafi/awesome-vim-colorschemes
  _install_colorscheme 'https://github.com/ajmwagar/vim-deus' deus
  _install_colorscheme 'https://github.com/dracula/vim' dracula
  _install_colorscheme 'https://github.com/yorickpeterse/happy_hacking.vim' happy_hacking
  _install_colorscheme 'https://github.com/cocopon/iceberg.vim' iceberg
  _install_colorscheme 'https://github.com/nanotech/jellybeans.vim' jellybeans
  _install_colorscheme 'https://github.com/dikiaap/minimalist' minimalist
  _install_colorscheme 'https://github.com/haishanh/night-owl.vim' night-owl
  _install_colorscheme 'https://github.com/owickstrom/vim-colors-paramount' paramount
  _install_colorscheme 'https://github.com/keith/parsec.vim' parsec
  _install_colorscheme 'https://github.com/scheakur/vim-scheakur' scheakur
  _install_colorscheme 'https://github.com/junegunn/seoul256.vim' seoul256
  _install_colorscheme 'https://github.com/AlessandroYorba/Sierra' sierra
  _install_colorscheme 'https://github.com/jacoborus/tender.vim' tender
  _install_colorscheme 'https://github.com/vim-scripts/twilight256.vim' twilight256
  _install_colorscheme 'https://github.com/vim-scripts/wombat256.vim' wombat256mod
fi

# #############################################################################
# Finish

_print_results

echo
echo "${PROGNAME:+$PROGNAME: }INFO: FINISHED custom deployment of Vim."
echo
