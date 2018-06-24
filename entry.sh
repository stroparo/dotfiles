#!/usr/bin/env bash

# Cristian Stroparo's dotfiles
# Remark: Run this script from its directory.

export PROGNAME="entry.sh"

# #############################################################################
# Globals

: ${DEV:=${HOME}/workspace} ; export DEV
: ${OVERRIDE_SUBL_PREFS:=false} ; export OVERRIDE_SUBL_PREFS

# System installers
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"
export INSTPROG="$APTPROG"; which "$RPMPROG" >/dev/null 2>&1 && export INSTPROG="$RPMPROG"

# #############################################################################
# Options

NO_ACTION=true

: ${DO_ALIASES:=false}
: ${DO_PACKAGES:=false}
: ${DO_DOT:=false}
: ${DO_SHELL:=false}
: ${FULL:=false}

# Options:
OPTIND=1
while getopts ':abdfps' option ; do
  case "${option}" in
    a) DO_ALIASES=true; NO_ACTION=false;;
    b|p) DO_PACKAGES=true; NO_ACTION=false;;
    d) DO_DOT=true;;
    f) FULL=true;;
    s) DO_SHELL=true; NO_ACTION=false;;
  esac
done
shift "$((OPTIND-1))"

if [ $# -gt 0 ] ; then
  NO_ACTION=false
fi

export DO_ALIASES DO_PACKAGES DO_DOT DO_SHELL NO_ACTION FULL

# #############################################################################
# Helpers

_install_packages () {
  for package in "$@" ; do
    echo "Installing '$package'..."
    if ! sudo $INSTPROG install -y "$package" >/tmp/pkg-install-${package}.log 2>&1 ; then
      echo "${PROGNAME:+$PROGNAME: }WARN: There was an error installing package '$package' - see '/tmp/pkg-install-${package}.log'." 1>&2
    fi
  done
}

# #############################################################################
# Dependencies

if ! which sudo >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }WARN: Installing sudo via root and opening up visudo" 1>&2
  su - -c "bash -c '$INSTPROG install sudo; visudo'"
fi
if ! sudo whoami >/dev/null 2>&1 ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: No sudo access." 1>&2
  exit 1
fi

if ! which unzip >/dev/null 2>&1 ; then
  which $APTPROG >/dev/null 2>&1 && sudo $APTPROG update
  _install_packages unzip
fi

# #############################################################################
_provision_dotfiles () {
  export DOTFILES_SRC="https://bitbucket.org/stroparo/dotfiles/get/master.zip"
  export DOTFILES_SRC_ALT="https://github.com/stroparo/dotfiles/archive/master.zip"

  if [ ! -e ./entry.sh ] && [ ! -d ./dotfiles ] ; then
    if [ ! -d "${HOME}/dotfiles-master" ] ; then
      curl -LSfs -o "${HOME}"/.dotfiles.zip "$DOTFILES_SRC" \
        || curl -LSfs -o "${HOME}"/.dotfiles.zip "$DOTFILES_SRC_ALT"
      unzip -o "${HOME}"/.dotfiles.zip -d "${HOME}" \
        || return $?
      zip_dir=$(unzip -l "${HOME}"/.dotfiles.zip | head -5 | tail -1 | awk '{print $NF;}')
      echo "Zip dir: '$zip_dir'" 1>&2
      if [[ ${zip_dir%/} = *stroparo-dotfiles-* ]] ; then
        (cd "${HOME}"; mv -f -v "${zip_dir}" "${HOME}/dotfiles-master" 1>&2)
      fi
    fi
    cd "$HOME/dotfiles-master"
  fi

  if [ ! -e ./entry.sh ] && [ ! -d ./dotfiles ] ; then
    echo "FATAL: could not provision dotfiles." 1>&2
  fi

  export DOTFILES_DIR="$PWD"
  find "$DOTFILES_DIR" -name '*.sh' -type f -exec chmod u+x {} \;
  if ! (echo "$PATH" | fgrep -q "$(basename "$DOTFILES_DIR")") ; then
    # Root intentionally omitted from PATH as these must be called with absolute path:
    export PATH="$DOTFILES_DIR/installers:$DOTFILES_DIR/recipes:$DOTFILES_DIR/scripts:$PATH"
  fi
}
_provision_dotfiles

# #############################################################################
# Configurations

if ${DO_ALIASES:-false} || ${FULL:-false} ; then
  ./setupaliases.sh
fi

if ${DO_PACKAGES:-false} || ${FULL:-false} ; then
  ./setupbasicpackages.sh
fi

if ${DO_SHELL:-false} || ${FULL:-false} ; then
  ./setupshell.sh
fi

if ${DO_DOT:-false} || ${FULL:-false} || ${NO_ACTION:-true} ; then
  DEPLOY_SCRIPTS="$(ls -1 ./scripts/deploy*sh | grep -v deploypackages)"

  for deploy_script in $DEPLOY_SCRIPTS ; do
    "$deploy_script"
  done
fi

# #############################################################################
# Recipes

for recipe in "$@" ; do
  bash ./recipes/"${recipe%.sh}".sh
done
