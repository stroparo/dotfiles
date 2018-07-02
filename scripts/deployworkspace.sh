#!/usr/bin/env bash
: ${DEV:=${HOME}/workspace} ; export DEV
if [ ! -d "$DEV" ] ; then
  mkdir -p "${DEV}"
  echo "DEV dir created:"
  ls -d -l "${DEV}"
fi
