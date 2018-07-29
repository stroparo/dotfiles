#!/usr/bin/env bash

: ${DEV:=${HOME}/workspace} ; export DEV

if [ ! -d "$DEV" ] ; then
  echo "################################################################################"
  echo "Workspace directory..."

  mkdir -p "${DEV}"
  echo "DEV dir created:"
  ls -d -l "${DEV}"

  echo "################################################################################"
fi

