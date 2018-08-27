#!/usr/bin/env bash

# Remark: Run this script from its directory.

export PROGNAME="entry.sh"

# #############################################################################
# Globals

: ${DEV:=${HOME}/workspace} ; export DEV
: ${OVERRIDE_SUBL_PREFS:=false} ; export OVERRIDE_SUBL_PREFS
: ${VERBOSE:=false} ; export VERBOSE

# System installers
export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"
export INSTPROG="$APTPROG"; which "$RPMPROG" >/dev/null 2>&1 && export INSTPROG="$RPMPROG"

# #############################################################################
# Options

: ${REPOS:=https://github.com/stroparo/dotfiles.git}; export REPOS
: ${VERBOSE:=false}

# Options:
OPTIND=1
while getopts ':r:v' option ; do
  case "${option}" in
    r) export REPOS="$OPTARG";;
    v) VERBOSE=true;;
  esac
done
shift "$((OPTIND-1))"

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

_print_bar () {
  echo "################################################################################"
}

# #############################################################################
# Dependencies

if (uname | grep -q linux) ; then
  if ! which sudo >/dev/null 2>&1 ; then
    echo "${PROGNAME:+$PROGNAME: }WARN: Installing sudo via root and opening up visudo" 1>&2
    su - -c "bash -c '$INSTPROG install sudo; visudo'"
  fi
  if ! sudo whoami >/dev/null 2>&1 ; then
    echo "${PROGNAME:+$PROGNAME: }FATAL: No sudo access." 1>&2
    exit 1
  fi
fi

if (! which curl || ! which git || ! which unzip) >/dev/null 2>&1 ; then
  which $APTPROG >/dev/null 2>&1 && sudo $APTPROG update
  _install_packages curl git unzip
fi

# #############################################################################
_provision_runr () {
  export RUNR_SRC="https://bitbucket.org/stroparo/runr/get/master.zip"
  export RUNR_SRC_ALT="https://github.com/stroparo/runr/archive/master.zip"

  if [ ! -e ./entry.sh ] && [ ! -d ./runr ] ; then

    if [ -d "${HOME}/runr-master" ] ; then
      export RUNR_BAK_DIRNAME="${HOME}/.runr-master.bak.$(date '+%Y%m%d-%OH%OM%OS')"
      if mv -f "${HOME}/runr-master" "$RUNR_BAK_DIRNAME" ; then
        tar czf "${RUNR_BAK_DIRNAME}.tar.gz" "$RUNR_BAK_DIRNAME" \
          && rm -f -r "$RUNR_BAK_DIRNAME"
      else
        echo "${PROGNAME:+$PROGNAME: }FATAL: Could not archive existing ~/runr-master." 1>&2
        exit 1
      fi
    fi

    # Provide an updated 'runr-master' directory:
    curl -LSfs -o "${HOME}"/.runr.zip "$RUNR_SRC" \
      || curl -LSfs -o "${HOME}"/.runr.zip "$RUNR_SRC_ALT"
    unzip -o "${HOME}"/.runr.zip -d "${HOME}" \
      || exit $?
    zip_dir=$(unzip -l "${HOME}"/.runr.zip | head -5 | tail -1 | awk '{print $NF;}')
    echo "Zip dir: '$zip_dir'" 1>&2
    if ! (cd "${HOME}"; mv -f -v "${zip_dir}" "${HOME}/runr-master" 1>&2) ; then
      echo "${PROGNAME:+$PROGNAME: }FATAL: Could not move '$zip_dir' to ~/runr-master" 1>&2
      exit 1
    fi

    cd "$HOME/runr-master"
  fi

  if [ ! -e ./entry.sh ] && [ ! -d ./runr ] ; then
    echo "${PROGNAME:+$PROGNAME: }FATAL: Could not provision runr." 1>&2
  fi

  export RUNR_DIR="$PWD"
  find "$RUNR_DIR" -name '*.sh' -type f -exec chmod u+x {} \;
  if ! (echo "$PATH" | fgrep -q "$(basename "$RUNR_DIR")") ; then
    # Root intentionally omitted from PATH as these must be called with absolute path:
    export PATH="$RUNR_DIR/installers:$RUNR_DIR/recipes:$RUNR_DIR/scripts:$PATH"
  fi
}
_provision_runr

# #############################################################################
# Clone repos with sequences to be ran

mkdir "${RUNR_DIR}/tmp"
if [ ! -d "${RUNR_DIR}/tmp" ] ; then
  echo "${PROGNAME:+$PROGNAME: }FATAL: There was some error creating temp dir at '${RUNR_DIR}/tmp'." 1>&2
  exit 1
fi

if [ -n "$REPOS" ] ; then
  while read repo ; do
    git archive --remote="$repo" master | tar -xf - -C "${RUNR_DIR}/tmp"
    repo_basename=$(basename "${repo%.git}")
    if mv -i "${RUNR_DIR}/tmp/${repo_basename}"/* "${RUNR_DIR}"/ ; then
      rm -f -r "${RUNR_DIR}/tmp/${repo_basename}"
    else
      echo "${PROGNAME:+$PROGNAME: }WARN: There was some error deploying '${RUNR_DIR}/tmp/${repo_basename}' files to '${RUNR_DIR}'." 1>&2
    fi
  done <<EOF
$REPOS
EOF
fi

# #############################################################################
# Run sequences

for recipe in "$@" ; do
  for dir in */ ; do
    if [ -f ./"${dir}/${recipe%.sh}".sh ] ; then
      bash ./"${dir}/${recipe%.sh}".sh
    fi
  done
done
