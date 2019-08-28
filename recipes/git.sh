#!/usr/bin/env bash

PROGNAME=git.sh
USAGE="[-v] [git files --default--> \$HOME/.gitconfig]"

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
# Begin

echo "################################################################################"
echo "Git setup; \$0='$0'; \$PWD='$PWD'"

# Install Git
which git >/dev/null 2>&1 \
  || (sudo apt update && sudo apt install -y 'git-core') \
  || (sudo yum install -y git)
which git >/dev/null 2>&1 || return 1

if ! which git >/dev/null 2>&1 ; then
  echo "$PROGNAME: SKIP: no git available" 1>&2
  exit
fi

# #############################################################################
# Routines

_prep_git_config_file () {
  typeset gitfile

  for gitfile in "$@" ; do
    touch "$gitfile"

    if [ ! -f "$gitfile" ] || [ ! -w "$gitfile" ] ; then
      echo "ERROR: Git file missing ('$gitfile')." 1>&2
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
sendpack.sideband false
status.submodulesummary 1
EOF
    if ! (git config -l | grep -F -q "credential.helper") ; then
      git config -f "$gitfile" --replace-all "credential.helper" "cache --timeout=36000"
    fi

    if ${VERBOSE:-false} ; then
      echo
      echo "==> Git config in '$gitfile' file:"
      git config -f "$gitfile" -l
    fi
  done
}

# #############################################################################
# Main

if [ -z "$1" ] ; then
  echo "${PROGNAME:+$PROGNAME: }WARN: No args so defaulting to '$HOME/.gitconfig'." 1>&2
  _git_config "$HOME/.gitconfig"
else
  _git_config "$@"
fi

# #############################################################################
# Cygwin / Windows

if (uname -a | egrep -i -q "cygwin") ; then

  GITCONFIG_CYGWIN="$(cygpath "$USERPROFILE")/.gitconfig"
  touch "$GITCONFIG_CYGWIN"

  _git_config "$GITCONFIG_CYGWIN"

  git config --global core.preloadindex true
  git config --global core.fscache true
  git config --global gc.auto 256

  if ${VERBOSE:-false} ; then
    echo
    echo "==> Git config in '$GITCONFIG_CYGWIN' file:"
    git config -f "$GITCONFIG_CYGWIN" -l
  fi
fi
if (uname -a | egrep -i -q "mingw|msys|win32|windows") ; then

  GITCONFIG_MINGW="$(cygpath "$USERPROFILE")/.gitconfig"
  touch "$GITCONFIG_MINGW"

  _git_config "$GITCONFIG_MINGW"

  git config --global core.preloadindex true
  git config --global core.fscache true
  git config --global gc.auto 256

  if ${VERBOSE:-false} ; then
    echo
    echo "==> Git config in '$GITCONFIG_MINGW' file:"
    git config -f "$GITCONFIG_MINGW" -l
  fi
fi

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE: custom deployment of Git"
echo
