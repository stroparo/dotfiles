#!/usr/bin/env bash

PROGNAME="git.sh"

echo "$PROGNAME: INFO: Git custom recipe started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Globals

USAGE="[-v] [git files --default--> \$HOME/.gitconfig]"
: ${VERBOSE:=false} ; export VERBOSE

export APTPROG=apt-get; which apt >/dev/null 2>&1 && export APTPROG=apt
export RPMPROG=yum; which dnf >/dev/null 2>&1 && export RPMPROG=dnf
export RPMGROUP="yum groupinstall"; which dnf >/dev/null 2>&1 && export RPMGROUP="dnf group install"

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
# Routines


_prep_git_config_file () {
  typeset gitfile

  for gitfile in "$@" ; do
    touch "$gitfile"

    if [ ! -f "$gitfile" ] || [ ! -w "$gitfile" ] ; then
      echo "$PROGNAME: ERROR: Git file missing ('$gitfile')." 1>&2
      return 1
    fi
  done
}


_git_config () {
  typeset gitfile

  for gitfile in "$@" ; do
    _prep_git_config_file "$gitfile" || continue

    while read key value ; do
      if [ -n "$key" ] && [ -n "$value" ] ; then
        git config -f "$gitfile" --replace-all "$key" "$value"
      fi
    done <<EOF
${MYEMAIL:+user.email $MYEMAIL}
${MYSIGN:+user.name $MYSIGN}
color.ui          auto
core.autocrlf     false
core.excludesfile $HOME/.gitignore_global
core.pager        less -F -X
diff.submodule    log
push.default      simple
push.recurseSubmodules  check
rebase.missingCommitsCheck  warn
sendpack.sideband false
status.submodulesummary 1
EOF
    if ! (git config -l | grep -F -q "credential.helper") ; then
      git config -f "$gitfile" --replace-all "credential.helper" "cache --timeout=36000"
    fi

    if ${VERBOSE:-false} ; then
      echo
      echo "$PROGNAME: ==> Git config in '$gitfile' file:"
      git config -f "$gitfile" -l
    fi
  done
}


# #############################################################################
# Main

# Install Git
which git >/dev/null 2>&1 \
  || (sudo ${APTPROG:-apt} update && sudo ${APTPROG:-apt} install -y 'git-core') \
  || (sudo ${RPMPROG:-yum} install -y 'git')
if ! which git >/dev/null ; then
  echo "$PROGNAME: SKIP: no git available"
  exit
fi

if [ -z "$1" ] ; then
  echo "${PROGNAME:+$PROGNAME: }WARN: No args so defaulting to '$HOME/.gitconfig'." 1>&2
  _git_config "$HOME/.gitconfig"
else
  _git_config "$@"
fi

# #############################################################################
# Cygwin / Windows

if (uname -a | egrep -i -q "cygwin|mingw|msys|win32|windows") ; then

  GITCONFIG_CYGWIN="$(cygpath "$USERPROFILE")/.gitconfig"
  touch "$GITCONFIG_CYGWIN"

  _git_config "$GITCONFIG_CYGWIN"

  git config --global core.preloadindex true
  git config --global core.fscache true
  git config --global gc.auto 256

  if ${VERBOSE:-false} ; then
    echo
    echo "$PROGNAME: ==> Git config in '$GITCONFIG_CYGWIN' file:"
    git config -f "$GITCONFIG_CYGWIN" -l
  fi
fi

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE: Git custom recipe"
exit
