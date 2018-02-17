#!/usr/bin/env bash

# Cristian Stroparo's dotfiles - https://github.com/stroparo/dotfiles

PROGNAME=deploydotfiles.sh

echo
echo "==> Dotifying all files in conf/ to the home directory..."

for conf_item in $(ls -d ./conf/*) ; do
  destname="${HOME}/.${conf_item#./conf/}"
  if [ -d "$conf_item" ] ; then
    if [ ! -d "$destname" ] ; then
      mkdir "$destname"
      if [ ! -d "$destname" ] ; then
        echo "$PROGNAME: SKIP: could not mkdir '$destname'." 1>&2
        continue
      fi
    fi
    cp -f -R -v "${conf_item}"/* "$destname"/
  else
    cp -f -R -v "${conf_item}" "$destname"
  fi
done
