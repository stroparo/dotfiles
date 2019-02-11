#!/usr/bin/env bash

PROGNAME="vim.sh"
USAGE="[-v]"

echo "################################################################################"
echo "Vim custom stroparo/dotfiles setup; \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

: ${VIM_UNDO_DIR:=${HOME}/.vim/undodir}
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


_provide_vim_undo_dir () {
  mkdir -p "${VIM_UNDO_DIR}"
  [ -d "${VIM_UNDO_DIR}" ]
}


# #############################################################################
# Main

bash "${RUNR_DIR:-.}"/installers/setupvim.sh
_provide_vim_undo_dir

# #############################################################################
# Finish

echo
echo "${PROGNAME:+$PROGNAME: }INFO: Run the 'dotfiles' recipe to install colors etc."
echo "${PROGNAME:+$PROGNAME: }INFO: FINISHED custom deployment of Vim."
echo
