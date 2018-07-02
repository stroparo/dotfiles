#!/usr/bin/env bash

PROGNAME=deploydotfiles.sh
USAGE="[-v]"

# #############################################################################
# Globals

DOTDIR=./dotfiles
VERBOSE=false

# #############################################################################
# Helpers

_print_bar () {
  echo "################################################################################"
}

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

if ${VERBOSE:-false} ; then
  _print_bar
  echo "Dotfiles setup; \$0='$0'; \$PWD='$PWD'"
  echo "Op: conf/* -> \$HOME/.*"
fi

for dotfilename in $(ls -d "$DOTDIR"/*) ; do
  destname="${HOME}/.${dotfilename#$DOTDIR/}"
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
# Finish

if ${VERBOSE:-false} ; then echo "Dotfiles setup complete" ; _print_bar ; fi
