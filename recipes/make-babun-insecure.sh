#!/bin/bash

USR_DIR_BABUN="/usr/local/etc/babun"
WIN_HOME="$(cygpath "$USERPROFILE")"

for file in \
  "${USR_DIR_BABUN}"/source/babun-core/plugins/core/src/babun.rc \
  "${USR_DIR_BABUN}"/source/babun-core/plugins/pact/src/pact \
  "${USR_DIR_BABUN}"/source/babun-packages/packages.groovy \
  "${WIN_HOME}"/.babun/*.bat
do
  if ! grep -q 'wget .*--no-check-certificate' "$file" ; then
    sed -i -e 's/wget /wget --no-check-certificate /' "$file"
  fi
  if [[ $file = *.bat ]] ; then
    if ! grep -q 'wget.exe .*--no-check-certificate' "$file" ; then
      sed -i -e 's/wget.exe /wget.exe --no-check-certificate /' "$file"
    fi
  fi
done
