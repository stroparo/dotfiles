#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

PROGNAME=fonts-for-devel.sh

# #############################################################################
# Globals

LOCAL_FONTS_DIR="$HOME/.local/share/fonts"

# #############################################################################
# Checks

if !(uname -a | grep -i -q linux) ; then
  echo "${PROGNAME:+$PROGNAME: }SKIP: Only Linux is supported." 1>&2
  exit
fi

# #############################################################################
# Main

echo "################################################################################"
echo "Fonts installation"
echo "################################################################################"

git clone "https://github.com/powerline/fonts.git" --depth=1 ~/.powerline-fonts
cd ~/.powerline-fonts
./install.sh && cd && rm -rf ~/.powerline-fonts

fc-cache -f -v
sudo fc-cache -f -v

mkfontscale "$LOCAL_FONTS_DIR"
mkfontdir "$LOCAL_FONTS_DIR"

if ls -l "$LOCAL_FONTS_DIR"/* ; then
  echo "${PROGNAME:+$PROGNAME: }SUCCESS: installed fonts successfully."
  exit 0
else
  exit 1
fi
