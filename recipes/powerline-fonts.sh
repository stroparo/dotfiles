#!/usr/bin/env bash

(uname | grep -i -q linux) || exit

PROGNAME=devel-fonts.sh
LOCAL_FONTS_DIR="$HOME/.local/share/fonts"

echo "################################################################################"
echo "Fonts installation"

git clone --depth 1 "https://github.com/powerline/fonts.git" ~/.powerline-fonts
cd ~/.powerline-fonts
./install.sh && cd && rm -rf ~/.powerline-fonts

fc-cache -f -v
sudo fc-cache -f -v

mkfontscale "${LOCAL_FONTS_DIR}"
mkfontdir "${LOCAL_FONTS_DIR}"

if ls -l "${LOCAL_FONTS_DIR}"/* ; then
  echo "${PROGNAME:+$PROGNAME: }SUCCESS: installed fonts successfully."
  exit 0
else
  exit 1
fi
