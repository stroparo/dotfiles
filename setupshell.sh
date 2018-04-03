#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

echo
echo "==> Setting up the shell with Daily Shells and some of its own setups..."

# #############################################################################
# Globals

export PROGNAME=setupshell.sh
export PROGDIR="$(dirname "$0")"

export DS_SETUP_URL="https://raw.githubusercontent.com/stroparo/ds/master/setup.sh"

if which curl >/dev/null 2>&1 ; then
  export DLPROG=curl
  export DLOPT='-LSfs'
elif which wget >/dev/null 2>&1 ; then
  export DLPROG=wget
  export DLOPT='-O -'
else
  echo "${PROGNAME:+${PROGNAME}: }FATAL: curl and wget missing" 1>&2
  exit 1
fi

# #############################################################################

# Daily Shells
bash -c "$(${DLPROG} ${DLOPT} "${DS_SETUP_URL}")"
. ~/.ds/ds.sh
if ! ${DS_LOADED:-false} ; then
  echo "${PROGNAME:+${PROGNAME}: }FATAL: Could not load Daily Shells." 1>&2
  exit 1
fi

"dsplugin.sh" "stroparo/ds-extras"
. ~/.ds/ds.sh

echo
echo "################################################################################"
echo
echo "==> After installing oh-my-zsh, it will change"
echo "    the default shell to zsh and log into it."
echo "    IF THAT IS THE CASE (like the prompt stopped"
echo "    and nothing else happened), then exit or ctrl+d"
echo "    for this sequence to continue."
echo
"$PROGDIR/installers/setupohmyzsh.sh"

echo
echo "################################################################################"
echo
echo "==> sshkeygenrsa.sh"
echo
"sshkeygenrsa.sh"
