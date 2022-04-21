#!/usr/bin/env bash

PROGNAME="setupvscode.sh"
export VSCODEURL="https://code.visualstudio.com/docs/?dv=linux64_deb"

if ! (uname | grep -i -q linux) ; then echo "$PROGNAME: SKIP: Linux supported only" ; exit ; fi

echo "$PROGNAME: INFO: setup started..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

if egrep -i -q -r 'id[^=]*=arch' /etc/*release ; then
  yay -Sy visual-studio-code-bin

elif egrep -i -q -r 'debian|ubuntu' /etc/*release ; then
  echo "$PROGNAME: INFO: starting browser with the official download URL..."
  if which firefox ; then
    firefox "${VSCODEURL}" & disown
  elif which google-chrome ; then
    google-chrome "${VSCODEURL}" & disown
  elif which brave-browser ; then
    brave-browser "${VSCODEURL}" & disown
  fi
  read -p "Hit ENTER when ready to install (i.e. package has been downloaded to '${HOME}/Downloads/')..." dummy
  sudo gdebi "$(ls -1 ~/Downloads/code*.deb | tail -n 1)"
fi

echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
echo

exit
