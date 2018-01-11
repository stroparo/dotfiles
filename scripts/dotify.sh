#!/usr/bin/env bash

for filename in $(ls -d ./conf/*) ; do
  echo cp -a -v "${filename}" "${HOME}/.${filename#./conf/}"
done
