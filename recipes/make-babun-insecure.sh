#!/bin/bash

BABUN_USR_DIR="/usr/local/etc/babun"

for file in \
  "${BABUN_USR_DIR}"/source/babun-core/plugins/core/src/babun.rc \
  "${BABUN_USR_DIR}"/source/babun-core/plugins/pact/src/pact \
  "${BABUN_USR_DIR}"/source/babun-packages/packages.groovy \
  "$(cygpath "$BABUN_HOME")"/*.bat
do
  if ! grep -q -- 'curl .*-k' "$file" ; then
    sed -i -e 's/curl /curl -k /' "$file"
  fi
  if ! grep -q -- 'wget .*--no-check-certificate' "$file" ; then
    sed -i -e 's/wget /wget --no-check-certificate /' "$file"
  fi
  if [[ $file = *.bat ]] ; then
    if ! grep -q -- 'curl.exe .*-k' "$file" ; then
      sed -i -e 's/curl.exe /curl -k /' "$file"
    fi
    if ! grep -q -- 'wget.exe .*--no-check-certificate' "$file" ; then
      sed -i -e 's/wget.exe /wget.exe --no-check-certificate /' "$file"
    fi
  fi
done
