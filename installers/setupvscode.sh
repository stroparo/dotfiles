#!/usr/bin/env bash

PROGNAME="setupvscode.sh"
export VSCODEURL="https://code.visualstudio.com/docs/?dv=linux64_deb"

echo "$PROGNAME: INFO: setup started..."
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"

echo "$PROGNAME: INFO: starting browser with the official download URL..."
if which firefox ; then
  firefox "${VSCODEURL}" & disown
elif which google-chrome ; then
  google-chrome "${VSCODEURL}" & disown
elif which brave-browser ; then
  brave-browser "${VSCODEURL}" & disown
fi

echo "${PROGNAME:+$PROGNAME: }COMPLETE"
echo
echo
