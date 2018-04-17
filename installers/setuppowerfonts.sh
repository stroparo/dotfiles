#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

echo ${BASH_VERSION:+-e} '\n\n==> Installing powerline fonts...' 1>&2

# #############################################################################
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "FATAL: Only Linux is supported." 1>&2
  exit 1
fi

# Check for idempotency
if [ -e "$HOME/.local/share/fonts/Inconsolata for Powerline.otf" ] ; then
  echo "SKIP: Already installed." 1>&2
  exit
fi

# #############################################################################
# Install

wget https://github.com/powerline/fonts/archive/master.zip \
  -O ~/powerline.zip

(cd ~ ; unzip powerline.zip) \
  && ~/fonts-master/install.sh \
  && rm -rf ~/fonts-master ~/powerline.zip \
  || ls -d -l ~/fonts-master ~/powerline.zip
