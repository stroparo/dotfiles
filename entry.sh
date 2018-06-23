#!/usr/bin/env bash
# Cristian Stroparo's dotfiles

# Remark:
# Run this script from its directory otherwise it will not find
#  the ./scripts/ directory and will self provision.

# #############################################################################
# Globals & Options

export PROGNAME="entry.sh"

NO_ACTION=true

: ${DO_ALIASES:=false}
: ${DO_PACKAGES:=false}
: ${DO_DOT:=false}
: ${DO_SHELL:=false}
: ${FULL:=false}
: ${OVERRIDE_SUBL_PREFS:=false}

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

export DO_ALIASES DO_PACKAGES DO_DOT DO_SHELL NO_ACTION FULL OVERRIDE_SUBL_PREFS

# #############################################################################
_provision_dotfiles () {
  export DOTFILES_AT_GITHUB="https://github.com/stroparo/dotfiles/archive/master.zip"
  export DOTFILES_AT_GITLAB="https://gitlab.com/stroparo/dotfiles/repository/master/archive.zip"
  if [ -d "${HOME}/dotfiles-master" ] ; then
    echo "${PROGNAME:+$PROGNAME: }SKIP: '$HOME/dotfiles-master' already in place." 1>&2
  else
    curl -LSfs -o "${HOME}"/.dotfiles.zip "$DOTFILES_AT_GITLAB" \
      || curl -LSfs -o "${HOME}"/.dotfiles.zip "$DOTFILES_AT_GITHUB"
    unzip -o "${HOME}"/.dotfiles.zip -d "${HOME}" \
      || return $?
    zip_dir=$(unzip -l "${HOME}"/.dotfiles.zip | head -5 | tail -1 | awk '{print $NF;}')
    echo "Zip dir: '$zip_dir'" 1>&2
    if [[ ${zip_dir%/} = *dotfiles-master*[a-z0-9]* ]] ; then
      (cd "${HOME}"; mv -f -v "${zip_dir}" "${HOME}/dotfiles-master" 1>&2)
    fi
  fi
  find "${HOME}/dotfiles-master" -name '*.sh' -type f -exec chmod u+x {} \;
  if ! (echo "$PATH" | grep -q dotfiles) ; then
    # Root intentionally omitted from PATH as these must be called with absolute path:
    export PATH="${HOME}/dotfiles-master/installers:${HOME}/dotfiles-master/scripts:$PATH"
  fi
}
if [ ! -e ./entry.sh ] && [ ! -d ./dotfiles ] ; then
  _provision_dotfiles && cd "$HOME/dotfiles-master"
fi

# #############################################################################
# Configurations

if ${DO_ALIASES:-false} || ${FULL:-false} ; then
  ./setupaliases.sh
fi

if ${DO_PACKAGES:-false} || ${FULL:-false} ; then
  ./setuppackages.sh # {deb,rpm}selects etc.
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
