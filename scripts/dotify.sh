#!/usr/bin/env bash

echo
echo "==> Dotifying all files in conf/ to the home directory..."

for conf_item in $(ls -d ./conf/*) ; do
  cp -a -v "${conf_item}" "${HOME}/.${conf_item#./conf/}"
done
