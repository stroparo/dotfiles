#/usr/bin/env bash

# #############################################################################
# Globals

export DSEXTRAS_GIT="https://github.com/stroparo/ds-extras.git"

export OHMYZSH_URL="https://raw.github.com/robbyrussell/\
oh-my-zsh/master/tools/install.sh"

export SETUP_URL="https://raw.githubusercontent.com/stroparo/ds/\
master/setup.sh"

if which curl >/dev/null 2>&1 ; then
  export DLPROG=curl
  export DLOPT='-LSfs'
elif which wget >/dev/null 2>&1 ; then
  export DLPROG=wget
  export DLOPT='-O -'
else
  echo "FATAL: curl and wget missing" 1>&2
  exit 1
fi

# #############################################################################

# Daily Shells
sh -c "$(${DLPROG} ${DLOPT} "${SETUP_URL}")"

# Daily Shells Extras
git clone "${DSEXTRAS_GIT}" ~/.ds-extras \
  && (cd ~/.ds-extras && . ./overlay.sh) \
  && rm -rf ~/.ds-extras

# OhMyZsh
sh -c "$(${DLPROG} ${DLOPT} "${OHMYZSH_URL}")"
(. ~/.ds/ds.sh && [ -n "$DS_LOADED" ] && installohmyzsh.sh)

# SSH key
if [[ $USER != root ]] && [ ! -e ~/.ssh/id_rsa ] ; then

  mkdir ~/.ssh

  ssh-keygen -t rsa -C "$USER@$(hostname)" \
    && chmod 700 ~/.ssh/id_rsa \
    && ls -l ~/.ssh/id_rsa
fi
if [ -e ~/.ssh/id_rsa.pub ] ; then
  echo "==> ~/.ssh/id_rsa.pub contents:"
  cat ~/.ssh/id_rsa.pub
fi
