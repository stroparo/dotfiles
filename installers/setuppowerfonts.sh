#!/usr/bin/env bash

PROGNAME="setuppowerfonts.sh"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi
if [ -e "$HOME/.local/share/fonts/Inconsolata for Powerline.otf" ] ; then
  echo "SKIP: Already installed." 1>&2
  exit
fi

echo "$PROGNAME: INFO: powerline fonts setup started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

# #############################################################################
# Main

wget https://github.com/powerline/fonts/archive/master.zip \
  -O ~/powerline.zip

(cd ~ ; unzip powerline.zip) \
  && ~/fonts-master/install.sh \
  && rm -rf ~/fonts-master ~/powerline.zip \
  || ls -d -l ~/fonts-master ~/powerline.zip

echo "$PROGNAME: COMPLETE: powerline fonts setup"
exit
