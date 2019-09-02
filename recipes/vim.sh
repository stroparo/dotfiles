#!/usr/bin/env bash

PROGNAME="vim.sh"

echo "$PROGNAME: INFO: Vim custom recipe >>>> this is a compound recipe"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

USAGE="[-v]"
: ${VIM_UNDO_DIR:=${HOME}/.vim/undodir}
: ${VERBOSE:=false}

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

cd "${RUNR_DIR:-$PWD}"

bash "${RUNR_DIR:-$PWD}"/installers/setupvim.sh
if ! _provide_vim_undo_dir ; then
  echo "$PROGNAME: WARN: Could not create Vim undo dir at '$VIM_UNDO_DIR'."
fi

echo "$PROGNAME: INFO: Run the 'dotfiles' recipe to install colors etc."

echo "$PROGNAME: COMPLETE: Vim custom recipe (compound)"
exit
