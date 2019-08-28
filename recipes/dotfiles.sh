#!/usr/bin/env bash

PROGNAME=dotfiles.sh
USAGE="[-v]"

# #############################################################################
# Globals

DOT_ASSETS_DIR="$PWD"/dotfiles
: ${VERBOSE:=false} ; export VERBOSE

# #############################################################################
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
# Main

echo "################################################################################"
echo "Dotfiles setup; \$0='$0'; \$PWD='$PWD'"
echo "Op: $DOT_ASSETS_DIR/* -> \$HOME/.*"

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

# #############################################################################
# Final sequence

echo "$PROGNAME: COMPLETE: deploying dotfiles in ${DOT_ASSETS_DIR}"
echo
