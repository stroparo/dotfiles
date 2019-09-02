#!/usr/bin/env bash

DOT_ASSETS_DIR="${PWD}/dotfiles"

PROGNAME=dotfiles.sh

echo "$PROGNAME: INFO: Dotfiles deployment started"
echo "$PROGNAME: INFO: \$0='$0'; \$PWD='$PWD'"
echo "$PROGNAME: INFO: Op: '$DOT_ASSETS_DIR'/* -> \$HOME/.*"

# #############################################################################
# Globals

USAGE="[-v]"
: ${VERBOSE:=false} ; export VERBOSE

# Options:
OPTIND=1
while getopts ':hv' option ; do
  case "${option}" in
    v) VERBOSE=true;;
    h) echo "$USAGE"; exit;;
  esac
done
shift "$((OPTIND-1))"

# #############################################################################

for dotfilename in $(ls -d "$DOT_ASSETS_DIR"/*) ; do
  destname="${HOME}/.${dotfilename#$DOT_ASSETS_DIR/}"
  if [ -d "$dotfilename" ] ; then
    if [ ! -d "$destname" ] ; then
      mkdir "$destname" 2>/dev/null
      if [ ! -d "$destname" ] ; then
        echo "$PROGNAME: SKIP: could not mkdir '$destname'." 1>&2
        continue
      fi
    fi
    cp -f -R "${dotfilename}"/* "$destname"/
  else
    cp -f -R "${dotfilename}" "$destname"
  fi
done

echo "$PROGNAME: COMPLETE: Dotfiles deployment"
exit
