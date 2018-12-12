#!/bin/bash

BABUN_USR_DIR="/usr/local/etc/babun"

for file in \
  "${BABUN_USR_DIR}"/source/babun-core/plugins/core/src/babun.rc \
  "${BABUN_USR_DIR}"/source/babun-core/plugins/pact/src/pact \
  "${BABUN_USR_DIR}"/source/babun-packages/packages.groovy \
  "$(cygpath "$BABUN_HOME")"/*.bat
do
  if ! grep -q -- 'curl .*-k' "$file" ; then
    sed -i -e '!/\(dontremove=\|which\).*curl/s/curl /curl -k /' "$file"
  fi
  if ! grep -q -- 'wget .*--no-check-certificate' "$file" ; then
    sed -i -e '!/\(dontremove=\|which\).*wget/s/wget /wget --no-check-certificate /' "$file"
  fi
  grep --color=auto -- 'curl .*-k' "$file"
  grep --color=auto  -- 'wget .*--no-check-certificate' "$file"

  # Calls suffixed with '.exe':
  if [[ $file = *.bat ]] ; then
    if ! grep -q -- 'curl.exe .*-k' "$file" ; then
      sed -i -e '!/\(dontremove=\|which\).*curl/s/curl.exe /curl -k /' "$file"
    fi
    if ! grep -q -- 'wget.exe .*--no-check-certificate' "$file" ; then
      sed -i -e '!/\(dontremove=\|which\).*wget/s/wget.exe /wget.exe --no-check-certificate /' "$file"
    fi
    grep --color=auto -- 'curl.exe .*-k' "$file"
    grep --color=auto -- 'wget.exe .*--no-check-certificate' "$file"
  fi
done
