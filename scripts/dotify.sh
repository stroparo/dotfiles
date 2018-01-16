#!/usr/bin/env bash

for conf_item in $(ls -d ./conf/*) ; do
  cp -a -v "${conf_item}" "${HOME}/.${conf_item#./conf/}"
done
