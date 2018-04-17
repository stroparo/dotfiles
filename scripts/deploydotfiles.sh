#!/usr/bin/env bash

# Cristian Stroparo's dotfiles

# Globals
PROGNAME=deploydotfiles.sh
DOTDIR=./dotfiles

echo
echo "==> Dotifying all files in conf/ to the home directory..."

for dotfilename in $(ls -d "$DOTDIR"/*) ; do
  destname="${HOME}/.${dotfilename#$DOTDIR/}"
  if [ -d "$dotfilename" ] ; then
    if [ ! -d "$destname" ] ; then
      mkdir "$destname"
      if [ ! -d "$destname" ] ; then
        echo "$PROGNAME: SKIP: could not mkdir '$destname'." 1>&2
        continue
      fi
    fi
    cp -f -R -v "${dotfilename}"/* "$destname"/
  else
    cp -f -R -v "${dotfilename}" "$destname"
  fi
done
