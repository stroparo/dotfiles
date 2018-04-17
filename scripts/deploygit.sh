#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

echo
echo "==> Setting up git..."

# #############################################################################
# Globals

PROGNAME=deploygit.sh

# #############################################################################
# Prep

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
credential.helper cache --timeout=36000
diff.submodule    log
push.default      simple
push.recurseSubmodules  check
sendpack.sideband false
status.submodulesummary 1
EOF
    echo
    echo "==> Git config in '$gitfile' file:"
    git config -f "$gitfile" -l
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

if (uname -a | grep -i -q cygwin) ; then

  GITCONFIG_CYGWIN="$(cygpath "$USERPROFILE")/.gitconfig"
  touch "$GITCONFIG_CYGWIN"

  _git_config "$GITCONFIG_CYGWIN"

  git config --global core.preloadindex true
  git config --global core.fscache true
  git config --global gc.auto 256

  echo
  echo "==> Git config in '$GITCONFIG_CYGWIN' file:"
  git config -f "$GITCONFIG_CYGWIN" -l
fi

# #############################################################################
