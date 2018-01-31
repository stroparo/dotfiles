#/usr/bin/env bash

# Daily Shells Library
# More instructions and licensing at:
# https://github.com/stroparo/ds

echo
echo "==> Setting up setupshell.sh (Daily Shells and some of its setups)..."

# #############################################################################
# Globals

export DSEXTRAS_GIT="https://github.com/stroparo/ds-extras.git"
export PROGNAME=setupshell.sh
export SETUP_URL="https://raw.githubusercontent.com/stroparo/ds/\
master/setup.sh"

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
bash -c "$(${DLPROG} ${DLOPT} "${SETUP_URL}")"

# Daily Shells Extras
rm -rf ~/.ds-extras >/dev/null 2>&1
git clone "${DSEXTRAS_GIT}" ~/.ds-extras \
  && (cd ~/.ds-extras && . ./overlay.sh) \
  && rm -rf ~/.ds-extras

# Load Daily Shells
. ~/.ds/ds.sh
if ! ${DS_LOADED:-false} ; then
  echo "${PROGNAME:+${PROGNAME}: }FATAL: Could not load Daily Shells." 1>&2
  exit 1
fi

setupohmyzsh.sh
sshkeygenrsa.sh
